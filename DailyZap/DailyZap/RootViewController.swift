//
//  ViewController.swift
//  DailyZap
//
//  Created by David LoBosco on 9/30/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class RootViewController: UINavigationController, AppleContactsInjector {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.queueTutorialIfNeeded()
    }
    
}

// Static methods
extension RootViewController {
    
    class func createRootViewController() -> RootViewController {
        let root = RootViewController(rootViewController: MainViewController())
        root.isNavigationBarHidden = true
        root.navigationBar.barTintColor = UIColor.clear
        root.view.backgroundColor = UIColor.clear
        root.navigationBar.isTranslucent = true
        root.navigationBar.setBackgroundImage(UIImage(), for: .default)
        root.navigationBar.shadowImage = UIImage()
        return root
    }
    
}

// Object methods
extension RootViewController {
    
    func queueTutorialIfNeeded() {
        if !self.appleContactManager.isAuthorized() {
            self.pushViewController(AuthorizeNotificationsViewController(), animated: false)
            self.pushViewController(AuthorizeContactsViewController(), animated: false)
            self.pushViewController(LandingViewController(), animated: false)
        }
    }
    
}

