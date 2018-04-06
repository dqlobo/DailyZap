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
        self.configure()
        
    }
    
    func configure() {
        if let t = LabelType(rawValue: self.type) {
            switch t {
            case .title:
                self.font = UIFont.zapTitleFont(sz: self.font.pointSize)
                self.text = self.text?.uppercased()
            case .normal:
                self.font = UIFont.zapNormalFont(sz: self.font.pointSize)
            case .detail:
                self.font = UIFont.zapDetailFont(sz: self.font.pointSize)
                self.textColor = UIColor.zapGray
            }
        }
    }

    @IBInspectable var type: Int {
        didSet {
            self.configure()
        }
    }
}
