//
//  BaseViewController.swift
//  DailyZap
//
//  Created by David LoBosco on 9/30/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, PresentationInjector {
//    var presenter: PresentationManager
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.presenter.viewController = self
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        self.presenter.viewController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
}

