//
//  AnalyticsInjector.swift
//  DailyZap
//
//  Created by David LoBosco on 10/4/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation
import UIKit

fileprivate struct AnalyticsInstance {
    static let analytics: AnalyticsManager = AnalyticsManager()
}

protocol AnalyticsInjector { }
extension AnalyticsInjector {
    var analytics: AnalyticsManager { return AnalyticsInstance.analytics }
}

class AnalyticsManager {
//    func log(_ event: AnalyticsEvent) {
//
//    }
    
}
protocol Loggable {
    func log()
}
//
//extension Loggable {
//    func baseLog() -> Dictionary {
//        return [:]
//    }
//}
//
//enum AnalyticsEvent: Loggable {
//    case onboard(OnboardEvent)
//    case feed(FeedEvent)
//    case settings(SettingsEvent)
//    case launch(LaunchEvent)
//    case view(ViewEvent)
//    func log() {
//        let a = baseLog()
//    }
//}
//
//enum OnboardEvent: Loggable {
//    case contact(PermissionEvent)
//    case notification(PermissionEvent)
//    case complete
//}
//
//enum ViewEvent: Loggable {
//    case start(UIViewController)
//    case end(UIViewController)
//}
//
//enum LaunchEvent: Loggable {
//    case notification
//    case normal
//}
//
//enum PermissionEvent: Loggable {
//    case accept, deny
//}
//
//enum FeedEvent: Loggable {
//    case queueRandom
//    case queueSpecific
//    case zap(ZapEvent)
//    case remove(RemoveEvent)
//}
//
//enum SettingsEvent: Loggable {
//    case notification(PermissionEvent)
//    case changeFreq(NotificationFrequency)
//    case changeTime(NotificationTiming)
//}
//
//enum RemoveEvent: Loggable {
//    case blacklist
//    case once
//    case markDone
//}
//
//enum ZapEvent: Loggable {
//    case call(daysUntilDue: Int)
//    case text(daysUntilDue: Int)
//}

