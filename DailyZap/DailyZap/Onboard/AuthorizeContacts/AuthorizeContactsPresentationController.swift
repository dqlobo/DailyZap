//
//  AuthorizeContactsPresentationController.swift
//  DailyZap
//
//  Created by David LoBosco on 4/13/18.
//  Copyright © 2018 dqlobo. All rights reserved.
//

import UIKit
import PopupDialog

class AuthorizeContactsPresentationController: BasePresentationController<AuthorizeContactsViewController> {
    func openAppSettings() {
        let popup = PopupDialog(title: "Contacts Disabled".lowercased(), message: "Enable contacts in your phone settings to begin supercharging your network")
        let stg = DefaultButton(title: "Go to Settings") {
            let url = URL(string: UIApplicationOpenSettingsURLString)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        popup.addButton(stg)
        showPopup(popup, showsCancel: true)
    }
}

