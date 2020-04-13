//
//  ContactsDetailsViewController.swift
//  Assessment5Retake
//
//  Created by Hin Wong on 4/13/20.
//  Copyright © 2020 Hin Wong. All rights reserved.
//

import UIKit

class ContactsDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    //MARK: - Properties
    var contact: Contacts? 
    
    //MARK: - LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    //MARK: - HELPER FUNCTIONS
    func updateViews() {
        guard let contact = contact else { return }
        nameTextField.text = contact.name
        emailTextField.text = contact.email
        phoneNumberTextField.text = contact.phoneNumber
        self.title = contact.name
    }

    //MARK: - ACTIONS
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
            let email = emailTextField.text,
            let phoneNumber = phoneNumberTextField.text
            else { return }
        
        if let contact = self.contact {
            contact.name = name
            contact.email = email
            contact.phoneNumber = phoneNumber
            ContactsController.sharedInstance.updateContacts(contact: contact) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            ContactsController.sharedInstance.createContact(name: name, email: email, phoneNumber: phoneNumber) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}
