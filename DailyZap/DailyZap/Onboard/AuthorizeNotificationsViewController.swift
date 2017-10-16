//
//  AuthorizeNotificationsViewController.swift
//  DailyZap
//
//  Created by David LoBosco on 10/3/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class AuthorizeNotificationsViewController: UIViewController {
    @IBOutlet weak var infoSection: UIView!
    @IBOutlet weak var enableBtn: CTAButton!
    @IBOutlet weak var skipBtn: SubtleButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoSection.alpha = 0
        self.skipBtn.alpha = 0
        self.enableBtn.alpha = 0
        self.enableBtn.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fadeInSection()
    }
    
    func fadeInSection() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.infoSection.transform = CGAffineTransform(translationX: 0, y: -4)
            self.infoSection.alpha = 1
        }, completion: { (finished) in
            self.showEnableButton()
        })
    }
    func showEnableButton() {
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.enableBtn.alpha = 1
            self.enableBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { finished in
            self.showSkipButton()
        })
    }
    
    func showSkipButton() {
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseInOut, animations: {
            self.skipBtn.alpha = 1
        }, completion: nil)
    }
    
    @IBAction func tappedEnableNotifications(_ sender: Any) {
        // TODO actually access notifications
        self.popAndFlip()
    }
    @IBAction func tappedSkip(_ sender: Any) {
        self.popAndFlip()
    }
    
    func popAndFlip() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        self.navigationController!.view.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: false)
    }
}
