//
//  FeedDataManager.swift
//  DailyZap
//
//  Created by David LoBosco on 10/16/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation
import UIKit

enum FeedSectionType: Int {
    case due
    case upcoming
    
    case sectionCount
}

class FeedDataController: NSObject, FeedInjector {
    func executeOnSection(_ section: Int, _ block: (FeedSectionType) -> Void) {
        if let type = FeedSectionType(rawValue: section) {
            block(type)
        } else {
            block(.sectionCount)
        }
    }
}

extension FeedDataController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuseID")
        self.executeOnSection(indexPath.section) { (type) in
            switch type {
            case .due:
                cell.textLabel!.text = self.feedManager.feed.due[indexPath.row].fullName
            case .upcoming:
                cell.textLabel!.text = self.feedManager.feed.upcoming[indexPath.row].fullName
            default:
                break
            }
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
    
}
