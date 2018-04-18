//
//  ContactPickerPresentationController.swift
//  DailyZap
//
//  Created by David LoBosco on 4/17/18.
//  Copyright © 2018 dqlobo. All rights reserved.
//

import UIKit
import PopupDialog

class ContactPickerPresentationController: BasePresentationController<ContactPickerViewController>, UserDefaultsInjector {
    func showDetailsFor(contact: Contact, at indexPath: IndexPath) {
        let popup = PopupDialog(title: contact.fullName.lowercased(),
                                message: "Manage the settings for this contact")
        if userDefaultsManager.isOnBlackList(contactID: contact.contactID) {
            let rm = DefaultButton(title: "🚫  Remove from blacklist") { [weak self] in
                self?.userDefaultsManager.removeFromBlacklist(contactID: contact.contactID)
                self?.vc.tableView.reloadRows(at: [indexPath], with: .right)
            }
            popup.addButton(rm)
        } else {
            let add = DefaultButton(title: "🏴  Blacklist this contact") { [weak self] in
                self?.userDefaultsManager.addToBlacklist(contactID: contact.contactID)
                self?.vc.tableView.reloadRows(at: [indexPath], with: .left)
            }
            popup.addButton(add)
        }
        showPopup(popup)
    }
}
