//
//  Contact.swift
//  DailyZap
//
//  Created by David LoBosco on 10/15/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation
import Contacts

class Contact: Hashable {
    
    let contactID: String
    let due: Date
    
    var firstName: String = ""
    var lastName: String = ""
    var primaryPhone: String = ""
    var imageData: Data? = nil
    var hasName: Bool {
        return !(firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }
    var fullName: String  {
        return self.firstName + " " + self.lastName
    }
    
    static let contactIDKey: String = "ContactIDKey"
    static let dueKey: String = "dueKey"
    
    required init(contactID: String, due: Date = Date.oneWeekFromNow()) {
        self.contactID = contactID
        self.due = due
    }
    convenience init(contact: CNContact) {
        self.init(contactID: contact.identifier)
        self.firstName = contact.givenName
        self.lastName = contact.familyName
        self.imageData = contact.imageData
        if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
            primaryPhone = phoneNumber
        }
    }
   
}


extension Contact { // inheritance
    var description: String {
        return String.init(format: "[Contact] %@ - %@", self.due.description, self.contactID)
    }
    
    static func ==(lhs:Contact, rhs:Contact) -> Bool {
//        let shareID = lhs.contactID == rhs.contactID
//        let shareName = !lhs.fullName.isEmpty && lhs.fullName == rhs.fullName
        let shareNumber = phoneNumberMatch(lhs.primaryPhone, rhs.primaryPhone)
        return shareNumber // shareID || shareName ||
    }
    
    var hashValue: Int {
//        print(Contact.getBarePhone(num: primaryPhone))
        return Contact.getBarePhone(num: primaryPhone).hashValue
    }
    
    static func getBarePhone(num: String) -> String {
        let isNumber = { (a: Character) -> Bool in
            if let uni = Unicode.Scalar("\(a)"){
                return CharacterSet.decimalDigits.contains(uni)
            }
            return false
        }
        return num.filter(isNumber)
    }
    
    static func phoneNumberMatch(_ a: String, _ b: String) -> Bool {
        return a == b ||
            getBarePhone(num: a) == getBarePhone(num: b)
    }
}


typealias SerializedContact = Dictionary<String, Any>

extension Contact { // serialization
    
    func serialize() -> SerializedContact {
        return [
            Contact.contactIDKey : self.contactID,
            Contact.dueKey : self.due,
        ]
    }
    
    class func deserialize(from dict: SerializedContact) -> Contact {
        let contactID: String = dict[Contact.contactIDKey] as! String
        let date: Date = dict[Contact.dueKey] as! Date
        return Contact(contactID: contactID, due: date)
    }
}
