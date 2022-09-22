//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

//        animateText()
        titleLabel.text = K.appName
    }
    
    // MARK: - Helper
    func animateText(){
        titleLabel.text = ""
        var characterIndex = 0.0
        let titleText = K.appName
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * characterIndex, repeats: false) { timer in
                self.titleLabel.text?.append(letter)
            }
            characterIndex += 1
        }
    }
    

}
