//
//  ProductListController.swift
//  gift_app
//
//  Created by Lexy on 10/3/19.
//  Copyright © 2019 Lexy. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialBottomAppBar
import SwiftMessages

class SoldProductListController: UIViewController, CustomCollectionViewDelegate {
    let bottomAppBarHeight: CGFloat = 86

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat(format: "V:|[v0]-\(bottomAppBarHeight - 34 + bottomBarOffset())-|", views: collectionView)
        collectionView.refresh()
        
        configureAppBarView()
        
        setupTopWrapper()
    }
    var category_id: String? {
        didSet {
            if let categoryId = self.category_id {
                loadProductList(categoryId: categoryId)
            }
        }
    }
    var topProdutsData: [Product] = []
    var bestSellersData: [Seller] = []
    var latestProductsData: [Product] = []

    // MARK: - Load Data
    func loadProductList(categoryId: String) {
        ApiService.sharedService.fetchBestSellers { (bestSellers: [Seller]) in
            self.bestSellersData = bestSellers
            self.topSellersCollectionView.refresh()
        }
        ApiService.sharedService.fetchTopProducts(categoryId: categoryId) { (topProducts: [Product]) in
            self.topProdutsData = topProducts
            self.featuredProductsCollectionView.refresh()
        }
        ApiService.sharedService.fetchLatestProducts { (products: [Product]) in
            self.latestProductsData = products
            self.collectionView.refresh()
        }
    }
    
    var bottomBarView: MDCBottomAppBarView!
    
    // MARK: - MainCollectionView
    
    lazy var collectionView: CustomCollectionView = {
        let collectionView = CustomCollectionView()
        collectionView.shadow(left: 0.0, top: 15.0, feather: 15, color: .black, opacity: 0.1)
        collectionView.padding = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        collectionView.cellSpacing = 16
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICell")
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell")
        collectionView.direction = .vertical
        
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func cellSize(index: Int) -> (groupCount: Int, itemSize: CGFloat) {
        switch index {
        case 0:
            return (1, 455)
        default:
            return (2, 200)
        }
    }
    func cellForItemAt(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICell", for: indexPath)
            makeCell(cell: cell)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
            cell.product = latestProductsData[indexPath.item - 1]
            return cell
        }
    }
    func numberOfItemsInSection(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.latestProductsData.count + 1
    }
    
    func didSelectItemAt(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item > 0 {
            let data = latestProductsData[indexPath.item - 1]
            self.performSegue(withIdentifier: "ProductDetailViewController", sender: (data.name, data.id))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductDetailViewController" {
            let _sender = sender as? (product_name: String, product_id: String)
            let viewController = segue.destination as? ProductDetailViewController
            viewController?.title = "Product Detail"
            viewController?.product_id = _sender?.product_id
        } else if segue.identifier == "NewPostSegue" {
            let viewController = segue.destination as? NewPostController
            viewController?.rootViewController = self
            viewController?.categoryId = category_id 
        }
    }
    
    private var isMadeCell = false
    func makeCell(cell: UICollectionViewCell) {
        if isMadeCell {
            return
        }
        isMadeCell = true
        let topMainView = UIView()
        topMainView.translatesAutoresizingMaskIntoConstraints = false
        
        let topSellerLabel = UILabel()
        topSellerLabel.text = "Top Sellers"
        topSellerLabel.translatesAutoresizingMaskIntoConstraints = false
        topMainView.addSubview(topSellerLabel)
        
        topMainView.addSubview(topSellersCollectionView)
        
        let featuredProductLabel = UILabel()
        featuredProductLabel.text = "Featured Products"
        featuredProductLabel.translatesAutoresizingMaskIntoConstraints = false
        topMainView.addSubview(featuredProductLabel)
        
        topMainView.addSubview(featuredProductsCollectionView)
        
        let latestProductLabel = UILabel()
        latestProductLabel.text = "Latest Products"
        latestProductLabel.translatesAutoresizingMaskIntoConstraints = false
        topMainView.addSubview(latestProductLabel)
        
        topMainView.addConstraintsWithFormat(format: "H:|[v0]|", views: topSellerLabel)
        topMainView.addConstraintsWithFormat(format: "H:|-(-20)-[v0]-(-20)-|", views: topSellersCollectionView)
        topMainView.addConstraintsWithFormat(format: "H:|[v0]|", views: featuredProductLabel)
        topMainView.addConstraintsWithFormat(format: "H:|-(-20)-[v0]-(-20)-|", views: featuredProductsCollectionView)
        topMainView.addConstraintsWithFormat(format: "H:|[v0]|", views: latestProductLabel)
        
        topMainView.addConstraintsWithFormat(format: "V:|-20-[v0(25)]-10-[v1(150)]-20-[v2(25)]-10-[v3(250)]-20-[v4(25)]", views: topSellerLabel, topSellersCollectionView, featuredProductLabel, featuredProductsCollectionView, latestProductLabel)
        
        cell.addSubview(topMainView)
        cell.addConstraintsWithFormat(format: "H:|[v0]|", views: topMainView)
        cell.addConstraintsWithFormat(format: "V:|[v0]|", views: topMainView)
    }
    
    
    // MARK: - TopSellersCollectionView
    
    lazy var topSellersCollectionView: CustomCollectionView = {
        let collectionView = CustomCollectionView()
        collectionView.padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionView.cellSize = self.topSellersCollectionViewCellSize
        collectionView.cellForItemAt = self.topSellersCellForItemAt
        collectionView.numberOfItemsInSection = self.topSellersNumberOfItemsInSection
        collectionView.didSelectItemAt = self.topSellersDidSelectItemAt
        
        collectionView.register(TopSellerCell.self, forCellWithReuseIdentifier: "TopSellerCell")
        
        collectionView.collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func topSellersCollectionViewCellSize(index: Int) -> (groupCount: Int, itemSize: CGFloat) {
        return (1, 120)
    }
    
    func topSellersCellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopSellerCell", for: indexPath) as! TopSellerCell
        cell.seller = bestSellersData[indexPath.item]
        return cell
    }
    
    func topSellersNumberOfItemsInSection(collectionView: UICollectionView, section: Int) -> Int {
        return bestSellersData.count
    }
    func topSellersDidSelectItemAt(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("OK")
    }
    
    
    // MARK: - FeaturedProductsCollectionView
    
    lazy var featuredProductsCollectionView: CustomCollectionView = {
        let collectionView = CustomCollectionView()
        collectionView.padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionView.cellSize = self.featuredProductsCollectionViewCellSize
        collectionView.cellForItemAt = self.featuredProductsCellForItemAt
        collectionView.numberOfItemsInSection = self.featuredProductsNumberOfItemsInSection
        collectionView.didSelectItemAt = self.featuredProductsDidSelectItemAt
        
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell")
        
        collectionView.collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func featuredProductsCollectionViewCellSize(index: Int) -> (groupCount: Int, itemSize: CGFloat) {
        return (1, 250)
    }
    
    func featuredProductsCellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.product = topProdutsData[indexPath.item]
        return cell
    }
    
    func featuredProductsNumberOfItemsInSection(collectionView: UICollectionView, section: Int) -> Int {
        return topProdutsData.count
    }
    func featuredProductsDidSelectItemAt(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("OK")
    }
}


// MARK: - Extension MDCBottomAppBarView
extension SoldProductListController {
    func configureAppBarView() {
        bottomBarView = MDCBottomAppBarView()
        
        bottomBarView.barTintColor = .mainColor1
        bottomBarView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        
        
        view.addSubview(bottomBarView)
//        let size = bottomBarView.sizeThatFits(view.bounds.size)
//        let bottomBarViewFrame = CGRect(x: 0, y: view.bounds.size.height - size.height - self.bottomBarOffset() , width: size.width, height: size.height + self.bottomBarOffset())
        let bottomBarViewFrame = CGRect(x: 0, y: view.bounds.size.height - bottomAppBarHeight - self.bottomBarOffset() , width: view.bounds.width, height: bottomAppBarHeight + self.bottomBarOffset())
        bottomBarView.frame = bottomBarViewFrame
        
        
        bottomBarView.floatingButton.backgroundColor = .mainColor1
        bottomBarView.floatingButton.tintColor = .selectedBarButtonColor
        bottomBarView.floatingButton.setImage(UIImage(named: "icon_Add")?.withRenderingMode(.alwaysTemplate), for: .normal)
        bottomBarView.floatingButton.accessibilityLabel = "Add"
        bottomBarView.floatingButtonPosition = .center
        bottomBarView.floatingButton.addTarget(self, action: #selector(openPostViewController), for: .touchUpInside)
        
//        let btnWidth = (bottomBarView.frame.width - bottomBarView.floatingButton.frame.width - 4) / 4
        
//        let btnHome = UIBarButtonItem(
//            image: UIImage(named: "icon_Home")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(appBarButtonTapped)
//        )
//        btnHome.tintColor = .selectedBarButtonColor
//
//        bottomBarView.leadingBarButtonItems = [btnHome]
        
        let btnSearch = UIBarButtonItem(
            image: UIImage(named: "icon_Search")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(searchButtonTapped)
        )
        btnSearch.tintColor = .selectedBarButtonColor
        btnSearch.accessibilityLabel = "btnSearch"
        
        bottomBarView.trailingBarButtonItems = [btnSearch]
        
//        bottomBarView.addSubview(searchTextField)
    }
    
    @objc func openPostViewController(sender: UIButton) {
        self.performSegue(withIdentifier: "NewPostSegue", sender: nil)
    }
    
    @objc func searchButtonTapped(sender: UIBarButtonItem) {
        if sender.accessibilityLabel == "btnSearch" {
            sender.accessibilityLabel = "btnSearchCancel"
            bottomBarView.setFloatingButtonPosition(.leading, animated: true)
            sender.image = UIImage(named: "icon_Close")?.withRenderingMode(.alwaysTemplate)
        } else {
            sender.accessibilityLabel = "btnSearch"
            bottomBarView.setFloatingButtonPosition(.center, animated: true)
            sender.image = UIImage(named: "icon_Search")?.withRenderingMode(.alwaysTemplate)
        }
    }
}
