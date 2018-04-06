//
//  UserDefaultsInjector.swift
//  DailyZap
//
//  Created by David LoBosco on 10/15/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation

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
    
    init() {
        setupDefaults()
    }
    
    func setupDefaults() {
        _ = getUpcoming()
    }
}

extension UserDefaultsManager { // upcoming - public interface
    
    func addToQueue(contactID: String, due: Date) {
        let contact = Contact(contactID: contactID, due: due)
        var currentUpcoming = getUpcoming()
        currentUpcoming.append(contact)
        setUpcoming(currentUpcoming)
    }
    
    func removeFromQueue(contactID: String) {
        var upcoming = getUpcoming()
        let index: Int? = upcoming.index { $0.contactID == contactID }
        if let toRemoveIndex = index {
            upcoming.remove(at: toRemoveIndex)
            setUpcoming(upcoming)
        }
    }
}

extension UserDefaultsManager { // private defaults integrations
    
    func hasContactWithID(contactID: String) -> Bool {
        let contactIDs = self.getUpcoming().map { c in c.contactID }
        
        return contactIDs.contains(contactID)
    }
    
    func getUpcoming() -> [Contact] {
        guard let queue = defaults.array(forKey: contactQueueKey) as? [SerializedContact] else {
            defaults.set([], forKey: contactQueueKey)
            return []
        }
        let deserialized: [Contact] = queue.map { Contact.deserialize(from: $0) }
        return deserialized
    }
    
    
    func setUpcoming(_ upcoming: [Contact]) {
        let serialized = upcoming.map { $0.serialize() }
        defaults.set(serialized, forKey: contactQueueKey)
    }
}


