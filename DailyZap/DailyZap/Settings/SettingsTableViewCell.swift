//
//  SettingsTableViewCell.swift
//  DailyZap
//
//  Created by David LoBosco on 12/3/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: Label!
    @IBOutlet weak var detailLabel: Label!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
}
