//
//  LightningBoltView.swift
//  DailyZap
//
//  Created by David LoBosco on 4/6/18.
//  Copyright © 2018 dqlobo. All rights reserved.
//

import UIKit

class LightningBoltView: UIView {

    let path = UIBezierPath()
    let shapeLayer = CAShapeLayer()
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBolt()
    }
    
    private func setupBolt() {
        
        imageView.containIn(view: self)
        imageView.bindHorizontally(to: self)
        imageView.clipsToBounds = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        let h = imageView.heightAnchor.constraint(equalToConstant: 0)
        h.priority = .defaultLow
        h.isActive = true
        layoutIfNeeded()
        
        
    }
    
//    func play() {
//        let pad: CGFloat = 50
//        let height = bounds.height
//        path.move(to: CGPoint(x: bounds.minX + pad, y: height * 0.05))
//        path.addLine(to: CGPoint(x: bounds.maxX - pad, y: height * 0.2))
//        path.addLine(to: CGPoint(x: bounds.minX + pad * 2, y: height * 0.5))
//        path.addLine(to: CGPoint(x: bounds.maxX - pad * 2, y: height * 0.8))
//
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.strokeColor = UIColor.zapBlue.cgColor
//        shapeLayer.lineWidth = bounds.width * 0.1
//        shapeLayer.path = path.cgPath
//
//        layer.addSublayer(shapeLayer)
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.fromValue = 0
//        animation.duration = 0.5
//        shapeLayer.add(animation, forKey: "BoltAnimation")
//    }
    
    func flash(duration: TimeInterval = 0.3, completion: (() -> Void)?) {
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.layoutIfNeeded()
        }, completion: { _ in
            if let cb = completion {
                cb()
            }
        })
        
        imageView.image = UIImage(named: "bolt")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .top
        let flashCount = 2
        let mult = duration / Double(flashCount)
        for i in 0..<flashCount {
            // inverse
//            let timing = Double(Int.random(upTo: 100))
            self.perform(#selector(makeInverseColors), with: self, afterDelay: mult * Double(i))

            // reverse
            self.perform(#selector(makeNormalColors), with: self, afterDelay: mult * (Double(i) + 0.5))
        }
    }
    
    @objc private func makeInverseColors() {
        backgroundColor = .zapBlue
        imageView.tintColor = UIColor.zapYellow

//        shapeLayer.fillColor = UIColor.zapYellow.cgColor
//        shapeLayer.strokeColor = UIColor.zapYellow.cgColor
    }
    
    @objc private func makeNormalColors() {
        backgroundColor = .zapYellow
//        shapeLayer.fillColor = UIColor.zapBlue.cgColor
//        shapeLayer.strokeColor = UIColor.zapBlue.cgColor
        imageView.tintColor = UIColor.zapBlue

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
}
