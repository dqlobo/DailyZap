//
//  Result.swift
//  DailyZap
//
//  Created by David LoBosco on 4/10/18.
//  Copyright © 2018 dqlobo. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

class ResultError: Error {
    
}
