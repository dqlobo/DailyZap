//
//  TextFieldViewController.swift
//  DailyZap
//
//  Created by David LoBosco on 4/19/18.
//  Copyright © 2018 dqlobo. All rights reserved.
//

import UIKit

class TextFieldViewController: UIViewController {

    var text: String { return textField.text ?? "" }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: Label!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.textColor = .zapNavy
        textField.tintColor = .zapNavy
    }


}
