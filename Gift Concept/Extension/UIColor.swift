//
//  UIColor.swift
//  gift_app
//
//  Created by Alguz on 10/27/19.
//  Copyright © 2019 Lexy. All rights reserved.
//
import UIKit
import MaterialComponents.MDCPalettes

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(blue) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha: Int = 255) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(blue) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
    }
    
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: alpha
        )
    }
    
    convenience init(rgba: Int) {
        self.init(
            red: (rgba >> 24) & 0xFF,
            green: (rgba >> 16) & 0xFF,
            blue: (rgba >> 8) & 0xFF,
            alpha: rgba & 0xFF
        )
    }
    
    static var mainColor1: UIColor {
        get {
//            return UIColor(rgb: 0xFF2D55)
//            return UIColor(red: 233, green: 32, blue: 126)
            return MDCPalette.pink.tint500 //return UIColor(red: 233, green: 30, blue: 99) //0xE91E63
        }
    }
    
    static var selectedBarButtonColor: UIColor {
        get {
            return .white
        }
    }
    
    static var unselectedBarButtonColor: UIColor {
        get {
            return UIColor(red: 91, green: 14, blue: 13)
        }
    }
    
    static var openColor: UIColor {
        return UIColor(rgb: 0x00be7d)
    }
    
    static var mainBgColor: UIColor {
        return .white
    }
    static var secondBgColor: UIColor {
        return UIColor(rgb: 0xE3EAF1)
    }
}
