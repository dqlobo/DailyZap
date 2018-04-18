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
    
    let blacklistKey = "BlacklistDefaultsKey"
    
    let pointsKey = "ZapPointsDefaultsKey"
    let lastZappedKey = "LastZappedDefaultsKey"

    let notificationOnKey = "NotificationsOnDefaultsKey"
    let notificationFrequencyKey = "NotificationFrequencyDefaultsKey"
    let notificationTimingKey = "NotificationTimingDefaultsKey"
    
    
    init() {
        setupDefaults()
    }
    
    func setupDefaults() {
        _ = getUpcoming()
    }
}


// MARK: - Simple Storage
extension UserDefaultsManager {
    private(set) var lastZappedDate: Date {
        get {
            return defaults.value(forKey: lastZappedKey) as? Date ?? Date.distantPast
        }
        set {
            defaults.set(newValue, forKey: lastZappedKey)
        }
    }
    
    func markLastZappedDate() {
        lastZappedDate = Date()
    }

    var points: Int64 {
        get {
            guard let pts = defaults.value(forKey: pointsKey) as? Int64 else {
                return 0
            }
            return pts
        }
        set {
            defaults.set(NSNumber(value: newValue),
                         forKey: pointsKey)
        }
    }
    
    // MARK: - Notifications
    
    var notificationsEnabled: Bool {
        get {
            let isOn = defaults.value(forKey: notificationOnKey) as? Bool
            return isOn ?? false          
        }
        set {
            defaults.set(newValue, forKey: notificationOnKey)
        }
    }
    
    var notificationFrequency: NotificationFrequency {
        get {
            let def = NotificationFrequency.daily
            let freqValue = defaults.value(forKey: notificationFrequencyKey) as? Int
            let freq = NotificationFrequency(rawValue: freqValue ?? def.rawValue)
            return freq ?? def
        }
        set {
            defaults.set(newValue.rawValue, forKey: notificationFrequencyKey)
        }
    }
 
    var notificationTiming: NotificationTiming {
        get {
            let def = NotificationTiming.midday
            let timeVal = defaults.value(forKey: notificationTimingKey) as? Int
            let time = NotificationTiming(rawValue: timeVal ?? def.rawValue)
            return time ?? def
        }
        set {
            defaults.set(newValue.rawValue, forKey: notificationTimingKey)
        }
    }
}

// MARK: - Complicated storage

extension UserDefaultsManager {
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
    
    // Contact Todo List
    
    func hasContactWithID(contactID: String) -> Bool {
        let contactIDs = getUpcoming().map { c in c.contactID }
        return contactIDs.contains(contactID)
    }
    
    func getUpcoming() -> [Contact] {
        guard let queue = defaults.array(forKey: contactQueueKey) as? [SerializedContact] else {
            defaults.set([], forKey: contactQueueKey)
            return []
        }
        return queue.map { Contact.deserialize(from: $0) }
    }
    
    func setUpcoming(_ upcoming: [Contact]) {
        let serialized = upcoming.map { $0.serialize() }
        defaults.set(serialized, forKey: contactQueueKey)
    }

    // Blacklist
    
    func addToBlacklist(contactID: String) {
        var list = Set(getBlackList())
        list.insert(contactID)
        defaults.set(Array(list), forKey: blacklistKey)
    }
    
    func removeFromBlacklist(contactID: String) {
        var list = Set(getBlackList())
        list.remove(contactID)
        defaults.set(Array(list), forKey: blacklistKey)
    }
    
    func isOnBlackList(contactID: String) -> Bool {
        var b = false
        getBlackList().forEach { b = b || $0 == contactID }
        return b
    }
    
    private func getBlackList() -> [String] {
        guard let list = defaults.array(forKey: blacklistKey) as? [String] else {
            defaults.set([], forKey: blacklistKey)
            return []
        }
        return list
    }
}
