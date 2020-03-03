//
//  BezierVew.swift
//  gift_app
//
//  Created by Lexy on 8/6/19.
//  Copyright © 2019 Lexy. All rights reserved.
//

import UIKit

@IBDesignable class BezierView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.distance = 0.0
        self.radius = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.distance = 0.0
        self.radius = 0.0
    }
    
    @IBInspectable public var radius: CGFloat = 0
    @IBInspectable public var distance: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        self.complexShape()
//        UIColor.orange.setFill()
//        path.fill()
//
//        UIColor.purple.setStroke()
//        path.stroke()
    }
    var path: UIBezierPath!
    
    func complexShape() {
        let height = self.frame.height
        let width = self.frame.width
        
        let tanX = height / distance
        let alphaX = atan(tanX)
        let radius1 = tan(alphaX/2) * radius
        let radius2 = radius / tan(alphaX/2)
        
        
        path = UIBezierPath()
        path.move(to: CGPoint(x: radius, y: radius1))
        path.move(to: CGPoint(x: width - radius, y: 0.0))
        path.addArc(withCenter: CGPoint(x: width - radius, y: radius), radius: radius, startAngle: CGFloat(270.0).toRadians(), endAngle: CGFloat(360.0).toRadians(), clockwise: true)
        path.addLine(to: CGPoint(x: width, y: height - radius))
        path.addArc(withCenter: CGPoint(x: width - radius, y: height - radius), radius: radius, startAngle: CGFloat(0.0).toRadians(), endAngle: CGFloat(90.0).toRadians(), clockwise: true)
        path.addLine(to: CGPoint(x: distance + radius, y: height))
        path.addArc(withCenter: CGPoint(x: distance + radius, y: height - radius2), radius: radius2, startAngle: CGFloat(90.0).toRadians(), endAngle: CGFloat(90.0).toRadians() + alphaX, clockwise: true)
        let x = cos(alphaX) * radius
        let y = sin(alphaX) * radius
        path.addLine(to: CGPoint(x: x, y: y))
        path.addArc(withCenter: CGPoint(x: radius, y: radius1), radius: radius1, startAngle: CGFloat(90.0).toRadians() + alphaX, endAngle: CGFloat(270.0).toRadians(), clockwise: true)
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        self.layer.mask = shapeLayer
    }
}
