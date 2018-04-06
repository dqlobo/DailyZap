//
//  CondensedContactTableViewCell.swift
//  DailyZap
//
//  Created by David LoBosco on 10/4/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet private weak var nameLabel: Label!
    @IBOutlet weak var zapBtn: Button!
    @IBOutlet weak var dueLabel: Label!
    
    var name: String = "" {
        didSet {
            nameLabel.text = name.uppercased()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
    }
    
}
