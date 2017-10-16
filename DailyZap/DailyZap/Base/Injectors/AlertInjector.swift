//
//  AlertInjector.swift
//  DailyZap
//
//  Created by David LoBosco on 10/3/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation
import UIKit

fileprivate struct AlertInstance {
    static let alertManager: AlertManager = AlertManager()
}

protocol AlertInjector { }
extension AlertInjector {
    var alertManager: AlertManager { return AlertInstance.alertManager }
}

class AlertManager {
    func presentDismissableOkay(from viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .`default`, handler: nil))

        viewController.present(alert, animated: true)
    }
    func presentCancellableAction(from viewController: UIViewController, title: String, message: String, customAction: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .destructive, handler: nil))
        alert.addAction(customAction)        
        viewController.present(alert, animated: true)
    }
}
