//
//  SettingsPresentationController.swift
//  DailyZap
//
//  Created by David LoBosco on 4/13/18.
//  Copyright © 2018 dqlobo. All rights reserved.
//

import Foundation
import PopupDialog
class SettingsPresentationController: BasePresentationController<SettingsViewController>, UserDefaultsInjector {
    func openAppSettings() {
        let popup = PopupDialog(title: "Notifications Disabled".lowercased(), message: "Enable notifications in your phone settings to start getting Zap reminders")
        let stg = DefaultButton(title: "Go to Settings") {
            let url = URL(string: UIApplicationOpenSettingsURLString)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        popup.addButton(stg)
        showPopup(popup, showsCancel: true)
    }
    
    func showIdeaPopup() {
        let textVC = TextFieldViewController()
        let popup = PopupDialog(viewController: textVC, buttonAlignment: .horizontal)
        let cancel = CancelButton(title: "Cancel") {}
        let submit = DefaultButton(title: "Submit") { [weak self] in
            self?.analytics.log(.featureRequest(description: textVC.text))
        }
        popup.addButtons([cancel, submit])
        showPopup(popup, showsCancel: false)
    }
   
}
