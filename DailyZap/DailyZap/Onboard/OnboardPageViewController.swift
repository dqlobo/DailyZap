//
//  OnboardPageViewController.swift
//  DailyZap
//
//  Created by David LoBosco on 10/1/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class OnboardPageViewController: UIPageViewController {
    
    
    init() {
        super.init(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        let viewControllers = [self.generateLanding()]
        self.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.forward,
                                animated: false, completion: nil)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func generateLanding() -> UIViewController {
        let landing = LandingViewController()
//        landing.getStartedBtn.addTarget(self, action: #selector(OnboardPageViewController.landingToContacts(sender:)), for: UIControlEvents.touchUpInside)
        return landing
    }
    
    @objc func landingToContacts(sender: UIButton!) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
}

