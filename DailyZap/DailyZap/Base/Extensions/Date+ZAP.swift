//
//  Date+ZAP.swift
//  DailyZap
//
//  Created by David LoBosco on 10/15/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation

extension Date {
    fileprivate static var secondsInAWeek: TimeInterval { return TimeInterval(60 * 60 * 24 * 7) }
    static func oneWeekFromNow() -> Date {
        return Date(timeIntervalSinceNow: Date.secondsInAWeek)
    }
    
    func daysUntil(date: Date) -> Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: self)
        let end = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: start, to: end)
        return components.day!
    }
    
    func daysFromNow() -> Int {
        return -self.daysUntil(date: Date())
    }
}
