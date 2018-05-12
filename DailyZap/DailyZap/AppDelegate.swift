//
//  AppDelegate.swift
//  DailyZap
//
//  Created by David LoBosco on 9/30/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit
import PopupDialog
import AdSupport
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AnalyticsInjector, NotificationInjector {

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        window!.rootViewController = RootViewController.createRootViewController()
//        print("UUID is \(ASIdentifierManager.shared().advertisingIdentifier.uuidString)")

        // addl configuration
        analytics.beginSession()
        notificationManager.configureDelegate()
        setAppearances()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-1197795770484872~9866132060") //todo replace test ad

        return true
    }
    
    private func setAppearances() {
        UIRefreshControl.appearance().tintColor = UIColor.zapGray
        setPopupAppearances()
    }

    private func setPopupAppearances() {
        let normalFont: UIFont! = UIFont.zapNormalFont(sz: 15)
        let disabled = UIColor.zapGray
        
        let popupAppearance = PopupDialogDefaultView.appearance()
        popupAppearance.titleFont = UIFont.zapTitleFont(sz: 20)
        popupAppearance.titleColor = UIColor.zapNavy
        popupAppearance.messageFont = normalFont
        
        
        let defAppearance = DefaultButton.appearance()
        defAppearance.titleColor = UIColor.darkText
        defAppearance.titleFont = normalFont
        
        let negAppearance = DestructiveButton.appearance()
        negAppearance.titleColor = disabled
        negAppearance.titleFont = normalFont
        
        let canAppearance = CancelButton.appearance()
        canAppearance.titleColor = disabled
        canAppearance.titleFont = UIFont.zapNormalFont(sz: 12)
    }
    
    func printFonts() {
        for family in UIFont.familyNames.sorted(by: {$0 < $1}) {
            print(family)
            for font in UIFont.fontNames(forFamilyName: family) {
                print("\t"+font)
            }
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        notificationManager.checkSystemSettingsChange() // check notification permissions
    }
    
    

}

