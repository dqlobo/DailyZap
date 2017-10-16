//
//  ContactsInjector.swift
//  DailyZap
//
//  Created by David LoBosco on 10/1/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation
import Contacts

fileprivate struct AppleContactsInstance {
    static let contactManager: AppleContactsManager = AppleContactsManager()
}

protocol AppleContactsInjector { }
extension AppleContactsInjector {
    var appleContactManager: AppleContactsManager { return AppleContactsInstance.contactManager }
}

class AppleContactsManager {
        // todo ability to actually mutate a contact
    let store: CNContactStore = CNContactStore()
    var defaultContactKeys: [CNKeyDescriptor] = [CNContactGivenNameKey, CNContactFamilyNameKey,
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
    
    func getContactsWithIDs(contactIDs: [String]) -> [CNContact] {
        let predicate = CNContact.predicateForContacts(withIdentifiers: contactIDs)
       
        let output = try? self.store.unifiedContacts(matching: predicate,
                                                     keysToFetch: self.defaultContactKeys)
        if output == nil {
            return []
        }
        return output!
    }
    
    // TODO who manages contact modal view for choosing custom contact
    // TODO feed fetch injector - parse the following into ui displayable objects (Extends contacts AND UserDefaultsInjector)
        // - fetch due (if empty -> generate with getRandomContact)
        // - fetch upcoming (no special behavior)
        // - update/delete/complete contact zap (How does this differ for due vs upcoming? Use subclassing!)
}
