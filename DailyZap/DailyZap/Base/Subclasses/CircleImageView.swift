//
//  CircleImageView.swift
//  DailyZap
//
//  Created by David LoBosco on 12/3/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2.0
    }
    
    
    
}
