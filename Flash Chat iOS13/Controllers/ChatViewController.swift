//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    // MARK: - Variants
    let db = Firestore.firestore()
    var message: [Message] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        configNavigation()
        
        messageTextfield.delegate = self
        
        loadMessages()
    }
    
    // MARK: - IBAction
    @IBAction func sendPressed(_ sender: UIButton) {
        sendMessage()
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            showAlertError(error: signOutError.localizedDescription)
            
        }
    }
    
    // MARK: - Helper
    func configNavigation(){
        navigationItem.hidesBackButton = true
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: K.BrandColors.purple)
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    func configTableView(){
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    func sendMessage(){
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email, messageBody.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            messageTextfield.text = nil
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date.timeIntervalSinceReferenceDate
            ]) { error in
                if let e = error {
                    self.showAlertError(error: e.localizedDescription)
                }
            }
        }
    }
    
    func showAlertError(error: String){
        let alertController = UIAlertController.init(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Try Again", style: .cancel)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
    
    func loadMessages(){
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
            if let e = error {
                self.showAlertError(error: e.localizedDescription)
                } else {
                    self.message = []
                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        let messageSender = data[K.FStore.senderField] as! String
                        let messageBody = data[K.FStore.bodyField] as! String
                        self.message.append(Message(sender: messageSender, body: messageBody))
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        let indexPath = IndexPath(row: self.message.count - 1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                    }
                }
        }
    }
    
}

// MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    //So luong cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    //Ten cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageTableViewCell
        cell.updateUI(isCurrentUser: (message[indexPath.row].sender == Auth.auth().currentUser?.email))
        cell.messageLabel.text = message[indexPath.row].body
        return cell
        
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
    
    
}
