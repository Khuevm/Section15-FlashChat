//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    // MARK: - IBAction
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
                if let e = error {
                    //description bằng ngôn ngữ của user
                    let description = e.localizedDescription
                    self.showAlertError(error: description)
                } else {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }
    
    // MARK: - Helper
    func showAlertError(error: String){
        let alertController = UIAlertController.init(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Try Again", style: .cancel)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}
