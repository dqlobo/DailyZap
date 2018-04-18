//
//  Feed.swift
//  DailyZap
//
//  Created by David LoBosco on 10/15/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation

class Feed {
    // acts as a filter for Contacts (Due today vs after today)
    fileprivate var queue: [Contact]
    
    var overdue: [Contact] {
        let today = Date()
        return queue.filter { today.daysUntil(date: $0.due) < 0 }
    }
    
    var due: [Contact] {
        let today = Date()
        return queue.filter { today.daysUntil(date: $0.due) <= 0 } // includes overdue
    }
    
    var upcoming: [Contact] {
        let today = Date()
        return queue.filter { today.daysUntil(date: $0.due) > 0 }
    }
    
    init(queue: [Contact]) {
        self.queue = queue
    }
    
    func add(contact: Contact) {
        queue.append(contact)
    }
    
    func remove(contact: Contact) {
        if let index = queue.index(of: contact) {
            self.queue.remove(at: index)
        }
    }        
}
