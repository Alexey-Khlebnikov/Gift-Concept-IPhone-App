//
//  MainViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 11/22/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

class MainViewController: MenuContainerViewController {
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    var menuList: Dictionary<String, MenuDataItem> = [:]
    
    var loginViewController: LoginViewController!
    var enterCodeViewController: EnterCodeViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        let screenSize: CGRect = UIScreen.main.bounds
        self.transitionOptions = TransitionOptions(duration: 0.4, visibleContentWidth: screenSize.width / 3)

        // Instantiate menu view controller by identifier
        self.menuViewController = MainMenuViewController.storyboardViewController()
        
        Global.menuController = self.menuViewController as? MainMenuViewController
        
        Global.mainViewController = self
        self.menuViewController.modalPresentationStyle = .fullScreen

        // Gather content items controllers
        self.contentViewControllers = contentControllers()

        // Select initial content controller. It's needed even if the first view controller should be selected.
        self.selectContentViewController(menuList["Login"]!.viewController)
        
        self.currentItemOptions.cornerRadius = 10.0
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // Options to customize menu transition animation.
        var options = TransitionOptions()

        // Animation duration
        options.duration = size.width < size.height ? 0.4 : 0.6

        // Part of item content remaining visible on right when menu is shown
        options.visibleContentWidth = size.width / 3
        self.transitionOptions = options
    }
    
    func openLoginViewController() {
       self.selectContentViewController(loginViewController)
    }
    
    func openEnterCodeViewController() {
       self.selectContentViewController(enterCodeViewController)
    }
    
    func selectMenuItem(menuName: String) {
        let menuList = self.getMenuList()
        if menuList.contains(menuName) {
            let menuItem = self.menuList[menuName]!
            self.selectContentViewController(menuItem.viewController)
        }
    }
    
    func contentControllers() -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(identifier: "MainNavigationController")
        let ordersController = storyboard.instantiateViewController(identifier: "OrdersController")
        
        let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginModeViewController = authStoryboard.instantiateViewController(identifier: "LoginModeViewController")
        
        let signupViewController = authStoryboard.instantiateViewController(identifier: "SignupViewController")
        
        self.loginViewController = authStoryboard.instantiateViewController(identifier: "LoginViewController")
        
        self.enterCodeViewController = authStoryboard.instantiateViewController(identifier: "EnterCodeViewController")
        
        
        let sellerNavigationView = UIStoryboard(name: "Seller", bundle: nil).instantiateViewController(identifier: "SellerMainViewController")
        
        menuList = [
            "Home": MenuDataItem(title: "Home", icon: UIImage(named: "icon_Home"), viewController: navigationController),
            "Posts": MenuDataItem(title: "Posts", icon: UIImage(named: "icon_Post"), viewController: navigationController),
            "Alerts": MenuDataItem(title: "Alerts", icon: UIImage(named: "icon_Bell"), viewController: navigationController),
            "Account": MenuDataItem(title: "Account", icon: UIImage(named: "icon_Account"), viewController: navigationController),
            "Orders": MenuDataItem(title: "Orders", icon: UIImage(named: "icon_Delivery"), viewController: ordersController),
            "Login": MenuDataItem(title: "Log in", icon: UIImage(named: "icon_Login"), viewController: loginModeViewController),
            "Signup": MenuDataItem(title: "Sign up", icon: UIImage(named: "icon_Signup"), viewController: signupViewController),
            "Logout": MenuDataItem(title: "Log out", icon: UIImage(named: "icon_Logout"), viewController: loginViewController),

            "SellerBuyRequests": MenuDataItem(title: "Requests", icon: UIImage(systemName: "tray.2.fill"), viewController: sellerNavigationView),
            "SellerHome1": MenuDataItem(title: "Products", icon: #imageLiteral(resourceName: "icon_Post"), viewController: sellerNavigationView),
            "SellerHome2": MenuDataItem(title: "Alerts", icon: #imageLiteral(resourceName: "icon_Bell"), viewController: sellerNavigationView),
            "SellerHome3": MenuDataItem(title: "Account", icon: #imageLiteral(resourceName: "icon_Account"), viewController: sellerNavigationView),
        ]
        return [navigationController, navigationController, navigationController, navigationController, ordersController, loginModeViewController, signupViewController, sellerNavigationView]
    }
    
    func getMenuList() -> [String] {
        if(User.Me.isLogged) {
            return loggedMenuList()
        }
        return loggedOutMenuList()
    }
    
    func loggedMenuList() -> [String] {
        if User.Me.role == "seller" {
            return ["SellerBuyRequests", "SellerHome1", "SellerHome2", "SellerHome3", "Logout"]
        }
        return ["Home", "Posts", "Alerts", "Account", "Orders", "Logout"]
    }
    func loggedOutMenuList() -> [String] {
        return ["Home", "Posts", "Alerts", "Account", "Orders", "Login", "Signup"]
    }
    
    func loggout() {
        DispatchQueue.main.async {
            (self.menuViewController as! MainMenuViewController).tableView.reloadData()
        }
    }
}


class MenuDataItem {
    var title: String
    var icon: UIImage?
    var viewController: UIViewController
    
    init(title: String, icon: UIImage?, viewController: UIViewController) {
        self.title = title
        self.icon = icon
        self.viewController = viewController
    }
}
