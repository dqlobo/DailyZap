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
    fileprivate let backgroundQueue = DispatchQueue(label: "Contact-Background-Queue")
    static let loadedContactsNotification = NSNotification.Name("ContactListFinishedLoading")

    let store: CNContactStore = CNContactStore()
    var isLoading: Bool = false
    var contactList: Array<Contact> = []
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

    fileprivate func allContactFetch() -> CNContactFetchRequest {
        let keys: [CNKeyDescriptor] = defaultContactKeys
        let fetch = CNContactFetchRequest(keysToFetch: keys)
        fetch.sortOrder = .givenName
        fetch.unifyResults = true
        return fetch
    }
    
    func getRandomContact() -> CNContact? {
        let fetch = self.allContactFetch()
        
        let count = self.getContactCount()
        var index = Int.random(upTo: count)
        var output:CNContact?
        // TODO sort by name + store ids in array -> use this as datasource later..?
        try? self.store.enumerateContacts(with: fetch) { (contact, stop) in
            index -= 1
            if index == 0 {
                output = contact
            }
        }
        return output
    }
    
    func getContactWithID(contactID: String, keysToFetch: [CNKeyDescriptor] = []) -> CNContact? {
        let contact: CNContact? = try? store.unifiedContact(withIdentifier: contactID, keysToFetch: defaultContactKeys + keysToFetch)
        return contact
    }
    
    func getContactsWithIDs(contactIDs: [String]) -> [CNContact] {
        let predicate = CNContact.predicateForContacts(withIdentifiers: contactIDs)
       
        let output = try? store.unifiedContacts(matching: predicate,
                                                keysToFetch: self.defaultContactKeys)
        if output == nil {
            return []
        }
        return output!
    }
    
    func refreshContactList() {
        isLoading = true
        backgroundQueue.async { [weak self] in
            guard let strong = self else { return }
            var set = Set<Contact>()
            let fetch = strong.allContactFetch()
            try? strong.store.enumerateContacts(with: fetch) { (contact, stop) in
                let c: Contact = Contact(contact: contact)
                if c.hasName {
                    set.insert(c)
                }
            }
            DispatchQueue.main.sync { [weak self] in
                self?.isLoading = false
                self?.contactList = set.sorted { $0.lastName < $1.lastName }
                NotificationCenter.default.post(name: AppleContactsManager.loadedContactsNotification, object: nil)
            }
        }
    }
    
}

