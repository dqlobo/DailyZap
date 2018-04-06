//
//  LandingViewController.swift
//  DailyZap
//
//  Created by David LoBosco on 9/30/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class LandingViewController: BaseViewController {
    
    @IBOutlet weak var verticalLogoPosition: NSLayoutConstraint!
    @IBOutlet weak var getStartedBtn: Button!
    @IBOutlet weak var footer: UIView!
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getStartedBtn.alpha = 0
        self.footer.alpha = 0
        self.getStartedBtn.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.slideUpLogo()
        self.showTermsLinks()
    }
        
    func slideUpLogo() {
        self.verticalLogoPosition.constant = -75;
        UIView.animate(withDuration: 0.5, delay: 0.2, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            self.showContinueButton()
        })
    }
    
    func showContinueButton() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.getStartedBtn.alpha = 1
            self.getStartedBtn.transform = CGAffineTransform(scaleX: 1, y: 1)

        }, completion: nil)
    }
    
    func showTermsLinks() {
        // TODO fade in terms
        UIView .animate(withDuration: 1, animations: {
            self.footer.alpha = 1
        }, completion: nil)
    }
    @IBAction func tappedGetStarted(_ sender: Any) {
        UIView.transition(with: self.logo, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            self.logo.image = UIImage(named: "splashnowords")
            self.getStartedBtn.alpha = 0
            self.footer.alpha = 0
        }, completion: { finished in
                self.navigationController?.popViewController(animated: false)
        })
    }
    @IBAction func tappedTerms(_ sender: Any) {
        // TODO open Terms URL
    }
    @IBAction func tappedPrivacy(_ sender: Any) {
        // TODO open Privacy URL
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
