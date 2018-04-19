//
//  Constants.swift
//  DailyZap
//
//  Created by David LoBosco on 4/18/18.
//  Copyright © 2018 dqlobo. All rights reserved.
//

import UIKit

struct Constants {
    static let flurryKey = "89TXPFVHYG8F95YRHQQM"
    static let appVersion: String = Bundle.main.object(forInfoDictionaryKey: String(kCFBundleVersionKey)) as? String ?? "1"
}
