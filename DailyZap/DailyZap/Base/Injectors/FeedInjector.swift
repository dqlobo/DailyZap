//
//  DataSourceInjector.swift
//  DailyZap
//
//  Created by David LoBosco on 10/15/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation
import Contacts

fileprivate struct FeedInstance {
    static let dataSourceManager: FeedManager = FeedManager()
}

protocol FeedInjector { }
extension FeedInjector {
    var feedManager: FeedManager { return FeedInstance.dataSourceManager }
}

// FeedManager acts as an intermediary between UserDefaultsInjector, AppleContactsInjector
// to find and store contacts as the user interacts with the feed.
class FeedManager: UserDefaultsInjector, AppleContactsInjector {
    
    var feed: Feed {
        let upcoming = userDefaultsManager.getUpcoming()
        if upcoming.isEmpty {
            if let contact = getRandom(due: Date()) {
                addToFeed(contact: contact)
            }
        }
        
        let inflatedContacts = inflate(contacts: upcoming)
        return Feed(queue: inflatedContacts)
    }
}

extension FeedManager { // feed manipulation
    
    func addToFeed(contact: Contact) {
        userDefaultsManager.addToQueue(contactID: contact.contactID, due: contact.due)
        // TODO inflate first
        feed.add(contact: contact)
    }
    
    func removeFromFeed(contact: Contact) {
        userDefaultsManager.removeFromQueue(contactID: contact.contactID)
        feed.remove(contact: contact)
    }
    
    func addToBlackList(contact: Contact) {
        
    }
}

extension FeedManager { // contact generation
    func getRandom(due: Date) -> Contact? {
        if let contact = appleContactManager.getRandomContact() {
            return Contact(contactID: contact.identifier, due: due)
        } // else { error generating random contact }
        return nil
    }
    func addRandom() {
        if let cn = getRandom(due: Date.oneWeekFromNow()) {
            addToFeed(contact: cn)
        }
    }
    func getAppleContact(for contact: Contact) -> CNContact? {
        return appleContactManager.getContactWithID(contactID: contact.contactID)
    }
}

extension FeedManager {
    // Transform array of Contacts with just ids to array of fully attributed Contacts
    func inflate(contacts: [Contact]) -> [Contact] {
        let contactIDs = contacts.map { $0.contactID }
        let contactMap = Dictionary(uniqueKeysWithValues: zip(contactIDs, contacts))
        let appleContacts = appleContactManager.getContactsWithIDs(contactIDs: contactIDs)
        
        // convert to [Contact]
        return mapAppleContacts(appleContacts: appleContacts, existingContactMap: contactMap)
    }
    
    func mapAppleContacts(appleContacts: [CNContact], existingContactMap: [String : Contact]? = nil) -> [Contact] {
        // pass existing contact map to save due date if inflating from Contact -> CNContact -> Contact
        return appleContacts.map({ appleContact -> Contact in
            var current = existingContactMap?[appleContact.identifier]
            if current == nil {
                current = Contact(contactID: appleContact.identifier)
            }
            let contact = current!
            contact.firstName = appleContact.givenName
            contact.lastName = appleContact.familyName
            contact.imageData = appleContact.imageData
            if let phoneNumber = appleContact.phoneNumbers.first?.value.stringValue {
                contact.primaryPhone = phoneNumber
            }
            return contact
        })
    }
}

