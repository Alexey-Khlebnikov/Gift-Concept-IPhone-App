//
//  SellerOrdersContainerViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 12/12/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialAppBar
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialColorScheme
import MaterialComponents.MaterialPalettes
import MaterialComponents.MaterialTabs
import MaterialComponents.MaterialTabs_ColorThemer
import MaterialComponents.MaterialTypographyScheme

class SellerOrdersContainerViewController: CollectionStoryboardViewController {
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var postId: String!
    
    override func viewDidLoad() {
        self.delegate = self
        super.viewDidLoad()
        setupViews()
        setTitle(index: 0)
        // Do any additional setup after loading the view.
    }

    lazy var tabBar: MDCTabBar = {
        let tabBar = MDCTabBar(frame: view.bounds)
        tabBar.items = [
            UITabBarItem(title: "Order detail", image: UIImage(systemName: "doc.richtext"), tag: 0),
            UITabBarItem(title: "Your bid", image: UIImage(systemName: "doc.richtext"), tag: 1),
            UITabBarItem(title: "Deliveriers", image: UIImage(systemName: "car.fill"), tag: 2)
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
    
    func setTitle(index: Int) {
        setTitle(tabBar.items[index].title)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SellerOrdersContainerViewController: MDCTabBarDelegate {
  func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
    guard let index = tabBar.items.firstIndex(of: item) else {
      fatalError("MDCTabBarDelegate given selected item not found in tabBar.items")
    }
    scrollToMenuIndex(index: index)
    setTitle(index: index)
  }
}

extension SellerOrdersContainerViewController: CollectionStoryboardViewDelegate {
    func storyboardViewWillEndDraging(index: Int) {
        let newTabBarItem = tabBar.items[index]
        tabBar.setSelectedItem(newTabBarItem, animated: true)
        setTitle(index: index)
    }
    
    func getStoryboardInfoList() -> [(storyboard: String, identifier: String)] {
        return [
            ("Seller", "SellerBuyOrderDetailViewController"),
            ("Seller", "SellerBidDetailViewController"),
            ("Seller", "DeliveryRequestViewController")
        ]
    }
    
    func senderList() -> [Any?] {
        return [postId, postId, postId]
    }
}
