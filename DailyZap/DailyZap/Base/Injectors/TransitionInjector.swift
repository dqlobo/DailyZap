//
//  TransitionInjector.swift
//  DailyZap
//
//  Created by David LoBosco on 10/4/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation
import UIKit

fileprivate struct TransitionInstance {
    static let transitionManager: TransitionManager = TransitionManager()
}

protocol TransitionInjector { }
extension TransitionInjector {
    var transitionManger: TransitionManager { return TransitionInstance.transitionManager }
}

class TransitionManager {
    
}


