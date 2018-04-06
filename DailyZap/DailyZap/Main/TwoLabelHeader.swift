//
//  TwoLabelHeader.swift
//  DailyZap
//
//  Created by David LoBosco on 10/4/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class TwoLabelHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: Label!
    @IBOutlet weak var subtitleLabel: Label!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.zapNearWhite
    }
}
