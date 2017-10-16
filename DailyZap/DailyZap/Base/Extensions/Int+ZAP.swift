//
//  Int+ZAP.swift
//  DailyZap
//
//  Created by David LoBosco on 10/14/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation

extension Int {
    static func random(upTo limit: Int) -> Int {
        return Int(arc4random_uniform(UInt32(limit)))
    }
}
