//
//  NotificationInjector.swift
//  DailyZap
//
//  Created by David LoBosco on 4/9/18.
//  Copyright © 2018 dqlobo. All rights reserved.
//

import UIKit
import UserNotifications

fileprivate struct NotificationManagerInstance {
    static let notificationManager: NotificationManager = NotificationManager()
}

protocol NotificationInjector  { }
extension NotificationInjector {
    var notificationManager: NotificationManager { return NotificationManagerInstance.notificationManager }
}

enum NotificationFrequency: Int {
    case daily
    case weekly    
}

enum NotificationTiming: Int {
    case morning
    case midday
    case evening
}

struct AuthenticationError: Error {}

class NotificationManager: NSObject, UserDefaultsInjector {
    private let notificationCenter = UNUserNotificationCenter.current()
    private(set) lazy var enabled = userDefaultsManager.notificationsEnabled
    private(set) lazy var frequency = userDefaultsManager.notificationFrequency
    private(set) lazy var timing = userDefaultsManager.notificationTiming
    
    func requestAccess(completion: ((Result<Bool>) -> Void)?) {
        notificationCenter.requestAuthorization(options: [.alert, .badge]) { [weak self] success, error in
            DispatchQueue.main.sync {
                if let e = error {
                    completion?(.failure(e))
                    self?.enabled = false
                    self?.didSetEnabled()
                } else {
                    self?.enabled = success
                    self?.didSetEnabled()
                    completion?(.success(success))
                }
            }
        }
    }
    
    func configureDelegate() {
        notificationCenter.delegate = self
    }

    func registerForNotifications() {
        notificationCenter.setNotificationCategories([CategoryFactory.makeReminderCategory()])
    }    
    
    func setEnabled(_ flag: Bool, _ completion: ((Result<Bool>) -> Void)? = nil) {
        notificationCenter.getNotificationSettings { settings in
            
            DispatchQueue.main.async {  [weak self] in
                guard let strong = self else { return }
                switch settings.authorizationStatus {
                case .authorized:
                    strong.enabled = flag
                    strong.didSetEnabled()
                    completion?(.success(flag))
                case .notDetermined:
                    strong.requestAccess(completion: completion)
                    break
                case .denied:
                    strong.enabled = false
                    strong.didSetEnabled()
                    completion?(.failure(AuthenticationError()))
                }
            }
        }
    }
    
    func checkSystemSettingsChange() {
        setEnabled(enabled)
    }
    
    private func didSetEnabled() {
        userDefaultsManager.notificationsEnabled = enabled
        if enabled {
            queueReminderRequest()
        } else {
            notificationCenter.removeAllPendingNotificationRequests()
            notificationCenter.removeAllDeliveredNotifications()
        }
    }
    
    func setFrequency(_ freq: NotificationFrequency) {
        frequency = freq
        userDefaultsManager.notificationFrequency = freq
        queueReminderRequest()
    }
    func setTiming(_ time: NotificationTiming) {
        timing = time
        userDefaultsManager.notificationTiming = time
        queueReminderRequest()
    }
    
    private func queueReminderRequest() {
        let req = NotificationRequestFactory.makeReminderRequest(frequency: frequency,
                                                                 timing: timing)
        notificationCenter.add(req, withCompletionHandler: { _ in
            // TODO handle error in completionHandler
        })
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    // called on respond to a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    }
}

class NotificationRequestFactory {
    static let reminderRequestID = "ZAPReminderRequest"

    private class func dateFor(frequency: NotificationFrequency, timing: NotificationTiming) -> DateComponents {
        var comps = DateComponents()
        if case .weekly = frequency {
            comps.weekday = Calendar.current.dateComponents([.weekday], from: Date()).weekday
        }
        
        switch timing {
        case .morning:
            comps.hour = 9
            comps.minute = 0
        case .midday:
            comps.hour = 12
            comps.minute = 30
        case .evening:
            comps.hour = 19
            comps.minute = 0
        }

        return comps
    }
    
    
    
    class func makeReminderRequest(frequency: NotificationFrequency, timing: NotificationTiming) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.body = "Don't forget to supercharge your network! ⚡️"
        content.categoryIdentifier = CategoryFactory.reminderCategoryID
        let datePattern = dateFor(frequency: frequency, timing: timing)
        let trigger = UNCalendarNotificationTrigger(dateMatching: datePattern, repeats: true)
        
        return UNNotificationRequest(identifier: reminderRequestID,
                                     content: content,
                                     trigger: trigger)
    }
}

class CategoryFactory {
    static let reminderCategoryID = "ReminderNotificationID"
    class func makeReminderCategory() -> UNNotificationCategory {
        let placeholder = "Don't forget to supercharge your network today ⚡️"
        if #available(iOS 11.0, *) {
            return UNNotificationCategory(identifier: reminderCategoryID,
                                          actions: [],
                                          intentIdentifiers: [],
                                          hiddenPreviewsBodyPlaceholder: placeholder,
                                          options: [])
        } else {
            return UNNotificationCategory(identifier: reminderCategoryID,
                                          actions: [],
                                          intentIdentifiers: [],
                                          options: [])
        }
    }
    
}
