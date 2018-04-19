//
//  AnalyticsInjector.swift
//  DailyZap
//
//  Created by David LoBosco on 10/4/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation
import UIKit
import Flurry_iOS_SDK

fileprivate struct AnalyticsInstance {
    static let analytics: AnalyticsManager = AnalyticsManager()
}

protocol AnalyticsInjector { }
extension AnalyticsInjector {
    var analytics: AnalyticsManager { return AnalyticsInstance.analytics }
}

class AnalyticsManager {
   
    func beginSession() {
        let builder = FlurrySessionBuilder()
            .withLogLevel(FlurryLogLevelDebug)
            .withCrashReporting(true)
            .withAppVersion(Constants.appVersion)
        Flurry.startSession(Constants.flurryKey, with: builder)
    }
   
    func log(_ event: AnalyticsEvent) {
        switch event {
        case .view(.start):
            Flurry.logEvent(event.title, timed: true)
        case .view(.end):
            Flurry.endTimedEvent(event.title, withParameters: event.params)
        default:
            Flurry.logEvent(event.title, withParameters: event.params)
        }
    }
    
}
protocol Loggable {
    var title: String { get }
    var params: [String: String] { get }
}
