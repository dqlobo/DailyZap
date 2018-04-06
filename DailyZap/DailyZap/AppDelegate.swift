//
//  AppDelegate.swift
//  DailyZap
//
//  Created by David LoBosco on 9/30/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        window!.rootViewController = RootViewController.createRootViewController()

        setAppearances()
        
        return true
    }
    
    private func setAppearances() {
        UIRefreshControl.appearance().tintColor = UIColor.zapGray

    }
    
    func printFonts() {
        for family in UIFont.familyNames.sorted(by: {$0 < $1}) {
            print(family)
            for font in UIFont.fontNames(forFamilyName: family) {
                print("\t"+font)
            }
        }
    }
    

}

