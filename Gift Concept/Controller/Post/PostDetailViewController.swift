//
//  PostDetailViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 10/31/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit
import MaterialComponents

class PostDetailViewController: MDCTabBarViewController, MDCTabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTabBar()
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: StoreCart.shared.btn_Cart)]
    }
    var post: Post!

    func loadTabBar() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "PostDetailView_Detail") as! PostContentController
        detailVC.post = post
        
        let proposalsVC = storyboard.instantiateViewController(withIdentifier: "PostDetailView_Proposals") as! PostProposalsController
        proposalsVC.post = post
        
        let reviewsVC = storyboard.instantiateViewController(withIdentifier: "PostDetailView_Reviews") as! PostReviewsController
        reviewsVC.post = post
        
        
        detailVC.tabBarItem = UITabBarItem(title: "Detail", image: UIImage(systemName: "doc.plaintext")?.withRenderingMode(.alwaysTemplate), tag: 0)
        detailVC.setupTopWrapper()

        proposalsVC.tabBarItem =  UITabBarItem(title: "Proposals", image: UIImage(systemName: "list.bullet.below.rectangle")?.withRenderingMode(.alwaysTemplate), tag: 1)
        proposalsVC.setupTopWrapper()

        reviewsVC.tabBarItem = UITabBarItem(title: "Reviews", image: UIImage(systemName: "square.and.pencil")?.withRenderingMode(.alwaysTemplate), tag: 2)
        reviewsVC.setupTopWrapper()

        let viewControllersArray = [detailVC, proposalsVC, reviewsVC]
        viewControllers = viewControllersArray
        
        tabBar?.items = [detailVC.tabBarItem,
                         proposalsVC.tabBarItem ,
                         reviewsVC.tabBarItem]

        tabBar?.delegate = self
        
        let childVC = viewControllers.first
        selectedViewController = childVC
        tabBar?.selectedItem = tabBar?.items.first
        navigationItem.title = "Detail"
        tabBar?.backgroundColor = MDCPalette.pink.tint500
        
        tabBar?.selectedItemTintColor = .white
        tabBar?.unselectedItemTintColor = UIColor(rgb: 0x000000, alpha: 0.5)
        tabBar?.inkColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        tabBar?.alignment = .justified
	
    }

    override func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {

        switch item.tag {
        case 0:
            navigationItem.title = "Detail"
            tabBar.backgroundColor = MDCPalette.pink.tint500
            selectedViewController = viewControllers[0]
        case 1:
            navigationItem.title = "Proposals"
            tabBar.backgroundColor = MDCPalette.purple.tint500
            selectedViewController = viewControllers[1]
        case 2:
            navigationItem.title = "Reviews"
                tabBar.backgroundColor = MDCPalette.teal.tint500
                selectedViewController = viewControllers[2]
        default:
            tabBar.backgroundColor = MDCPalette.pink.tint500
            selectedViewController = viewControllers[0]
        }

    }

}
