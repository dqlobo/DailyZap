//
//  DueEmptyTableViewCell.swift
//  DailyZap
//
//  Created by David LoBosco on 4/13/18.
//  Copyright © 2018 dqlobo. All rights reserved.
//

import UIKit

class DueEmptyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }

    @IBOutlet weak var btn: Button!
}
