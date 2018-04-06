//
//  XibLoadedView.swift
//  DailyZap
//
//  Created by David LoBosco on 10/4/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

class XibLoadedView: UIView {

//    class func loadFromXib(withOwner owner: Any?) -> Any? {
//        return self.loadFromXib(withOwner:owner)
//    }
}

extension UIView {
    func getDashedBorderLayer(color: UIColor, borderWidth: CGFloat = 1, cornerRadius: CGFloat = 5) -> CALayer {
        let borderLayer = CAShapeLayer()
        borderLayer.frame = self.frame
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.lineJoin = kCALineJoinRound
        borderLayer.lineDashPattern = [8, 4]
        
        let path = UIBezierPath.init(roundedRect: borderLayer.bounds, cornerRadius: cornerRadius)
        
        borderLayer.path = path.cgPath
        return borderLayer
    }
}

extension UIView {
    class func loadFromXib<T>(withOwner owner: Any?) -> T? {
        if let nib = Bundle.main.loadNibNamed(self.className(), owner: owner, options: nil)?.first as? T{
            return nib
        }
        return nil
    }
}
