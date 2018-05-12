//
//  MainViewController.swift
//  DailyZap
//
//  Created by David LoBosco on 10/4/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FeedViewController: BaseViewController, PointInjector {
    
    @IBOutlet weak var footerBottom: NSLayoutConstraint!
    @IBOutlet weak var footer: PointFooter!
    @IBOutlet weak var tableView: UITableView!
    var dataController: FeedDataController?
    lazy var feedPresenter: FeedPresentationController = FeedPresentationController(viewController: self)
    
    @IBOutlet weak var adContainer: GADBannerView!
    var adIsVisible: Bool = false {
        didSet {
            footerBottom.constant = adIsVisible ? 50 : 0
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.view.layoutIfNeeded()
                self?.tableView.reloadData()
            }) 
        }
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "FeedViewController", bundle: Bundle.main)
        NotificationCenter.default.addObserver(self, selector: #selector(updateAfterTimeChange), name: NSNotification.Name.UIApplicationSignificantTimeChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        setupTableView()
        adContainer.adUnitID = Constants.adMobIdentifier
        adContainer.rootViewController = self
        adContainer.delegate = self
        adContainer.load(GADRequest())
        view.backgroundColor = UIColor.zapNearWhite
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let frm = tableView.tableFooterView?.bounds ?? .zero
        tableView.tableFooterView?.bounds =  CGRect(origin: frm.origin, size: CGSize(width: frm.width, height: 100))
        tableView.tableFooterView?.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        feedPresenter.showTutorialPopupIfNeeded()
    }
    
    @objc func updateAfterTimeChange() {
        feedPresenter.reloadFeed()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not yet implemented")
    }
}

extension FeedViewController: GADBannerViewDelegate {        
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        adIsVisible = false
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        adIsVisible = true
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



