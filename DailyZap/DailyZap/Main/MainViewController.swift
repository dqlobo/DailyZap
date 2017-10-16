//
//  MainViewController.swift
//  DailyZap
//
//  Created by David LoBosco on 10/4/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, ContactInjector {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationItems()
        self.setupTableView()
    }
    
    func setupTableView() {
    }
    
    func setupNavigationItems() {
        self.navigationItem.title = "Test"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "|||", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.contactManager.getRandomContact()
    }
    
    

}
