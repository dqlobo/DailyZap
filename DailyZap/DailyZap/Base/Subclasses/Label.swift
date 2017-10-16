//
//  UILabel+ZAP.swift
//  DailyZap
//
//  Created by David LoBosco on 9/30/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

enum LabelType: Int {    
    case title
    case normal
    case detail
}

class Label: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        self.type = LabelType.normal.rawValue
        super.init(coder: aDecoder)
    }

    @IBInspectable var type: Int {
        didSet {
            if let t = LabelType(rawValue: type) {
                switch t {
                case .title:
                    self.font = UIFont.zapTitleFont(sz: self.font.pointSize)
                case .normal:
                    self.font = UIFont.zapNormalFont(sz: self.font.pointSize)
                case .detail:
                    self.font = UIFont.zapDetailFont(sz: self.font.pointSize)
                }
            }
        }
    }
}
