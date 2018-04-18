//
//  SACountingLabel.swift
//  Pods
//
//  Created by Sudeep Agarwal on 12/13/15.
//
//

import Foundation
import UIKit

class BigCountingLabel: Label {
    
    let kCounterRate: Float = 3.0
    
    enum AnimationType {
        case Linear
        case EaseIn
        case EaseOut
        case EaseInOut
    }      
    
    var start: Int64 = 0
    var end: Int64 = 0
    var timer: Timer?
    var progress: TimeInterval!
    var lastUpdate: TimeInterval!
    var duration: TimeInterval!
    var animationType: AnimationType!
    var callback: (() -> Void)?
    public var format: String?
    
    var currentValue: Int64 {
        if (progress >= duration) {
            return end
        }
        let percent = Float(progress / duration)
        let update = updateCounter(t: percent)
        return start + Int64(update * Float(end - start));
    }
    
    public func countFrom(fromValue: Int64, to toValue: Int64, withDuration duration: TimeInterval, andAnimationType aType: AnimationType) {
        
        // Set values
        self.start = fromValue
        self.end = toValue
        self.duration = duration
        self.animationType = aType
        self.progress = 0.0
        self.lastUpdate = Date.timeIntervalSinceReferenceDate
        
        // Invalidate and nullify timer
        killTimer()
        
        // Handle no animation
        if (duration == 0.0) {
            updateText(value: toValue)
            return
        }
        
        // Create timer
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateValue), userInfo: nil, repeats: true)
    }
    
    func updateText(value: Int64) {
        if let fn = formatFunction {
            self.text = fn(value)
        } else {
            self.text = "\(Int64(value))"
        }
    }
    
    public var formatFunction: ((Int64) -> String)?
    
    @objc func updateValue() {
        
        // Update the progress
        let now = Date.timeIntervalSinceReferenceDate
        progress = progress + (now - lastUpdate)
        lastUpdate = now
        
        // End when timer is up
        if (progress >= duration) {
            killTimer()
            progress = duration
            callback?()
        }
        
        updateText(value: currentValue)
        
    }
    
    func killTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateCounter(t: Float) -> Float {
        switch animationType! {
        case .Linear:
            return t
        case .EaseIn:
            return powf(t, kCounterRate)
        case .EaseOut:
            return 1.0 - powf((1.0 - t), kCounterRate)
        case .EaseInOut:
            var t = t
            var sign = 1.0;
            let r = Int(kCounterRate)
            if (r % 2 == 0) {
                sign = -1.0
            }
            t *= 2;
            if (t < 1) {
                return 0.5 * powf(t, kCounterRate)
            } else {
                return Float(sign * 0.5) * (powf(t-2, kCounterRate) + Float(sign * 2))
            }
            
        }
    }
    
    
}

