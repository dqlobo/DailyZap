//
//  PointInjector.swift
//  DailyZap
//
//  Created by David LoBosco on 4/8/18.
//  Copyright © 2018 dqlobo. All rights reserved.
//

import Foundation

fileprivate struct PointManagerInstance {
    static let pointManager = PointManager()
}

protocol PointInjector  { }
extension PointInjector {
    var pointManager: PointManager { return PointManagerInstance.pointManager }
}

class PointManager: NSObject, UserDefaultsInjector {

    lazy var points: Int64 = userDefaultsManager.points
    
    func addPoints(_ amt: Int) {
        points += Int64(amt)
        userDefaultsManager.points = points
    }
    
    
    
}

