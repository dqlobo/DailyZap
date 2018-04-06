//
//  ZappedPlaceholderTableViewCell.swift
//  DailyZap
//
//  Created by David LoBosco on 12/10/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class ZappedPlaceholderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: Label!
    @IBOutlet weak var checkImageView: UIImageView!
    var borderLayer: CALayer?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.checkImageView.image =  self.checkImageView.image?.withRenderingMode(.alwaysTemplate)
        self.checkImageView.tintColor = UIColor.zapGray
        self.label.textColor = UIColor.zapGray
        
//        self.layer.borderColor = UIColor.zapGray.cgColor
//        self.layer.borderWidth = 1.0
//            
        let border = self.contentView.getDashedBorderLayer(color: UIColor.zapGray)
        self.contentView.layer.addSublayer(border)
        self.borderLayer = border
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.borderLayer?.frame = self.contentView.frame
    }
    
}
