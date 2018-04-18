//
//  ContactPickerViewController.swift
//  DailyZap
//
//  Created by David LoBosco on 12/21/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class ContactPickerViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var addContactCallback: ((Contact?) -> Void)?

    lazy var dataController: ContactPickerDataController = {
        let dataController = ContactPickerDataController(tableView: tableView)
        dataController.addContactCallback = addContactCallback
        dataController.presenter = presenter
        return dataController
    }()
    
    lazy var presenter = ContactPickerPresentationController(viewController: self)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        self.setupTableView()
        self.setupSearch()
    }
    
    func setupNavBar() {
        let rightBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        rightBtn.tintColor = UIColor.zapBlue
        rightBtn.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.zapNormalFont(sz: 15)], for: [.normal, .focused])

        navigationItem.rightBarButtonItem = rightBtn
        
        title = "Schedule a Zap"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font : UIFont.zapNormalFont(sz: 15)]
    }
    
    func setupTableView() {
        tableView.delegate = dataController
        tableView.dataSource = dataController
        dataController.refreshContactList()
    }
    
    func setupSearch() {
        searchBar.barTintColor = UIColor.zapNearWhite
        searchBar.delegate = self
    }

}

extension ContactPickerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataController.queryString = searchText
    }
}

extension ContactPickerViewController {
    @objc func done() {
        dismiss(animated: true, completion: nil)
    }
    
}
