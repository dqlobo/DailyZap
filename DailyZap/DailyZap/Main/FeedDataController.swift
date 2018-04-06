//
//  FeedDataManager.swift
//  DailyZap
//
//  Created by David LoBosco on 10/16/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation
import UIKit
import ContactsUI
import MessageUI

enum FeedSectionType: Int {
    case due
    case upcoming
    
    case sectionCount
}


class FeedDataController: NSObject, FeedInjector {
    let headerReuseID = "FeedHeaderReuseID"
    let smallCellReuseID = "FeedSmallCellReuseID"
    let bigCellReuseID = "FeedBigCellReuseID"
    let emptyCellReuseID = "FeedEmptyCellReuseID"
    let maxUpcoming = 2

    var presenter: FeedPresentationController?   

    fileprivate var footer: ButtonFooter?
    
    fileprivate var tableView: UITableView! {
        didSet {
          self.setupTableView()
        }
    }
    
    override init() {
        super.init()        
    }
    
    convenience init(tableView: UITableView) {
        self.init()
        self.tableView = tableView
        setupTableView() // didSet not called in init
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "TwoLabelHeader", bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: self.headerReuseID)
        tableView.register(UINib(nibName: "SmallContactTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: self.smallCellReuseID)
        tableView.register(UINib(nibName: "BigContactTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: self.bigCellReuseID)
        tableView.register(UINib(nibName: "ZappedPlaceholderTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: self.emptyCellReuseID)

        tableView.sectionHeaderHeight = 100
        footer = ButtonFooter.loadFromXib(withOwner: self)
        footer?.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 150)
        footer?.btn.addTarget(self, action: #selector(queueZap), for:.touchUpInside)
        tableView.tableFooterView = footer
    }
    
    func executeOnSection(_ section: Int, _ block: (FeedSectionType) -> Void) {
        if let type = FeedSectionType(rawValue: section) {
            block(type)
        } else {
            block(.sectionCount)
        }
    }
    
    func contactForIndexPath(_ indexPath: IndexPath) -> Contact? {
        var contact: Contact?
        self.executeOnSection(indexPath.section) { (type) in
            switch type {
            case .due:
                contact = feedManager.feed.due[indexPath.row]
            case .upcoming:
                contact = feedManager.feed.upcoming[indexPath.row]
            default:
                return
            }
        }
        return contact
    }
}

extension FeedDataController {
    @objc func queueZap() {
        if let p = self.presenter {
            p.tappedAddContact { contact, success in
                if success {
                    self.feedManager.addToFeed(contact: contact)
                    self.tableView.reloadData()
                    // give points?
                } else {
                    // signal failure
                }
            }
        }
    }
    
    @objc func zapContact(sender: Button)  {
        let point = tableView.convert(CGPoint(x: 0,y: 0), from: sender)
        guard let indexPath = tableView.indexPathForRow(at: point) else {
            return
        }
        if let contact = self.contactForIndexPath(indexPath), let p = self.presenter {
            p.tappedZapForContact(contact: contact) { contact, success in
                if (success) {
                    self.feedManager.removeFromFeed(contact: contact)
                    self.tableView.reloadData()
                    // give points!
                } else {
                    // signal failure
                }
            }
        }
    }
}

extension FeedDataController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.section </*==*/ 0 ? self.bigCellReuseID : self.smallCellReuseID
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ContactTableViewCell
        if let contact = contactForIndexPath(indexPath) {
            cell.zapBtn.addTarget(self, action: #selector(zapContact(sender:)), for: .touchUpInside)
            if let data = contact.imageData {
                cell.userPicture.image = UIImage(data: data)
            } else {
                cell.userPicture.image = nil
            }
            cell.name = contact.fullName
            let dayCount = contact.due.daysFromNow()
            let plural = dayCount == 1 ? "" : "s"
            cell.dueLabel?.text = String(format: "Due in %d day%@", dayCount, plural)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        self.executeOnSection(section) { (type) in
            switch type {
            case .due:
                count = self.feedManager.feed.due.count
            case .upcoming:
                count = self.feedManager.feed.upcoming.count
                footer?.btn.isEnabled = count < maxUpcoming
            default:
                break
            }
         
        }
        return count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return FeedSectionType.sectionCount.rawValue
    }
}

extension FeedDataController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section </*==*/ 0 ? 250 : 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseID) {
            if let header = view as? TwoLabelHeader {
                self.executeOnSection(section, { (type) in
                    switch type {
                    case .due:
                        var subtitle: String
                        if let contact = self.feedManager.feed.due.first {
                             subtitle = String(format: "Reach out to %@ to continue your Zap Streak!", contact.firstName)
                        } else {
                            let formatter = DateFormatter()
                            formatter.timeStyle = .none
                            formatter.dateStyle = .medium
                            subtitle = String(format: "✓ Completed everything for %@", formatter.string(from: Date()))
                        }
                        header.titleLabel!.text = "Today"
                        header.subtitleLabel!.text = subtitle                        
                    default:
                        header.titleLabel!.text = "This Week"
                        header.subtitleLabel!.text = String(format: "Queue up to %d people to catch up with this week", self.maxUpcoming)
                    }
                })

                return header
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let p = self.presenter, let contact = self.contactForIndexPath(indexPath) {
            p.tappedContactInfo(contact: contact)
        }
    }
}

