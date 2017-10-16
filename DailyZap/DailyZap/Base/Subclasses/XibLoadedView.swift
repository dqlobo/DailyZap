//
//  XibLoadedView.swift
//  DailyZap
//
//  Created by David LoBosco on 10/4/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class XibLoadedView: UIView {

    class func loadFromXib(withOwner owner: Any?) -> Any? {
        let nibName = String(describing: type(of: self))
        return Bundle.main.loadNibNamed(nibName, owner: owner, options: nil)?.first
    }
}
