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
    
    init() {
         NotificationCenter.default.addObserver(self, selector: #selector(didChangeContactStore(notification:)), name: NSNotification.Name.CNContactStoreDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var feed: Feed {
        let upcoming = userDefaultsManager.getUpcoming()
        let inflatedContacts = inflate(contacts: upcoming)
        let feed = Feed(queue: inflatedContacts)
        if feed.due.isEmpty
            && userDefaultsManager.lastZappedDate.daysUntil(date: Date()) >= daysInInterval {
            // queue a random zap if a couple days has passed
            //TODO background thread
            addRandom()
        }

        return feed
    }
    
    private var daysInInterval: Int {
        return userDefaultsManager.notificationFrequency == .daily
            || !userDefaultsManager.notificationsEnabled ? 1 : 7
    }
    
    @objc private func didChangeContactStore(notification: NSNotification) {
        // do not need to do anything since contacts list is COPIED and refreshed regularly
    }
}

extension FeedManager { // feed manipulation
    func isQueued(contact: Contact) -> Bool {
        return userDefaultsManager.hasContactWithID(contactID: contact.contactID)
    }
    func addToFeed(contact: Contact) -> Bool {
        guard !isQueued(contact: contact) else { return false }
        
        userDefaultsManager.addToQueue(contactID: contact.contactID, due: contact.due)
        feed.add(contact: contact)
        return true
    }
    
    func didZap(contact: Contact) {
        userDefaultsManager.markLastZappedDate()
        removeFromFeed(contact: contact)
    }
    
    func removeFromFeed(contact: Contact) {
        userDefaultsManager.removeFromQueue(contactID: contact.contactID)
        feed.remove(contact: contact)
    }
    
    func addToBlackList(contact: Contact) {
        userDefaultsManager.removeFromQueue(contactID: contact.contactID)
        userDefaultsManager.addToBlacklist(contactID: contact.contactID)
        feed.remove(contact: contact)
    }
}

extension FeedManager { // contact generation
    private func getRandom(due: Date) -> Contact? {
        if let contact = appleContactManager.getRandomContact() {
            return Contact(contactID: contact.identifier, due: due)
        }
        return nil
    }
    
    @objc func addRandom() {
        var success = false
        var tries = 0
        repeat {
           if let cn = getRandom(due: Date()),
                let inflated = inflate(contacts: [cn]).first,
                inflated.hasName,
                !userDefaultsManager.isOnBlackList(contactID: cn.contactID) {
                success = addToFeed(contact: cn)
            }
            tries += 1
        } while !success && tries < 3
        
    }
    
    func getAppleContact(for contact: Contact) -> CNContact? {
        return appleContactManager.getContactWithID(contactID: contact.contactID)
    }
}

extension FeedManager {
    // Transform array of Contacts with just ids to array of fully attributed Contacts
    func inflate(contacts: [Contact]) -> [Contact] {
        let contactIDs = contacts.map { $0.contactID }
        // TODO can have duplicate values below
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

