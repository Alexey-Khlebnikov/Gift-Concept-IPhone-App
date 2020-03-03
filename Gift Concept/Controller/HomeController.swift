//
//  ViewController.swift
//  gift_app
//
//  Created by Lexy on 7/21/19.
//  Copyright © 2019 Lexy. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftMessages

class HomeController: UIViewController, SideMenuItemContent {
    
    let categoryCellId = "categoryCell"
    let billContainerCellId = "billContainerCellId"
    let emptyCellId = "emptyCell"
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var collectionView: UICollectionView!
    var initSelectedTabIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBottomView()
        configureCollectionView()
        
        navigationController?.navigationBar.isTranslucent = false
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
        setupTopWrapper()
        if(initSelectedTabIndex != 0) {
            scrollToMenuIndex(menuIndex: initSelectedTabIndex)
            setBottomViewItem(menuIndex: initSelectedTabIndex)
        }
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: StoreCart.shared.btn_Cart)]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserProductListViewController" {
            let _sender = sender as? (title: String, category_id: String)
            let viewController = segue.destination as! UserProductListViewController
            viewController.title = _sender?.title
            viewController.categoryId = _sender?.category_id
        } else if segue.identifier == "showMoreMenu" {
            let viewController = segue.destination
            viewController.preferredContentSize = CGSize(width: view.frame.width, height: view.frame.height)
        } else if segue.identifier == "PostDetailViewController" {
            let viewController = segue.destination as! PostDetailViewController
            viewController.post = sender as? Post
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        print(tappedImage)
        // And some actions
    }
    
    @objc func handleSearch() {
        print("Search")
    }
    @objc func handleCart() {
        print("Cart")
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        if(!isViewLoaded) {
            initSelectedTabIndex = menuIndex
            return
        }
        setNavItems(menuIndex)
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    lazy var bbtn_account_setting: UIBarButtonItem = {
        let bbtn = UIBarButtonItem(image: UIImage(named: "setting")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(openAccountSetting))
        return bbtn
    }()
    
    func setNavItems(_ menuIndex: Int) {
        switch menuIndex {
        case 0:
            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: StoreCart.shared.btn_Cart)]
            return
        case 3:
            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: StoreCart.shared.btn_Cart), bbtn_account_setting]
        default:
            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: StoreCart.shared.btn_Cart)]
            return
        }
    }
    
    func setTitle(_ title: String?) {
        navigationItem.title = title
    }
    
    @objc func openAccountSetting() {
        self.performSegue(withIdentifier: "AccountSetting", sender: self)
    }
    
    func toggleMoreMenu() {
        showSideMenu()
    }
}

// MARK: - CollectionView
extension HomeController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func configureCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.backgroundColor = .white
        collectionView.layer.zPosition = -1
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: categoryCellId)
        collectionView.register(PostListViewCell.self, forCellWithReuseIdentifier: "PostListViewCell")
        collectionView.register(AlertListViewCell.self, forCellWithReuseIdentifier: "AlertListViewCell")
        collectionView.register(AccountViewCell.self, forCellWithReuseIdentifier: "AccountViewCell")
        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomOffset = bottomView().frame.height
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat(format: "V:|[v0]-\(bottomOffset)-|", views: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bottomView().items.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellId, for: indexPath) as! FeedCell
            cell.viewController = self
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostListViewCell", for: indexPath) as! PostListViewCell
            cell.viewController = self
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlertListViewCell", for: indexPath) as! AlertListViewCell
            cell.viewController = self
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountViewCell", for: indexPath) as! AccountViewCell
            cell.viewController = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let x = scrollView.contentOffset.x
//        if(x > view.frame.width * 2) {
//            menuBar.horizontalConstraintLeftAnchor?.constant = (view.frame.width + x) / 5
//        } else if(x > view.frame.width) {
//            menuBar.horizontalConstraintLeftAnchor?.constant = (view.frame.width + (x - view.frame.width) * 2) / 5
//        } else {
//            menuBar.horizontalConstraintLeftAnchor?.constant = x / 5
//        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        setBottomViewItem(menuIndex: index)
        
    }
    
    func setBottomViewItem(menuIndex: Int) {
        if(!isViewLoaded) {
            initSelectedTabIndex = menuIndex
            return
        }
        Global.selectMenu(index: menuIndex)
        setNavItems(menuIndex)
        bottomView().selectedItem = bottomView().items[menuIndex]
        setTitle(bottomView().selectedItem?.title)
    }
}

// MARK: - BottomNavBar
extension HomeController: MDCBottomNavigationBarDelegate  {
    func configureBottomView(){
        if view.viewWithTag(5312) != nil {
            return
        }
        let bottomLayout: CGFloat = bottomBarOffset()
        let bottomView = MDCBottomNavigationBar()
        bottomView.frame = CGRect(x: 0, y: view.frame.height - 49 - bottomLayout, width: view.frame.width, height: 49 + bottomLayout)
        bottomView.items = [
            UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "icon_Home"), tag: 0),
            UITabBarItem(title: "Posts", image: #imageLiteral(resourceName: "icon_Post"), tag: 1),
            UITabBarItem(title: "Alerts", image: #imageLiteral(resourceName: "icon_Bell"), tag: 2),
            UITabBarItem(title: "Account", image: #imageLiteral(resourceName: "icon_Account"), tag: 3),
            UITabBarItem(title: "More", image: #imageLiteral(resourceName: "icon_More"), tag: 4)
        ]
        bottomView.alignment = .centered
        bottomView.selectedItemTintColor = .selectedBarButtonColor
        bottomView.unselectedItemTintColor = .unselectedBarButtonColor
        bottomView.backgroundColor = .mainColor1
        bottomView.tag = 5312
        bottomView.delegate = self
        
        bottomView.selectedItem = bottomView.items.first
        setTitle(bottomView.selectedItem?.title)
        
        view.addSubview(bottomView)
    }
    
    func bottomView() -> MDCBottomNavigationBar {
        if let bottomView = view.viewWithTag(5312) as? MDCBottomNavigationBar {
            return bottomView
        } else {
            configureBottomView()
            return bottomView()
        }
    }
    
    func bottomNavigationBar(_ bottomNavigationBar: MDCBottomNavigationBar, didSelect item: UITabBarItem) {
        
        scrollToMenuIndex(menuIndex: item.tag)
        setTitle(item.title)
        Global.selectMenu(index: item.tag)
    }
    
    func bottomNavigationBar(_ bottomNavigationBar: MDCBottomNavigationBar, shouldSelect item: UITabBarItem) -> Bool {
        if item.tag == bottomView().items.count - 1 {
            toggleMoreMenu()
            return false
        }
        return true
    }
}

