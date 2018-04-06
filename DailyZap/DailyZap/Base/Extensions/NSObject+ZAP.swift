//
//  NSObject+ZAP.swift
//  DailyZap
//
//  Created by David LoBosco on 12/8/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation

extension NSObject {
    
    class func className() -> String {
        let name = NSStringFromClass(self)
        let splitName = name.split(separator: ".")
        let output: Substring = splitName[1]
        return String(output)
    }
}
