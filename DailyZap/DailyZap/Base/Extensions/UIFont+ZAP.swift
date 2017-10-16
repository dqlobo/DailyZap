//
//  UIFont+ZAP.swift
//  DailyZap
//
//  Created by David LoBosco on 9/30/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

// Mark - Fonts
extension UIFont {
    
    class func zapTitleFont(sz: CGFloat) -> UIFont! {
        return UIFont(name: zapTitleFontName, size: sz)!
    }
    
    class func zapNormalFont(sz: CGFloat) -> UIFont! {
        return UIFont(name: zapNormalFontName, size: sz)!
    }
    
    class func zapDetailFont(sz: CGFloat) -> UIFont! {
        return UIFont(name: zapDetailFontName, size:sz)!
    }
}

// Mark - Font Names
private extension UIFont {
    
    class var zapTitleFontName: String {
        return "Norwester-Regular"
    }
    
    class var zapNormalFontName: String {
        return "Muli-Regular"
    }
    
    class var zapDetailFontName: String {
        return "Muli-LightItalic"
    }
}

