//
//  BottomReverseRoundedView.swift
//  gift_app
//
//  Created by Lexy on 8/11/19.
//  Copyright © 2019 Lexy. All rights reserved.
//

import UIKit

class BottomReverseRoundedView: MyBaseView {
    override func setupViews() {
        radius = 0
        addSubview(subView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: subView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: subView)
    }
    override func draw(_ rect: CGRect) {
        complexShape()
    }

    private var path: UIBezierPath!
    
    let subView: UIView = {
        let sv = UIView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.clipsToBounds = true
        return sv
    }()
    
    public var radius: CGFloat!
    
    func complexShape() {
        let W = subView.frame.width
        let H = subView.frame.height
        
        path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: W, y: 0))
        path.addLine(to: CGPoint(x: W, y: H))
        path.addArc(withCenter: CGPoint(x: W - radius, y: H), radius: radius, startAngle: CGFloat(360).toRadians(), endAngle: CGFloat(270).toRadians(), clockwise: false)
        path.addLine(to: CGPoint(x: radius, y: H - radius))
        path.addArc(withCenter: CGPoint(x: radius, y: H), radius: radius, startAngle: CGFloat(270).toRadians(), endAngle: CGFloat(180).toRadians(), clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        subView.layer.mask = shapeLayer
    }
    
}
