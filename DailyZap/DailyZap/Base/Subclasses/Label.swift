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
        self.type = 1
        super.init(coder: aDecoder)
        configure()        
    }
    
    func configure() {
        if let t = LabelType(rawValue: self.type) {
            styleForType(t)
        }
    }

    @IBInspectable var type: Int {
        didSet {
            self.configure()
        }
    }
}

extension UILabel {
    func styleForType(_ t: LabelType) {
        switch t {
        case .title:
            font = UIFont.zapTitleFont(sz: self.font.pointSize)
//            textColor = .zapDarkGray
            text = text?.lowercased()
        case .normal:
            self.font = UIFont.zapNormalFont(sz: self.font.pointSize)
//            textColor = .zapDarkGray
        case .detail:
            font = UIFont.zapDetailFont(sz: self.font.pointSize)
            textColor = UIColor.zapGray
        }
    }
}
