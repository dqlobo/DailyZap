//
//  TwoLabelHeader.swift
//  DailyZap
//
//  Created by David LoBosco on 10/4/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit
import InitialsImageView

class TwoLabelHeader: UITableViewHeaderFooterView {

    @IBOutlet private weak var countCircle: UIImageView!
    @IBOutlet weak var titleLabel: Label!
    @IBOutlet weak var subtitleLabel: Label!
    var highlightsCounter = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.zapNearWhite
        titleLabel.textColor = .zapDarkGray
        count = 0
    }
    
    var count = 0 {
        didSet {
            let fg: UIColor = count > 0 ? .white : .zapGray
            let highlight: UIColor = highlightsCounter ? .zapRed : .zapGray
            let bg: UIColor = count > 0 ? highlight : .zapNearWhite
            
            countCircle.setImageForName(string: "\(count)", backgroundColor: bg, circular: true, textAttributes: [
                NSAttributedStringKey.font: UIFont.zapNormalFont(sz: 13),
                NSAttributedStringKey.foregroundColor: fg
                ], gradient: false)

        }
    }

}
