//
//  DataSourceInjector.swift
//  DailyZap
//
//  Created by David LoBosco on 10/15/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation


fileprivate struct DataSourceInstance {
    static let dataSourceManager: DataSourceManager = DataSourceManager()
}

protocol DataSourceInjector { }
extension DataSourceInjector {
    var dataSourceManager: DataSourceManager { return DataSourceInstance.dataSourceManager }
}

class DataSourceManager: UserDefaultsInjector, ContactInjector {
    func getDueFeed() {
        let upcoming = self.userDefaultsManager.
    }
}
