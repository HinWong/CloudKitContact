//
//  ContactsController.swift
//  Assessment5Retake
//
//  Created by Hin Wong on 4/13/20.
//  Copyright © 2020 Hin Wong. All rights reserved.
//

import Foundation
import CloudKit

class ContactsController {
    
    //MARK: - Properties
    static let sharedInstance = ContactsController()
    let publicDB = CKContainer.default().publicCloudDatabase
    var contacts: [Contacts] = []
    
    //MARK: - CRUD
    
    func createContact(name: String, email: String, phoneNumber: String, completion: @escaping (Bool) -> Void) {
        
        let newContact = Contacts(name: name, email: email, phoneNumber: phoneNumber)
        let newRecord = CKRecord(contact: newContact)
        
        publicDB.save(newRecord) { (record, error) in
            if let error = error {
                print("Error creating contact, \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let record = record, let contact = Contacts(record: record) else {completion(false); return}
            self.contacts.append(contact)
            completion(true)
        }
    }
    
    func fetchContacts(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: ContactStrings.typeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching contacts, \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let records = records else {completion(false); return}
            
            let contacts: [Contacts] = records.compactMap({Contacts(record: $0)})
            self.contacts = contacts
            completion(true)
            return
        }
    }
    
    func updateContacts(contact: Contacts, completion: @escaping (Bool) -> Void) {
        let records = CKRecord(contact: contact)
        
        let operation = CKModifyRecordsOperation(recordsToSave: [records])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.queuePriority = .high
        operation.completionBlock = {
            completion(true)
            print("Contact updated")
        }
        
        publicDB.add(operation)
    }
    
    func deleteContact(contact: Contacts, completion: @escaping (Bool) -> Void) {
        publicDB.delete(withRecordID: contact.ckRecordID) { (record, error) in
            if let error = error {
                print("Error removing contact: \(error.localizedDescription)")
                completion(false)
                return
            }
            if let record = record {
                guard let index = self.contacts.firstIndex(of: contact) else { completion(false); return}
                self.contacts.remove(at: index)
                completion(true)
            }
        }
    }
}
