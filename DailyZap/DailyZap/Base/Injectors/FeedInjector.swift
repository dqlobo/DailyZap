//
//  DataSourceInjector.swift
//  DailyZap
//
//  Created by David LoBosco on 10/15/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation


fileprivate struct FeedInstance {
    static let dataSourceManager: FeedManager = FeedManager()
}

protocol FeedInjector { }
extension FeedInjector {
    var feedManager: FeedManager { return FeedInstance.dataSourceManager }
}

class FeedManager: UserDefaultsInjector, AppleContactsInjector {
    
    var feed: Feed {
        let upcoming = self.userDefaultsManager.getUpcoming()
        if upcoming.isEmpty {
            if let contact = self.getRandom(due: Date()) {
                self.addToFeed(contact: contact)
            }
        }
        
        let inflatedContacts = self.inflate(contacts: upcoming)
        return Feed(queue: inflatedContacts)
    }
}

extension FeedManager { // feed manipulation
    
    func addToFeed(contact: Contact, due: Date = Date.oneWeekFromNow()) {
        self.userDefaultsManager.addToQueue(contactID: contact.contactID, due: due)
        // TODO inflate first
        self.feed.add(contact: contact)
    }
    
    func removeFromFeed(contact: Contact) {
        self.userDefaultsManager.removeFromQueue(contactID: contact.contactID)
        self.feed.remove(contact: contact)
    }
    
    func addToBlackList(contact: Contact) {
        
    }
}

extension FeedManager { // contact generation
    func getRandom(due: Date) -> Contact? {
        if let contact = self.appleContactManager.getRandomContact() {
            return Contact(contactID: contact.identifier, due: due)
        } // else { error generating random contact }
        return nil
    }
}

fileprivate extension FeedManager {
    func inflate(contacts: [Contact]) -> [Contact] {
        let contactIDs = contacts.map { $0.contactID }
        let contactMap = Dictionary(uniqueKeysWithValues: zip(contactIDs, contacts))
        let appleContacts = self.appleContactManager.getContactsWithIDs(contactIDs: contactIDs)
        
        // convert to [Contact]
        return appleContacts.map({ appleContact -> Contact in
            var current = contactMap[appleContact.identifier]
            if current == nil {
                current = Contact(contactID: appleContact.identifier)
            }
            let contact = current!
            contact.firstName = appleContact.givenName
            contact.lastName = appleContact.familyName
            return contact            
        })
    }
}

