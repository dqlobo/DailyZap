//
//  AuthorizeContactsViewController.swift
//  DailyZap
//
//  Created by David LoBosco on 10/1/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class AuthorizeContactsViewController: BaseViewController, AppleContactsInjector, AlertInjector {
    @IBOutlet weak var verticalLogoPosition: NSLayoutConstraint!
    @IBOutlet weak var importBtn: Button!
    @IBOutlet weak var infoSection: UIView!
    lazy var presenter = AuthorizeContactsPresentationController(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layoutIfNeeded()
        self.importBtn.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.importBtn.alpha = 0
        self.infoSection.alpha = 0

        self.slideUpLogo()
    }
    
    func slideUpLogo() {
        self.verticalLogoPosition.constant = -200
        // animations separate to allow for logo translation
        UIView.animate(withDuration: 0.4, delay: 0.2, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.fadeInSection()
            self.showContactsButton()
        })
    }
    func fadeInSection() {
        UIView.animate(withDuration: 0.3, delay: 0.2, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.infoSection.alpha = 1
            self.infoSection.transform = CGAffineTransform(translationX: 0, y: -4)
        })
    }
    
    func showContactsButton() {
        UIView.animate(withDuration: 0.5, delay: 0.7, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.importBtn.alpha = 1
            self.importBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
    func hideButtonAndSection() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.infoSection.transform = CGAffineTransform(translationX: 0, y: 4)
            self.infoSection.alpha = 0
            self.importBtn.alpha = 0
        }) { (finished) in
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func tappedImportContacts(_ sender: Any) {
        self.appleContactManager.requestAccess { [weak self] (granted, error) in
            if granted && error == nil {
                DispatchQueue.main.async {
                    self?.analytics.log(.onboard(.contact(.accept)))
                    self?.appleContactManager.refreshContactList()
                    self?.hideButtonAndSection()
                }
            } else {
                self?.analytics.log(.onboard(.contact(.deny)))
                self?.presenter.openAppSettings()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
