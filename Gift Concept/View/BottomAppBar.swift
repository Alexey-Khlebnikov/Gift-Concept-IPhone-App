//
//  BottomAppBar.swift
//  GIFT_APP
//
//  Created by Alguz on 10/29/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation
import MaterialComponents.MaterialBottomAppBar

class BottomAppBar: MDCBottomAppBarView {
    private static var bottomBarView: BottomAppBar? = nil
    
    @objc static func show() {
        if bottomBarView == nil {
            bottomBarView = BottomAppBar()
        }
    }
    
    
    private func setupViews() {
        self.barTintColor = .mainColor1
        self.translatesAutoresizingMaskIntoConstraints = false
        self.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        if let keyWindow = UIApplication.keyWindow {
            keyWindow.addSubview(self)
            
            let size = self.sizeThatFits(keyWindow.bounds.size)
            let bottomBarViewFrame = CGRect(x: 0,
                y: keyWindow.bounds.size.height - size.height,
                width: size.width,
                height: size.height)
            self.frame = bottomBarViewFrame
            initBarButtonItems(keyWindow)
        }
    }
    
    func initBarButtonItems(_ keyWindow: UIWindow) {
        self.floatingButton.backgroundColor = .mainColor1
        self.floatingButton.tintColor = .white
        self.floatingButton.setImage(UIImage(named: "icon_Cart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.floatingButton.accessibilityLabel = "Cart"
        self.floatingButtonPosition = .center
        
        let btnWidth = (self.frame.width - self.floatingButton.frame.width - 4) / 4
        
        let btnHome = UIBarButtonItem(
            image: UIImage(named: "icon_Home")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(onHomeButtonTapped)
        )
        btnHome.width = btnWidth
        btnHome.tintColor = .white
        
        let btnPostList = UIBarButtonItem(
            image: UIImage(named: "icon_PostList")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(onHomeButtonTapped)
        )
        btnPostList.width = btnWidth
        
        self.leadingBarButtonItems = [btnHome, btnPostList]
        
        let btnNotification = UIBarButtonItem(
            image: UIImage(named: "icon_Bell")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(onHomeButtonTapped)
        )
        btnNotification.width = btnWidth
        
        let btnAccount = UIBarButtonItem(
            image: UIImage(named: "icon_Account")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(onHomeButtonTapped)
        )
        btnAccount.width = btnWidth
        
        self.trailingBarButtonItems = [btnAccount, btnNotification]
        
    }
    
    @objc func onHomeButtonTapped() {
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
