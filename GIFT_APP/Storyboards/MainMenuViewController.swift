//
//  MainMenuViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 11/22/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

class MainMenuViewController: MenuViewController, Storyboardable {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImageViewCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cnt_tableViewWidth: NSLayoutConstraint!
    
    private var gradientLayer = CAGradientLayer()

    private var gradientApplied: Bool = false

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var mainViewController: MainViewController?
    
    var continueAsGuestViewName: String = "Home"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Select the initial row
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.none)
        
        mainViewController = (menuContainerViewController as? MainViewController)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        avatarImageViewCenterXConstraint.constant = -(menuContainerViewController?.transitionOptions.visibleContentWidth ?? 0.0)/2
        
        cnt_tableViewWidth.constant = view.frame.width - (menuContainerViewController?.transitionOptions.visibleContentWidth ?? 0.0)

        if gradientLayer.superlayer != nil {
            gradientLayer.removeFromSuperlayer()
        }
        let topColor = UIColor(rgb: 0x2b2b2b, alpha: 1.0)
        let bottomColor = UIColor(rgb: 0x444444, alpha: 1.0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    deinit{
        print()
    }
    
    func refresh() {
        if self.tableView == nil {
            return;
        }
        self.tableView.reloadData()
    }

    func setLoggedState() {
        
    }
    
    func setLoggedoutState() {
        if let menuContainerView = menuContainerViewController as? MainViewController {
            menuContainerView.contentViewControllers = menuContainerView.contentControllers()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

extension MainMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func selectMenuItem(index: Int) {
        if self.tableView == nil {
            return;
        }
        let indexPath = IndexPath(item: index, section: 0)

        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    }
    func gotoSelectedView(index: Int) {
        guard let menuContainerViewController = self.menuContainerViewController as? MainViewController else {
            return
        }
        let viewController = menuContainerViewController.contentViewControllers[index]
        if index <= 3 {
            if let homeController = (viewController as! MainNavigationController).homeController {
                homeController.scrollToMenuIndex(menuIndex: index)
                homeController.setBottomViewItem(menuIndex: index)
            }
        }
        menuContainerViewController.selectContentViewController(viewController)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewController?.getMenuList().count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainMenuCell.self), for: indexPath) as? MainMenuCell else {
            preconditionFailure("Unregistered table view cell")
        }
        let menu_list = mainViewController?.menuList
        let item_name = mainViewController!.getMenuList()[indexPath.item]
        let menuItem = menu_list?[item_name]
        
        cell.lbl_title.text = menuItem?.title
        
        cell.iv_icon.image = menuItem?.icon?.withRenderingMode(.alwaysTemplate)
        cell.v_realtimeCount.alpha = 0
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let item_name = mainViewController!.getMenuList()[indexPath.item]
        
        menuContainerViewController?.hideSideMenu()
        if item_name == "Logout" { // logout button
            User.Me.logout()
            return nil
        }
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }
        let menu_list = mainViewController?.menuList
        let item_name = mainViewController!.getMenuList()[indexPath.item]
        let menuItem = menu_list?[item_name]
        
        if let viewController = menuItem?.viewController {
            menuContainerViewController.selectContentViewController(viewController)
            if User.Me.isLogged && User.Me.role == "seller" {
                if indexPath.row <= 3 {
                    if let homeController = (viewController as! SellerBasesNavigationController).homeController {
                        homeController.scrollToMenuIndex(menuIndex: indexPath.row)
                        homeController.setBottomViewItem(menuIndex: indexPath.row)
                    }
                }
            } else {
                if indexPath.row <= 3 {
                    if let homeController = (viewController as! MainNavigationController).homeController {
                        homeController.scrollToMenuIndex(menuIndex: indexPath.row)
                        homeController.setBottomViewItem(menuIndex: indexPath.row)
                    }
                }
            }
        }
        menuContainerViewController.hideSideMenu()
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == Global.selectedMenu {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }

//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.5
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 46
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
}



class MainMenuCell: UITableViewCell {
    @IBOutlet weak var v_selected: MyBaseView!
    @IBOutlet weak var iv_icon: UIImageView!
    @IBOutlet weak var v_realtimeCount: MyBaseView!
    @IBOutlet weak var lbl_realtimeCount: UILabel!
    
    @IBOutlet weak var lbl_title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        v_selected.backgroundColor = selected ? UIColor(rgb: 0x000000, alpha: 0.25) : .clear
        lbl_title.textColor = .white
    }
}
