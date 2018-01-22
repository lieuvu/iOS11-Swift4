//
//  CustomMessageCell.swift
//  Flash Chat
//
//  Created by Lieu Vu.
//  

import UIKit

class CustomMessageCell: UITableViewCell {

    // MARK: Outlets
    // **********************************************************************
    
    /// The background of a message.
    @IBOutlet weak var messageBackground: UIView!
    
    /// The avatar image of a message.
    @IBOutlet weak var avatarImageView: UIImageView!
    
    /// The message label.
    @IBOutlet weak var messageBody: UILabel!
    
    /// The sender label of a meassge.
    @IBOutlet weak var senderUsername: UILabel!
    
    
    // MARK: Initialization
    // **********************************************************************
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
    }
}
