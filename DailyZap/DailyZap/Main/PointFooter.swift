//
//  PointFooter.swift
//  DailyZap
//
//  Created by David LoBosco on 12/3/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit
import SACountingLabel

class PointFooter: UIView, PointInjector {
    @IBOutlet private weak var captionLabel: Label!
    
    @IBOutlet weak var pointCountLabel: BigCountingLabel!
    private lazy var points: Int64 = pointManager.points
    
    func addPoints(_ val: Int, animated: Bool, duration: TimeInterval = 0.3) {
        let cap = "Completed Zap: \(val < 0 ? "-" : "+")\(Int64(val))"
        pointManager.addPoints(val)
        setCaption(cap, animated: false) {
            self.pointCountLabel.countFrom(fromValue: self.points,
                             to: self.points + Int64(val),
                             withDuration: duration,
                             andAnimationType: .EaseInOut)
           self.points += Int64(val)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pointCountLabel.textColor = UIColor.zapBlue
        pointCountLabel.formatFunction = { "\(Int64($0)) ZAP POINTS" }

        pointCountLabel.countFrom(fromValue: 0, to: points, withDuration: 0, andAnimationType: .EaseIn)
        captionLabel.textColor = UIColor.zapBlue
        pointCountLabel.styleForType(.title)
        pointCountLabel.callback = { [weak self] in
            self?.perform(#selector(self?.resetCaption), with: self, afterDelay: 1)
        }
    }
    
    func setCaption(_ cap: String, animated: Bool = false, completion: (() -> Void)? = nil) {
        UIView.transition(with: captionLabel, duration: animated ? 0.5 : 0, options: .transitionCrossDissolve, animations: {
            self.captionLabel.text = cap
        }) { _ in
            completion?()
        }
    }
    
    @objc func resetCaption() {
        setCaption("Zap someone now to improve your score!", animated: true)
    }
    
}
