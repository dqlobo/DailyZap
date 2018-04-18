//
//  CondensedContactTableViewCell.swift
//  DailyZap
//
//  Created by David LoBosco on 10/4/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit
import InitialsImageView
class ContactTableViewCell: UITableViewCell {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: Label!
    @IBOutlet weak var zapBtn: Button!
    @IBOutlet weak var dueLabel: Label!
    
    var userImage: UIImage? {
        didSet {
           configureImage()
        }
    }
    
    var name: String = "" {
        didSet {           
            nameLabel.text = name.lowercased()
//            if userImage == nil {
                configureImage()
//            }
        }
    }
    
    private func configureImage() {
        if userImage == nil {
            userImageView.setImageForName(string: name, backgroundColor: .zapNavy, circular: true, textAttributes: nil, gradient: false)
        } else {
            userImageView.image = userImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        nameLabel.textColor = .zapDarkGray
    }
    
}
