//
//  PointFooter.swift
//  DailyZap
//
//  Created by David LoBosco on 12/3/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class PointFooter: UIView, PointInjector {
    @IBOutlet private weak var captionLabel: Label!
    
    @IBOutlet weak var pointCountLabel: BigCountingLabel!
    private lazy var points: Int64 = pointManager.points
    
    func addPoints(_ val: Int, animated: Bool, duration: TimeInterval = 0.3) {
        let cap = val > 0 ? "Completed Zap: + \(val)" : "Removed Zap: - \(-val)"
        let color: UIColor = val >= 0 ? .zapBlue : .zapRed
        pointCountLabel.textColor = color
        captionLabel.textColor = color
        pointManager.addPoints(val)
        setCaption(cap, animated: false) { [weak self] in
            guard let strong = self else { return }
            strong .pointCountLabel.countFrom(fromValue: strong.points,
                             to: strong.points + Int64(val),
                             withDuration: duration,
                             andAnimationType: .EaseInOut)
            strong.points += Int64(val)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        pointCountLabel.formatFunction = { "\(Int64($0)) ZAP POINTS" }

        pointCountLabel.countFrom(fromValue: 0, to: points, withDuration: 0, andAnimationType: .EaseIn)
        pointCountLabel.styleForType(.title)
        resetCaption()
        
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
        let color: UIColor = points >= 0 ? .zapBlue : .zapRed
        pointCountLabel.textColor = color
        captionLabel.textColor = color
    }
    
}
