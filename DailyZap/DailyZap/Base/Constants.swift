//
//  Constants.swift
//  DailyZap
//
//  Created by David LoBosco on 4/18/18.
//  Copyright © 2018 dqlobo. All rights reserved.
//

import UIKit

struct Constants {
    static let flurryKey = Bundle.main.object(forInfoDictionaryKey: "FlurryKey") as? String ?? "INVALID"
    static let adMobIdentifier = Bundle.main.object(forInfoDictionaryKey: "AdMobIdentifier") as? String ?? "INVALID"
    static let feedAdIdentifier = Bundle.main.object(forInfoDictionaryKey: "FeedAdIdentifier") as? String ?? "INVALID"
    
    static let appVersion: String = Bundle.main.object(forInfoDictionaryKey: String(kCFBundleVersionKey)) as? String ?? "1"
    
}
