//
//  SellerProductsViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 1/13/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import UIKit

class SellerProductsViewController: BaseViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            self.flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        ApiService.sharedService.find(url: "/product/allMyProducts") { (dictionaries) in
            self.products = dictionaries.map({return Product($0)})
            print(self.products)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
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

extension SellerProductsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellerProductCell", for: indexPath) as! SellerProductCell
        cell.product = self.products[indexPath.item]
        let inset = flowLayout.sectionInset
        cell.maxWidth = (collectionView.frame.width - inset.left - inset.right - flowLayout.minimumInteritemSpacing - CGFloat(2)) / 2
        return cell
    }
}


class SellerProductCell: AutoHeightCollectionViewCell {
    
    @IBOutlet weak var iv_productImage: URLImageView!
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var lbl_productPrice: UILabel!
    @IBOutlet weak var star_rating: RatingView!
    @IBOutlet weak var iv_heart: UIImageView!
    
    var product: Product? {
        didSet {
            if let product = self.product {
                star_rating.value = CGFloat(product.rate)
                lbl_productName.text = product.name
                lbl_productPrice.text = product.fullPrice
                iv_productImage.fromURL(urlString: product.url)
            }
        }
    }
    
}
