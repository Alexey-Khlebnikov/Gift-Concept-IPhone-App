//
//  UserCartViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 1/23/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import UIKit

class UserCartViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cnt_collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var lbl_productPrice: UILabel!
    @IBOutlet weak var lbl_deliveryPrice: UILabel!
    @IBOutlet weak var lbl_totalPrice: UILabel!
    @IBOutlet weak var txt_bonus: BaseTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var totalProductPrice: Float = 0
    var totalDeliveryPrice: Float = 0
    var totalPrice: Float = 0
    
    override func viewDidLoad() {
        self.rootScrollView = scrollView
        super.viewDidLoad()
        self.collectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context: nil)
        lbl_totalPrice.text = String.currencyFormat(price: StoreCart.shared.totalPrice, unit: StoreCart.shared.myPriceUnit.symbol, decimal: 2)
        lbl_productPrice.text = String.currencyFormat(price: StoreCart.shared.totalProductPrice, unit: StoreCart.shared.myPriceUnit.symbol, decimal: 2)
        lbl_deliveryPrice.text = String.currencyFormat(price: StoreCart.shared.totalDeliveryPrice, unit: StoreCart.shared.myPriceUnit.symbol, decimal: 2)
    }
    @IBAction func action_GotoPayment(_ sender: Any) {
        StoreCart.shared.userOrderViewController?.currentPage = 1
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

extension UserCartViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StoreCart.shared.cart.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCartCell", for: indexPath) as! UserCartCell
        cell.bid = StoreCart.shared.cart[indexPath.item]
        return cell
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let observedObject = object as? UICollectionView, observedObject == self.collectionView {
            self.cnt_collectionViewHeight.constant = flowLayout.collectionViewContentSize.height
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = flowLayout.sectionInset
        let width = collectionView.frame.width - sectionInset.left - sectionInset.right
        let height: CGFloat = 120
        
        return CGSize(width: width, height: height)
    }
    
}


class UserCartCell: AutoHeightCollectionViewCell {
    var bid: BidData? {
        didSet {
            if let bid = bid, let product = bid.product {
                iv_product.fromURL(urlString: product.url)
                lbl_productName.text = product.name
                lbl_bidPrice.text = bid.fullPrice
            }
        }
    }
    @IBOutlet weak var iv_product: URLImageView!
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var lbl_bidPrice: UILabel!
}
