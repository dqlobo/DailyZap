//
//  MainViewController.swift
//  DailyZap
//
//  Created by David LoBosco on 10/4/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit


class FeedViewController: BaseViewController {
    
    @IBOutlet weak var footer: PointFooter!
    @IBOutlet weak var tableView: UITableView!
    var dataController: FeedDataController?
    lazy var feedPresenter: FeedPresentationController = FeedPresentationController(viewController: self)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "FeedViewController", bundle: Bundle.main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        setupTableView()
        view.backgroundColor = UIColor.zapNearWhite
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension FeedViewController {
    func setupTableView() {
        let controller = FeedDataController(tableView: tableView)
        controller.presenter = feedPresenter
        tableView.dataSource = controller
        tableView.delegate = controller
        dataController = controller
    }
    
    func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "titleLogo"))
        let cog = UIBarButtonItem(image: UIImage(named: "cog"), style: .plain, target: self, action: #selector(tappedSettings))
        cog.tintColor = UIColor.gray
        navigationItem.rightBarButtonItem = cog
    }
    
    @objc func tappedSettings() {
        feedPresenter.tappedOpenSettings()
    }
}



