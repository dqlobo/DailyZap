//
//  SubtleButton.swift
//  DailyZap
//
//  Created by David LoBosco on 10/3/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class SubtleButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.font = UIFont.zapDetailFont(sz: 10)
        self.tintColor = UIColor.white        
    }
}
