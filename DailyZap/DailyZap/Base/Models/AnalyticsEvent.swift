//
//  AnalyticsEvent.swift
//  DailyZap
//
//  Created by David LoBosco on 4/18/18.
//  Copyright © 2018 dqlobo. All rights reserved.
//

import UIKit

enum AnalyticsEvent: Loggable {
    case onboard(OnboardEvent)
    case feed(FeedEvent)
    case settings(SettingsEvent)
    case launch(LaunchEvent)
    case view(ViewEvent)
    case featureRequest(description: String)
    
    var title: String {
        switch self {
        case .onboard(let event):
            return "Onboard\(event.title)"
        case .feed(let event):
            return "Feed\(event.title)"
        case .settings(let event):
            return "Settings\(event.title)"
        case .launch(let event):
            return "Launch\(event.title)"
        case .view(let event):
            return "View\(event.title)"
        case .featureRequest:
            return "FeatureRequest"
        }
    }
    var params: [String : String] {
        switch self {
        case .onboard(let event):
            return event.params
        case .feed(let event):
            return event.params
        case .settings(let event):
            return event.params
        case .launch(let event):
            return event.params
        case .view(let event):
            return event.params
        case .featureRequest(let description):
            return ["Description": description]
        }
    }
}

enum OnboardEvent: Loggable {
    case contact(PermissionEvent)
    case notification(PermissionEvent)
    case complete
    
    var title: String {
        switch self {
        case .contact(let e):
            return "Contact\(e.title)"
        case .notification(let e):
            return "Notification\(e.title)"
        case .complete:
            return "Complete"
        }
    }
    var params: [String : String] {
        switch self {
        case .contact(let e):
            return e.params
        case .notification(let e):
            return e.params
        case .complete:
            return [:]
        }
    }
}

enum ViewEvent: Loggable {
    case start(UIViewController)
    case end(UIViewController)
    
    var title: String {
        switch self {
        case .start(let vc), .end(let vc):
            return type(of: vc).description()
        }
    }
    var params: [String : String] {
        switch self {
        case .start(let vc), .end(let vc):
            return ["Screen": type(of: vc).description()]
        }
    }
}

enum LaunchEvent: Loggable {
    case notification
    case normal
    
    var title: String {
        switch self {
        case .notification:
            return "ByNotification"
        case .normal:
            return "BySpringboard"
        }
    }
    var params: [String : String] {
        return [:]
    }
}

enum PermissionEvent: Loggable {
    case accept, deny
    
    var title: String {
        switch self {
        case .accept:
            return "PermissionAccepted"
        case .deny:
            return "PermissionDenied"
        }
    }
    var params: [String : String] {
        return [:]
    }
}

enum FeedEvent: Loggable {
    case queueRandom
    case queueSpecific
    case zap(ZapEvent)
    case remove(RemoveEvent)
    
    var title: String {
        switch self {
        case .queueRandom:
            return "QueueRandom"
        case .queueSpecific:
            return "QueueSpecific"
        case .zap(let e):
            return "Zap\(e.title)"
        case .remove(let e):
            return "Remove\(e.title)"
        }
    }
    var params: [String : String] {
        switch self {
        case .zap(let event):
            return event.params
        case .remove(let event):
            return event.params
        default:
            return [:]
        }
    }
}

enum SettingsEvent: Loggable {
    case notification(PermissionEvent)
    case changeFreq(NotificationFrequency)
    case changeTime(NotificationTiming)
    
    var title: String {
        switch self {
        case .notification:
            return "ChangeNotification"
        case .changeFreq:
            return "ChangeFrequency"
        case .changeTime:
            return "ChangeTime"
        }
    }
    var params: [String : String] {
        switch self {
        case .changeFreq(let freq):
            return ["NewFrequency": freq == .daily ? "Daily" : "Weekly"]
        case .changeTime(let time):
            let def = time == .morning ? "Morning" : "Evening"
            return ["NewTime": time == .midday ? "Midday" : def]
        case .notification(let event):
            return event.params
        }
    }
}

enum RemoveEvent: Loggable {
    case blacklist
    case once
    case markDone
    
    var title: String {
        switch self {
        case .blacklist:
            return "Blacklist"
        case .once:
            return "Once"
        case .markDone:
            return "MarkDone"
        }
    }
    var params: [String : String] {
        return [:]
    }
}

enum ZapEvent: Loggable {
    case call(daysUntilDue: Int)
    case text(daysUntilDue: Int)
    
    var title: String {
        switch self {
        case .call:
            return "ByCall"
        case .text:
            return "ByText"
        }
    }
    var params: [String : String] {
        switch self {
        case .call(let days),
             .text(let days):
            return ["DaysUntilDue": "\(days)"]
        }
    }
}
