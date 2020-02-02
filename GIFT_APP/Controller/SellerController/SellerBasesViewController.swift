//
//  SellerBasesViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 12/4/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit
import MaterialComponents

class SellerBasesViewController: CollectionStoryboardViewController, SideMenuItemContent {
    
    lazy var bottomTabBar: MDCBottomNavigationBar = {
        let tabBar = MDCBottomNavigationBar()
        tabBar.delegate = self
        return tabBar
    }()
    
    lazy var btnOpenSettingView: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(named: "setting")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(openSettingView))
        return btn
    }()
    
    @objc func openSettingView() {
        SellerSettingViewController.shared.showView()
    }
    
    override func viewDidLoad() {
        self.delegate = self
        super.viewDidLoad()
        setupBottomTabBar()
        setTitle(bottomTabBar.items.first?.title)
        setNavigationBar(index: 0)
    }
    
    func setBottomTabBarItem(index: Int) {
        guard isViewLoaded else {
            initSelectedTabIndex = index
            return
        }
        Global.selectMenu(index: index)
        bottomTabBar.selectedItem = bottomTabBar.items[index]
        setTitle(bottomTabBar.selectedItem?.title)
        setNavigationBar(index: index)
    }
    
    func setNavigationBar(index: Int) {
        if index == 0 {
            navigationItem.rightBarButtonItems = [btnOpenSettingView]
        } else {
            navigationItem.rightBarButtonItems = []
        }
    }
    
    func setupBottomTabBar() {
        let bottomLayout = bottomBarOffset()
        bottomTabBar.frame = CGRect(x: 0, y: view.frame.height - 49 - bottomLayout, width: view.frame.width, height: 49 + bottomLayout)
        
        bottomTabBar.alignment = .centered
        bottomTabBar.selectedItemTintColor = .selectedBarButtonColor
        bottomTabBar.unselectedItemTintColor = .unselectedBarButtonColor
        bottomTabBar.backgroundColor = .mainColor1
        
        view.addSubview(bottomTabBar)
        
        bottomTabBar.items = self.bottomTabBarItems()
        bottomTabBar.selectedItem = bottomTabBar.items.first
    }
    
    func bottomTabBarItems() -> [UITabBarItem] {
        
        return [
            UITabBarItem(title: "Request", image: UIImage(systemName: "tray.2.fill"), tag: 0),
            UITabBarItem(title: "Product", image: #imageLiteral(resourceName: "icon_Post"), tag: 1),
            UITabBarItem(title: "Alert", image: #imageLiteral(resourceName: "icon_Bell"), tag: 2),
            UITabBarItem(title: "Account", image: #imageLiteral(resourceName: "icon_Account"), tag: 3),
            UITabBarItem(title: "More", image: #imageLiteral(resourceName: "icon_More"), tag: 4)
        ]
    }
}

extension SellerBasesViewController: MDCBottomNavigationBarDelegate {
    func bottomNavigationBar(_ bottomNavigationBar: MDCBottomNavigationBar, didSelect item: UITabBarItem) {
        scrollToMenuIndex(index: item.tag)
        setNavigationBar(index:  item.tag)
        Global.selectMenu(index: item.tag)
    }
    
    func bottomNavigationBar(_ bottomNavigationBar: MDCBottomNavigationBar, shouldSelect item: UITabBarItem) -> Bool {
        if item.title == "More" {
            showSideMenu()
            return false
        }
        return true
    }
}

extension SellerBasesViewController: CollectionStoryboardViewDelegate {
    func senderList() -> [Any?] {
        return []
    }
    
    func getStoryboardInfoList() -> [(storyboard: String, identifier: String)] {
        return [
            ("Seller","SellerRequestsViewController"),
//            ("Seller","SellerCategoryViewController"),
            ("Seller","SellerProductsViewController"),
            ("Seller","SellerNotificationViewController"),
            ("Seller", "SellerAccountViewController")
        ]
    }
    
    func storyboardViewWillEndDraging(index: Int) {
        setBottomTabBarItem(index: index)
    }
    
}
