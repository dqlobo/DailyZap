//
//  MainViewController.swift
//  DailyZap
//
//  Created by David LoBosco on 10/4/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, FeedInjector {
    @IBOutlet weak var tableView: UITableView!
    let dataController = FeedDataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationItems()
        self.setupTableView()
    }
    
    func setupTableView() {
        self.tableView.dataSource = self.dataController
        self.tableView.delegate = self.dataController
    }
    
    func setupNavigationItems() {
        self.navigationItem.title = "DailyZap"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "|||", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}


