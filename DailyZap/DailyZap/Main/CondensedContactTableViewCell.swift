//
//  CondensedContactTableViewCell.swift
//  DailyZap
//
//  Created by David LoBosco on 10/4/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class CondensedContactTableViewCell: UITableViewCell {

    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var name: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
    }

}
