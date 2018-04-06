//
//  UIView+ZAP.swift
//  DailyZap
//
//  Created by David LoBosco on 4/6/18.
//  Copyright © 2018 dqlobo. All rights reserved.
//

import UIKit

extension UIView {
    func containIn(view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func bindToEdges(of view: UIView, inset: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: view.leftAnchor, constant: inset.left),
            rightAnchor.constraint(equalTo: view.rightAnchor, constant: inset.right),
            topAnchor.constraint(equalTo: view.topAnchor, constant: inset.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: inset.bottom),
        ])
    }
    
    func bindHorizontally(to view: UIView, inset: CGFloat = 0) {
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: view.leftAnchor, constant: inset),
            rightAnchor.constraint(equalTo: view.rightAnchor, constant: inset)
        ])
    }
    
    func bindVertically(to view: UIView, inset: CGFloat = 0) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: inset)
        ])
    }
}
