//
//  Contact.swift
//  DailyZap
//
//  Created by David LoBosco on 10/15/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation


class Contact {
    
    let contactID: String
    let due: Date
    
    var firstName: String = ""
    var lastName: String = ""
    
    var fullName: String  {
        return self.firstName + " " + self.lastName
    }
    
    static let contactIDKey: String = "ContactIDKey"
    static let dueKey: String = "dueKey"
    
    required init(contactID: String, due: Date = Date.oneWeekFromNow()) {
        self.contactID = contactID
        self.due = due
    }
}


extension Contact: CustomStringConvertible, Equatable { // inheritance
    var description: String {
        return String.init(format: "[Contact] %@ - %@", self.due.description, self.contactID)
    }
    
    static func ==(lhs:Contact, rhs:Contact) -> Bool {
        return lhs.contactID == rhs.contactID
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
