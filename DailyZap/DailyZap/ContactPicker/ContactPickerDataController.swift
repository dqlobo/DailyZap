//
//  ContactPickerDataController.swift
//  DailyZap
//
//  Created by David LoBosco on 12/21/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation
import UIKit
class ContactPickerDataController: BaseDataController, AppleContactsInjector {
    fileprivate let cellReuseID = "AddContactReuseID"
    var addContactCallback: ((Contact?) -> Void)?
    lazy var contactList: [Contact] = appleContactManager.contactList
    lazy var filteredContacts: [Contact] = getSortedContacts()

    var queryString = "" {
        didSet {
            recalculateFilter()
        }
    }
    
    
    lazy var refresh: UIRefreshControl = {
        let r = UIRefreshControl()
        r.addTarget(self,
                    action: #selector(didScrollToRefresh(refreshControl:)),
                    for: .valueChanged)
        return r
    }()
    
    override func setup() {
        super.setup()
        
        // setup tableview
        tableView.addSubview(refresh)
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName:"SmallContactTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: self.cellReuseID)
        // TODO check if contact is already added or if max contacts are queued
        // register reload notification
        NotificationCenter.default.addObserver(self, selector: #selector(didRefreshContactList), name: AppleContactsManager.loadedContactsNotification, object: nil)
    }
    @objc func didScrollToRefresh(refreshControl: UIRefreshControl) {
        appleContactManager.refreshContactList()
    }
    
    @objc func refreshContactList() {
        refresh.beginRefreshing()
        appleContactManager.refreshContactList()
    }
    
    func getSortedContacts() -> [Contact] {
        return contactList
            .filter { queryString == ""
                || $0.fullName.localizedCaseInsensitiveContains(queryString) }
            .sorted { $0.fullName < $1.fullName }
    }
    
    func recalculateFilter() {
        DispatchQueue.global().async { [weak self] in
            guard let strong = self else { return }
            let sortedContacts = strong.getSortedContacts()
            DispatchQueue.main.sync {
                strong.filteredContacts = sortedContacts
                strong.tableView.reloadData()
            }
        }
    }
}

extension ContactPickerDataController {
    @objc func didRefreshContactList() {
        refresh.endRefreshing()
        contactList = feedManager.inflate(contacts: appleContactManager.contactList)
        recalculateFilter()
        tableView.reloadData()
    }
    
    @objc func add(sender: Button) {
        
        let point = tableView.convert(CGPoint.zero, from: sender)
        if let indexPath = tableView.indexPathForRow(at: point) {
            let contact = filteredContacts[indexPath.row]
            if let cb = addContactCallback {
                cb(contact) // todo use Contact
            }
        }
    }
}

extension ContactPickerDataController: UITableViewDataSource, UserDefaultsInjector, FeedInjector {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath) as! ContactTableViewCell
        let contact = filteredContacts[indexPath.row]
        cell.name = contact.fullName
        cell.dueLabel?.text = contact.primaryPhone
        if userDefaultsManager.hasContactWithID(contactID: contact.contactID) {
            // already queued
            cell.zapBtn.setTitle("ADDED", for: .normal)
            cell.zapBtn.type = ButtonType.disabled.rawValue
        } else {
            cell.zapBtn.setTitle("+ ADD", for: .normal)
            cell.zapBtn.type = ButtonType.darkFilled.rawValue
        }
        cell.zapBtn.addTarget(self, action: #selector(add), for: .touchUpInside)
        cell.userPicture.image = nil
        if let data = contact.imageData {
            cell.userPicture.image = UIImage(data: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Contact count \(filteredContacts.count)")
        return filteredContacts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension ContactPickerDataController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cb = self.
    }
}
