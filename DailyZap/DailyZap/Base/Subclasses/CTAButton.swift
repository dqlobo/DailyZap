//
//  UIButton+ZAP.swift
//  DailyZap
//
//  Created by David LoBosco on 9/30/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class CTAButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 15.0
        self.layer.backgroundColor = UIColor.zapYellow.cgColor
        self.tintColor = UIColor.zapBlue
        self.titleLabel?.font = UIFont.zapTitleFont(sz: 30)
        self.contentEdgeInsets = UIEdgeInsetsMake(20, 25, 20, 25)
    }

}
