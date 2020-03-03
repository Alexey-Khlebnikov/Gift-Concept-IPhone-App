//
//  SellerRequestsViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 12/5/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit
import MaterialComponents

class SellerRequestsViewController: CollectionStoryboardViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        self.delegate = self
        super.viewDidLoad()
        
        SocketIOApi.shared.socket.on("newPost") { (arguments, ack) in
            self.newPostCount += 1
            self.tabBarItemPosts.badgeValue = self.newPostCount == 0 || self.tabBar.selectedItem == self.tabBarItemPosts ? nil : String(self.newPostCount)
        }
        
        setupViews()
    }
    
    let tabBarItemPosts: UITabBarItem = {
        let tabBarItem = UITabBarItem(title: "Posts", image: UIImage(systemName: "square.grid.2x2.fill"), tag: 0)
        tabBarItem.badgeColor = .yellow
        return tabBarItem
    }()
    var newPostCount: Int = 0
    
    
    let tabBarItemOrders: UITabBarItem = {
        let tabBarItem = UITabBarItem(title: "Bids", image: UIImage(systemName: "cart.fill"), tag: 1)
        tabBarItem.badgeColor = .yellow
        return tabBarItem
    }()
    var newOrderCount: Int = 0
    
    
    lazy var tabBar: MDCTabBar = {
        let tabBar = MDCTabBar(frame: view.bounds)
        tabBar.items = [
            tabBarItemPosts,
            tabBarItemOrders,
//            UITabBarItem(title: "Delivery", image: UIImage(systemName: "car.fill"), tag: 2),
        ]
        tabBar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        
        tabBar.tintColor = .white
        tabBar.inkColor = UIColor.white.withAlphaComponent(0.15)
        tabBar.backgroundColor = .mainColor1
        tabBar.itemAppearance = .titledImages
        tabBar.alignment = .justified

        // Configure custom title fonts
//        tabBar.selectedItemTitleFont = UIFont.boldSystemFont(ofSize: 12)
//        tabBar.unselectedItemTitleFont = UIFont.systemFont(ofSize: 12)

        // Configure custom indicator template
        tabBar.selectionIndicatorTemplate = IndicatorTemplate()
        
        tabBar.delegate = self
        
        tabBar.sizeToFit()
        self.flowLayout.sectionInset.top = tabBar.bounds.height
        return tabBar
    }()
    
    
    func setupViews() {
        view.addSubview(tabBar)
    }

    // MARK: Private

    class IndicatorTemplate: NSObject, MDCTabBarIndicatorTemplate {
      func indicatorAttributes(
        for context: MDCTabBarIndicatorContext
      ) -> MDCTabBarIndicatorAttributes {
        let attributes = MDCTabBarIndicatorAttributes()
        // Outset frame, round corners, and stroke.
        let indicatorFrame = context.contentFrame.insetBy(dx: -8, dy: -4)
        let path = UIBezierPath(roundedRect: indicatorFrame, cornerRadius: 4)
        attributes.path = path.stroked(withWidth: 2)
        return attributes
      }
    }
    
    func resetBadge(_ index: Int) {
        let item = tabBar.items[index]
        item.badgeValue = nil
        item.badgeColor = .yellow
        if index == 0 {
            StoreSellerPost.postRequestsViewController?.actionShowMore("")
            self.newPostCount = 0
        } else {
//            StoreSellerPost.buyRequestsViewController?.actionShowMore("")
        }
    }
}

extension SellerRequestsViewController: CollectionStoryboardViewDelegate {
    func senderList() -> [Any?] {
        return []
    }
    
    func storyboardViewWillEndDraging(index: Int) {
        let newTabBarItem = tabBar.items[index]
        tabBar.setSelectedItem(newTabBarItem, animated: true)
        resetBadge(index)
    }
    
    func getStoryboardInfoList() -> [(storyboard: String, identifier: String)] {
        return [
            ("Seller","SellerPostRequsetsViewController"),
            ("Seller", "SellerBuyRequestsViewController"),
//            ("Seller", "DeliveryRequestViewController")
        ]
    }
}

extension SellerRequestsViewController: MDCTabBarDelegate {
  func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
    guard let index = tabBar.items.firstIndex(of: item) else {
      fatalError("MDCTabBarDelegate given selected item not found in tabBar.items")
    }
    scrollToMenuIndex(index: index)
    resetBadge(index)
  }
}

extension UIBezierPath {
  /// Returns a copy of the path, stroked with the given line width.
  func stroked(withWidth width: CGFloat) -> UIBezierPath {
    let strokedPath = cgPath.copy(
      strokingWithWidth: width,
      lineCap: .butt,
      lineJoin: .miter,
      miterLimit: 0)
    return UIBezierPath(cgPath: strokedPath)
  }
}
