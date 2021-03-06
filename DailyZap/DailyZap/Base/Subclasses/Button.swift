//
//  Button.swift
//  DailyZap
//
//  Created by David LoBosco on 12/3/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

enum ButtonType: Int {
    case darkFilled
    case lightFilled
    case plain
    case subtle
    case darkEmpty
    case lightEmpty
    case disabled
    case deselected
}

class Button: UIButton {
    
    @IBInspectable var type: Int {
        didSet {
            self.styleForType(typ: type)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.type = ButtonType.lightFilled.rawValue
        super.init(coder: aDecoder)
    }
    
    func styleForType(typ: Int) {
        if let t = ButtonType(rawValue: typ) {
            switch t {
            case .darkFilled:
                self.makeFilled(foregroundColor: UIColor.white, backgroundColor: UIColor.zapBlue)
            case .lightFilled:
                makeFilled(foregroundColor: UIColor.zapBlue, backgroundColor: UIColor.zapYellow)
            case .plain:
                self.titleLabel?.font = UIFont.zapTitleFont(sz: titleLabel!.font.pointSize)
                self.tintColor = UIColor.zapBlue
            case .subtle:
                self.titleLabel?.font = UIFont.zapDetailFont(sz: titleLabel!.font.pointSize)
                self.tintColor = UIColor.zapYellow
            case .darkEmpty:
                self.makeFilled(foregroundColor: UIColor.zapBlue, backgroundColor: UIColor.clear)
                self.makeBorder(color: UIColor.zapBlue)
            case .lightEmpty:
                self.makeFilled(foregroundColor: UIColor.zapYellow, backgroundColor: UIColor.clear)
                self.makeBorder(color: UIColor.zapYellow)
            case .disabled:
                setTitleColor(UIColor.zapGray, for: .disabled)
                self.makeFilled(foregroundColor: UIColor.zapGray, backgroundColor: UIColor.clear)
                self.makeBorder(color: UIColor.zapGray)
            case .deselected:
                makeFilled(foregroundColor: .white, backgroundColor: .zapBlue)
                makeBorder(color: .clear)
            }
            
        }
    }
    
    func makeFilled(foregroundColor: UIColor, backgroundColor: UIColor) {
        let sz = self.titleLabel!.font.pointSize // 30
        let leftInset = sz / 1.2
        let topInset = sz / 1.5
        let cornerRadius = sz / 2
        
        layer.cornerRadius = cornerRadius
        layer.backgroundColor = backgroundColor.cgColor
        tintColor = foregroundColor
        setTitleColor(foregroundColor, for: .normal)
        
        titleLabel?.font = UIFont.zapTitleFont(sz: sz)
        contentEdgeInsets = UIEdgeInsetsMake(topInset, leftInset, topInset, leftInset)
//        setTitle(titleLabel?.text?.lowercased(), for: .normal)

    }
    
    func makeBorder(color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = 2 / UIScreen.main.scale
    }
    
    override var isEnabled: Bool {
        didSet {
            if !isEnabled {
                styleForType(typ: ButtonType.disabled.rawValue)
            } else {
                styleForType(typ: type)
            }
        }
    }
   
}
