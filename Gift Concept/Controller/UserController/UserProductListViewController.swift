//
//  UserProductListViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 1/16/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import UIKit
import HCSStarRatingView
import MaterialComponents.MaterialBottomAppBar

class UserProductListViewController: BaseViewController {
    @IBOutlet weak var clv_topSellers: BaseCollectionView!
    @IBOutlet weak var clv_featuredProducts: BaseCollectionView!
    @IBOutlet weak var clv_latestProducts: BaseCollectionView!
    @IBOutlet weak var flowLayout_topSellers: UICollectionViewFlowLayout! {
        didSet {
            self.flowLayout_topSellers.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    @IBOutlet weak var flowLayout_featuredProducts: UICollectionViewFlowLayout! {
       didSet {
           self.flowLayout_featuredProducts.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
       }
   }

    @IBOutlet weak var flowLayout_latestProducts: UICollectionViewFlowLayout! {
       didSet {
           self.flowLayout_latestProducts.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
       }
   }
    @IBOutlet weak var cnt_latestCollectionViewHeight: NSLayoutConstraint!
    
    let bottomAppBarHeight: CGFloat = 86
    var bottomBarView: MDCBottomAppBarView!
    
    var categoryId: String!
    
    var topSellers: [Seller] = []
    var featuredProducts: [Product] = []
    var latestProducts: [Product] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureAppBarView()
        setupTopWrapper()
    }
    
    
    func loadData() {
        ApiService.sharedService.fetchBestSellers { (bestSellers: [Seller]) in
            self.topSellers = bestSellers
            self.clv_topSellers.reloadData()
        }
        ApiService.sharedService.fetchTopProducts(categoryId: categoryId) { (topProducts: [Product]) in
            self.featuredProducts = topProducts
            self.clv_featuredProducts.reloadData()
        }
        ApiService.sharedService.fetchLatestProducts { (products: [Product]) in
            self.latestProducts = products
            self.clv_latestProducts.reloadData()
            self.clv_latestProducts.layoutIfNeeded()
            self.cnt_latestCollectionViewHeight.constant = self.clv_latestProducts.collectionViewLayout.collectionViewContentSize.height
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductListToDetail" {
            let _sender = sender as? (product_name: String, product_id: String)
            let viewController = segue.destination as? ProductDetailViewController
            viewController?.title = "Product Detail"
            viewController?.product_id = _sender?.product_id
        } else if segue.identifier == "ProductListToNewPost" {
            let viewController = segue.destination as? NewPostController
            viewController?.rootViewController = self
            viewController?.categoryId = categoryId
        }
    }
    
    func configureAppBarView() {
            bottomBarView = MDCBottomAppBarView()
            
            bottomBarView.barTintColor = .mainColor1
            bottomBarView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            
            
            view.addSubview(bottomBarView)
            print(self.bottomBarOffset())
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
            self.performSegue(withIdentifier: "ProductListToNewPost", sender: nil)
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


extension UserProductListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.clv_topSellers {
            return topSellers.count
        } else if collectionView == self.clv_featuredProducts {
            return featuredProducts.count
        } else {
           return latestProducts.count
       }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let contentInset = flowLayout_topSellers.sectionInset
        if collectionView == self.clv_topSellers {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topSellerCell", for: indexPath) as! U_TopSellerCell
            cell.seller = topSellers[indexPath.item]
            cell.maxWidth = collectionView.frame.height - contentInset.top - contentInset.bottom
            return cell
        } else  if collectionView == self.clv_featuredProducts {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featuredProductCell", for: indexPath) as! U_FeaturedProductCell
            cell.product = featuredProducts[indexPath.item]
           return cell
       } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestProductCell", for: indexPath) as! U_LatestProductCell
            cell.product = latestProducts[indexPath.item]
            let contentInset = flowLayout_latestProducts.sectionInset
            
            cell.maxWidth = (collectionView.frame.width - contentInset.left - contentInset.right - flowLayout_latestProducts.minimumInteritemSpacing) / 2
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.clv_latestProducts {
            let data = latestProducts[indexPath.item]
            self.performSegue(withIdentifier: "ProductListToDetail", sender: (data.name, data.id))
        } else if collectionView == self.clv_featuredProducts {
            let data = featuredProducts[indexPath.item]
            self.performSegue(withIdentifier: "ProductListToDetail", sender: (data.name, data.id))
        }
    }
}


class U_TopSellerCell: AutoHeightCollectionViewCell {
    var seller: Seller! {
        didSet {
            iv_product.fromURL(urlString: seller.url)
            lbl_sellerName.text = seller.username
            lbl_monthlyEarning.text = "$3M+ / month"
        }
    }
    
    @IBOutlet weak var iv_product: URLImageView!
    @IBOutlet weak var lbl_sellerName: UILabel!
    @IBOutlet weak var lbl_monthlyEarning: UILabel!
    
}

class U_FeaturedProductCell: AutoHeightCollectionViewCell {
    var product: Product! {
        didSet {
            iv_product.fromURL(urlString: product.url)
            lbl_productName.text = product.name
            lbl_sellerName.text = product.seller?.username
            star_rate.value = CGFloat(product.rate)
            lbl_productPrice.text = product.fullPrice
        }
    }
    @IBOutlet weak var iv_product: URLImageView!
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var lbl_sellerName: UILabel!
    @IBOutlet weak var star_rate: HCSStarRatingView!
    @IBOutlet weak var lbl_productPrice: UILabel!
    
}

class U_LatestProductCell: AutoHeightCollectionViewCell {
    var product: Product! {
        didSet {
            iv_product.fromURL(urlString: product.url)
            lbl_productName.text = product.name
            lbl_sellerName.text = product.seller?.username
            star_rate.value = CGFloat(product.rate)
            lbl_productPrice.text = product.fullPrice
        }
    }
    @IBOutlet weak var iv_product: URLImageView!
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var lbl_sellerName: UILabel!
    @IBOutlet weak var star_rate: HCSStarRatingView!
    @IBOutlet weak var lbl_productPrice: UILabel!
}
