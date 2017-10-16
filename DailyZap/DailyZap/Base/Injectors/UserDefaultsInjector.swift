//
//  UserDefaultsInjector.swift
//  DailyZap
//
//  Created by David LoBosco on 10/15/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation


fileprivate typealias StoredContactQueue = Array<StoredContact>
fileprivate typealias SerializedStoredContact = Dictionary<String, Any>


fileprivate struct UserDefaultsInstance {
    static let userDefaultsManager: UserDefaultsManager = UserDefaultsManager()
}

protocol UserDefaultsInjector { }
extension UserDefaultsInjector {
    var userDefaultsManager: UserDefaultsManager { return UserDefaultsInstance.userDefaultsManager }
}


class UserDefaultsManager {
    let defaults = UserDefaults.standard
    let contactQueueKey = "ContactDefaultsKeyQueued"
    let contactDueKey = "ContactDefaultsKeyDue"
    
    init() {
        self.setupDefaults()
    }
    
    func setupDefaults() {
        _ = self.getDue()
        _ = self.getUpcoming()
    }
}

extension UserDefaultsManager { // due - public interface
    func setDueContact(contactID: String, due: Date) {
        let contact = StoredContact(contactID: contactID, due: due)
        self.setDue(contact)
    }
}

extension UserDefaultsManager { // upcoming - public interface
    func addUpcoming(contactID: String, due: Date) {
        let contact = StoredContact(contactID: contactID, due: due)
        var currentUpcoming = self.getUpcoming()
        currentUpcoming.append(contact)
    }
    func removeUpcoming(contactID: String) {
        var upcoming = getUpcoming()
        let index: Int? = upcoming.index { $0.contactID == contactID }
        if let toRemoveIndex = index {
            upcoming.remove(at: toRemoveIndex)
            self.setUpcoming(upcoming)
        }
    }
}

fileprivate extension UserDefaultsManager { // private defaults integrations
    
    func getDue() -> SerializedStoredContact {
        var due: SerializedStoredContact? = defaults.dictionary(forKey: contactDueKey)
        if due == nil {
            due = [:]
            defaults.set([:], forKey: contactDueKey)
        }
        return due!
    }
    
    func getUpcoming() -> StoredContactQueue {
        var queue: StoredContactQueue? = defaults.array(forKey: contactQueueKey) as? StoredContactQueue
        if queue == nil {
            queue = []
            defaults.set([], forKey: contactQueueKey)
        }
        return queue!
    }
    
    func setDue(_ due: StoredContact) {
        let serialized = due.serialize()
        defaults.set(serialized, forKey: contactDueKey)
    }
    
    func setUpcoming(_ upcoming: StoredContactQueue) {
        let serialized = upcoming.map { $0.serialize() }
        defaults.set(serialized, forKey: contactQueueKey)
    }
}


fileprivate class StoredContact {
    
    let contactID: String
    let due: Date
    
    static let contactIDKey: String = "ContactIDKey"
    static let dueKey: String = "dueKey"
    
    required init(contactID: String, due: Date) {
        self.contactID = contactID
        self.due = due
    }
}

fileprivate extension StoredContact { // serialization
    
    func serialize() -> SerializedStoredContact {
        return [
            StoredContact.contactIDKey : self.contactID,
            StoredContact.dueKey : self.due,
        ]
    }
    class func deserialize(from dict: SerializedStoredContact) -> StoredContact {
        let contactID: String = dict[StoredContact.contactIDKey] as! String
        let date: Date = dict[StoredContact.dueKey] as! Date
        return StoredContact(contactID: contactID, due: date)
    }
}


