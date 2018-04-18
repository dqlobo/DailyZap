//
//  BasePresentationController.swift
//  DailyZap
//
//  Created by David LoBosco on 4/13/18.
//  Copyright © 2018 dqlobo. All rights reserved.
//

import Foundation
import PopupDialog

class BasePresentationController<T>: NSObject where T: UIViewController {
    let vc: T
    init(viewController: T) {
        vc = viewController
        super.init()
    }
    func showPopup(_ popup: PopupDialog, showsCancel: Bool = true) {
        popup.view.layer.speed = 2
        if showsCancel {
            popup.addButton(CancelButton(title: "Cancel") {})
        }
        vc.present(popup, animated: true)
        
    }
}
