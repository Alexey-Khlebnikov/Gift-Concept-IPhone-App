//
//  Global.swift
//  GIFT_APP
//
//  Created by Alguz on 11/23/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation
class Global {
    static var menuController: MainMenuViewController!
    static var mainViewController: MainViewController!
    
    static var selectedMenu: Int = 0
    static func selectMenu(index: Int) {
        menuController?.selectMenuItem(index: index)
        selectedMenu = index
    }
    static func selectMenu(menuName: String) {
        
        let menu_list = mainViewController.getMenuList()
        
        if let index = menu_list.firstIndex(of: menuName) {
            selectMenu(index: index)
            mainViewController.selectMenuItem(menuName: menuName)
        }
    }
    
    static func gotoSelectedView() {
        menuController?.gotoSelectedView(index: selectedMenu)
    }
    
    
    static func refreshMenu() {
        menuController.refresh()
    }
    
    
    static func gotoHome() {
        let menu_list = mainViewController.getMenuList()
        let menu_name = menu_list[0]
        selectMenu(menuName: menu_name)
    }
    
    
    
    static func openloginView() {
        menuController.setLoggedState()
    }
    static func logout() {
        menuController.setLoggedoutState()
    }
    static func openSignup() {
        menuController.setLoggedState()
    }
    static func setOpenContinueAsUser() {
        mainViewController.openLoginViewController()
    }
    
    static func setOpenEnterCode() {
        mainViewController.openEnterCodeViewController()
    }
    
    static func getBaseViewController(viewName: String) -> UIViewController? {
        let menuItem = mainViewController.menuList[viewName]
        return menuItem?.viewController
    }
    
    static var udid: String {
        get {
            return UIDevice.current.identifierForVendor!.uuidString
        }
    }
    
    static func instantiateVC(storyboardName: String, identifier: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc =  storyboard.instantiateViewController(identifier: identifier)
        return vc
    }
    
    static var selectedCategoryId: String?
}
