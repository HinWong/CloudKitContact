//
//  Contacts.swift
//  Assessment5Retake
//
//  Created by Hin Wong on 4/13/20.
//  Copyright © 2020 Hin Wong. All rights reserved.
//

import Foundation
import CloudKit

struct ContactStrings {
    static let typeKey = "Contact"
    fileprivate static let nameKey = "name"
    fileprivate static let emailKey = "email"
    fileprivate static let phoneNumberKey = "phonenumber"
}

class Contacts {
    
    var name: String
    var email: String
    var phoneNumber: String
    var ckRecordID: CKRecord.ID
    
    init(name: String, email: String, phoneNumber: String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.ckRecordID = ckRecordID
    }
    
    convenience init?(record: CKRecord) {
        guard let name = record[ContactStrings.nameKey] as? String,
            let email = record[ContactStrings.emailKey] as? String,
            let phoneNumber = record[ContactStrings.phoneNumberKey] as? String
            else { return nil }
        
        self.init(name: name, email: email, phoneNumber: phoneNumber, ckRecordID: record.recordID)
    }
}

extension CKRecord {
    convenience init(contact: Contacts) {
        self.init(recordType: ContactStrings.typeKey, recordID: contact.ckRecordID)
        
        setValue(contact.name, forKey: ContactStrings.nameKey)
        setValue(contact.email, forKey: ContactStrings.emailKey)
        setValue(contact.phoneNumber, forKey: ContactStrings.phoneNumberKey)
    }
}

extension Contacts: Equatable {
    static func == (lhs: Contacts, rhs: Contacts) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}
