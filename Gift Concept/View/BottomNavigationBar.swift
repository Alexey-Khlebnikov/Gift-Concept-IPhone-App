//
//  BottomNavigationBar.swift
//  GIFT_APP
//
//  Created by Alguz on 10/29/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialBottomAppBar

class BottomNavigationBar: MDCBottomNavigationBar {
    private static var instance: BottomNavigationBar!
    private func setupViews() {
        self.items = [
            UITabBarItem(title: "Home", image: UIImage(named: "icon_Home"), tag: 0),
            UITabBarItem(title: "Home", image: UIImage(named: "icon_Home"), tag: 1),
            UITabBarItem(title: "Home", image: UIImage(named: "icon_Home"), tag: 2),
            UITabBarItem(title: "Home", image: UIImage(named: "icon_Home"), tag: 3),
            UITabBarItem(title: "Home", image: UIImage(named: "icon_Home"), tag: 4),
        ]
        self.selectedItem = self.items.first
        self.titleVisibility = .selected
        self.alignment = .centered
        
        if let keyWindow = UIApplication.keyWindow {
            keyWindow.addSubview(self)
            
            let size = self.sizeThatFits(keyWindow.bounds.size)
            let bottomBarViewFrame = CGRect(x: 0,
                y: keyWindow.bounds.size.height - size.height,
                width: size.width,
                height: size.height)
            self.frame = bottomBarViewFrame
        }
    }
    
    @objc static func show() {
        if (instance == nil) {
            instance = BottomNavigationBar()
        }
    }
    
    convenience init() {
        self.init()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
