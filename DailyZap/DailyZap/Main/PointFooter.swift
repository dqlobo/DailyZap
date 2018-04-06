//
//  PointFooter.swift
//  DailyZap
//
//  Created by David LoBosco on 12/3/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit


class PointFooter: UIView {
    @IBOutlet weak var pointLabel: Label!
    @IBOutlet weak var captionLabel: Label!
    
    var points: Int = 0 {
        didSet {
            self.pointLabel.text = "\(self.points) ZAP POINTS"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pointLabel.textColor = UIColor.zapBlue
        self.captionLabel.textColor = UIColor.zapBlue
    }
    
    
}
