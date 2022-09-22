//
//  MessageTableViewCell.swift
//  Flash Chat iOS13
//
//  Created by Khue on 08/09/2022.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var leftAvatarImageView: UIImageView!
    @IBOutlet weak var rightAvatarImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageBubble: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        messageBubble.layer.cornerRadius = messageBubble.frame.height / 10
    }
    
    func updateUI(isCurrentUser: Bool){
        if isCurrentUser {
            leftAvatarImageView.isHidden = true
            rightAvatarImageView.isHidden = false
            messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            messageLabel.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            leftAvatarImageView.isHidden = false
            rightAvatarImageView.isHidden = true
            messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            messageLabel.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
