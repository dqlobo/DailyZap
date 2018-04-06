//
//  BaseDataController.swift
//  DailyZap
//
//  Created by David LoBosco on 12/21/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation
import UIKit

class BaseDataController: NSObject {
    var tableView: UITableView! {
        didSet {
            self.setup()
        }
    }
    override init() {
        super.init()
    }
    convenience init(tableView: UITableView) {
        self.init()
        self.tableView = tableView
        self.setup() // didSet not called in init
    }
    func setup() {
        
    }
}
