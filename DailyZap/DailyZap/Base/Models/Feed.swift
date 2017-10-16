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
        return self.queue.filter { today.daysUntil(date: $0.due) < 0 }
    }
    
    var due: [Contact] {
        let today = Date()
        return self.queue.filter { today.daysUntil(date: $0.due) == 0 }
    }
    
    var upcoming: [Contact] {
        let today = Date()
        return self.queue.filter { today.daysUntil(date: $0.due) > 0 }
    }
    
    init(queue: [Contact]) {
        self.queue = queue
    }
    
    func add(contact: Contact) {
        self.queue.append(contact)
    }
    
    func remove(contact: Contact) {
        if let index = self.queue.index(of: contact) {
            self.queue.remove(at: index)
        }
    }        
}
