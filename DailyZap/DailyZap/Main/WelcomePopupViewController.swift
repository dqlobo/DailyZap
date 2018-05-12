//
//  WelcomePopupViewController.swift
//  DailyZap
//
//  Created by David LoBosco on 5/9/18.
//  Copyright © 2018 dqlobo. All rights reserved.
//

import UIKit

class WelcomePopupViewController: UIViewController {

    
    var contact: Contact?
    var tappedOkay: (() -> Void)?
    @IBOutlet private weak var whenLabel: Label!
    @IBOutlet private weak var actionLabel: Label!
    @IBOutlet private weak var welcomeLabel: Label!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }

    private func setupLabels() {
        welcomeLabel.textColor = .zapNavy
        if let c = contact,
            c.hasName {
            whenLabel.text = "When was the last time you talked to\n\(c.fullName)?"
            actionLabel.text = "Tap \(c.firstName)'s card now for contact options or to remove this recommendation."
        } else {
            whenLabel.text = "Never lose touch with anyone, ever again!"
            actionLabel.text = "Queue friends, collegues and family members by tapping the \"+ Add\" button"
        }
    }        
    @IBAction func tappedOkayBtn(_ sender: Any) {
        tappedOkay?()
    }
}
