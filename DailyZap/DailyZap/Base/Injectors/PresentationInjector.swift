//
//  ContactsPresenter.swift
//  DailyZap
//
//  Created by David LoBosco on 12/8/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation


fileprivate struct PresentationManagerInstance {
    static let presenter: PresentationManager = PresentationManager()
}

protocol PresentationInjector  { }
extension PresentationInjector {
    var presenter: PresentationManager { return PresentationManagerInstance.presenter }
}

class PresentationManager: NSObject {
//    var viewController: UIViewController?
}

