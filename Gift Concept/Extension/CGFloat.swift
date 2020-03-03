//
//  CGFloat.swift
//  GIFT_APP
//
//  Created by Alguz on 10/29/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//
import UIKit

extension CGFloat {
    func toRadians() -> CGFloat {
        return CGFloat(self * CGFloat(Double.pi) / 180.0)
    }
    func toString(toFixed: Int) -> String {
        return String(format: "%.\(toFixed)f", self)
    }
}

extension Float {
    func toString(toFixed: Int) -> String {
        return String(format: "%.\(toFixed)f", self)
    }
}
