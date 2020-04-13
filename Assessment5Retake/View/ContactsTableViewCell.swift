//
//  ContactsTableViewCell.swift
//  Assessment5Retake
//
//  Created by Hin Wong on 4/13/20.
//  Copyright © 2020 Hin Wong. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: - Properties
    
    var contact: Contacts? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Helper Function
    
    func updateViews() {
        guard let contact = contact else {return}
        nameLabel.text = contact.name
        phoneNumberLabel.text = contact.phoneNumber
        emailLabel.text = contact.email
    }
    
}
