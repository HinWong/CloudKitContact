//
//  ContactsListTableViewController.swift
//  Assessment5Retake
//
//  Created by Hin Wong on 4/13/20.
//  Copyright © 2020 Hin Wong. All rights reserved.
//

import UIKit

class ContactsListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: - Helper Functions
    
    func fetchContacts() {
        ContactsController.sharedInstance.fetchContacts { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactsController.sharedInstance.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell", for: indexPath) as? ContactsTableViewCell else { return UITableViewCell() }

        let contact = ContactsController.sharedInstance.contacts[indexPath.row]
        cell.contact = contact

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = ContactsController.sharedInstance.contacts[indexPath.row]
            ContactsController.sharedInstance.deleteContact(contact: contact) { (success) in
                if success {
                    print("Contact deleted")
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContactDetailsVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? ContactsDetailsViewController
                else { return }
            let contact = ContactsController.sharedInstance.contacts[indexPath.row]
            destinationVC.contact = contact
        }
    }
}
