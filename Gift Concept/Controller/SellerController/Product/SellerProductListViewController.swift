//
//  SellerProductListViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 12/9/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit
import HCSStarRatingView

class SellerProductListViewController: BaseViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            self.flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    var parentController: SellerPostDetailViewController!
    
    var categoryId: String?
    var products: [Product] = []
    
    @IBAction func actionClose(_ sender: Any) {
        parentController.selectedProduct = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionSelect(_ sender: Any) {
        parentController.selectedProduct = selectedProduct
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProducts()
    }
    
    func loadProducts() {
        if let categoryId = categoryId {
            Product.getMyProduct(categoryId: categoryId) { (products) in
                self.products = products
                self.collectionView.reloadData()
            }
        }
    }
    
    var selectedProduct: Product?

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SellerProductListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellerProductListViewItemCell", for: indexPath) as! SellerProductListViewItemCell
        let tmp = flowLayout.sectionInset
        cell.maxWidth = collectionView.frame.width - tmp.left - tmp.right
        cell.product = products[indexPath.item]
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProduct = products[indexPath.item]
    }
    
}


class SellerProductListViewItemCell: AutoHeightCollectionViewCell {
    var product: Product? {
        didSet {
            if let product = product {
                iv_product.fromURL(urlString: product.url)
                lbl_productName.text = product.name
                lbl_productPrice.text = product.fullPrice
                star_rate.value = CGFloat(product.rate)
                if product.rate == 0 {
                    lbl_rate.text = "-.-"
                } else {
                    lbl_rate.text = product.rate.toString(toFixed: 1)
                }
            }
        }
    }
    @IBOutlet weak var iv_product: URLImageView!
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var lbl_productPrice: UILabel!
    @IBOutlet weak var star_rate: HCSStarRatingView!
    @IBOutlet weak var lbl_rate: BaseLabel!
}
