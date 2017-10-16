//
//  ContactsInjector.swift
//  DailyZap
//
//  Created by David LoBosco on 10/1/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation
import Contacts

fileprivate struct ContactInstance {
    static let contactManager: ContactManager = ContactManager()
}

protocol ContactInjector { }
extension ContactInjector {
    var contactManager: ContactManager { return ContactInstance.contactManager }
}

class ContactManager {
    
    let store: CNContactStore = CNContactStore()
    let defaultContactKeys: [CNKeyDescriptor] = [CNContactGivenNameKey, CNContactFamilyNameKey,
                              CNContactPhoneNumbersKey, CNContactImageDataKey,
                              CNContactImageDataAvailableKey] as [CNKeyDescriptor]
    
    func requestAccess(completion: @escaping (Bool, Error?) -> Void) {
        self.store.requestAccess(for: .contacts, completionHandler: completion)
    }
    
    func isAuthorized() -> Bool {
        return CNContactStore.authorizationStatus(for: .contacts) == CNAuthorizationStatus.authorized
    }
    
    func getContactCount() -> Int {
        var contactCount = 0
        let fetch = CNContactFetchRequest(keysToFetch: [])
        try? self.store.enumerateContacts(with: fetch) { _,_ in
            contactCount+=1
        }
        return contactCount
    }

    func getRandomContact() -> CNContact? {
        let keys: [CNKeyDescriptor] = self.defaultContactKeys
        let fetch = CNContactFetchRequest(keysToFetch: keys)
        
        let count = self.getContactCount()
        var index = Int.random(upTo: count)
        var output:CNContact?
        
        try? self.store.enumerateContacts(with: fetch) { (contact, stop) in
            index -= 1
            if index == 0 {
                output = contact
            }
        }
        return output
    }
    
    func getContactWithID(contactID: String) -> CNContact? {
        let contact: CNContact? = try? store.unifiedContact(withIdentifier: contactID, keysToFetch: self.defaultContactKeys)
        return contact
    }
    // TODO who manages contact modal view for choosing custom contact
    // TODO feed fetch injector - parse the following into ui displayable objects (Extends contacts AND UserDefaultsInjector)
        // - fetch due (if empty -> generate with getRandomContact)
        // - fetch upcoming (no special behavior)
        // - update/delete/complete contact zap (How does this differ for due vs upcoming? Use subclassing!)
}
