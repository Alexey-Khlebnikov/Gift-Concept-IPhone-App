//
//  SellerPostDetailViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 12/6/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit
import HCSStarRatingView
import MaterialComponents.MDCFloatingButton

class SellerPostDetailViewController: BaseViewController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    
    var postData: Post?

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Post Data
    @IBOutlet weak var lbl_postName: UILabel!
    @IBOutlet weak var lbl_postDetail: UILabel!
    @IBOutlet weak var lbl_postPrice: UILabel!
    
    
    // MARK: - Bid Data
    @IBOutlet weak var btn_selectProduct: MDCFloatingButton!
    @IBOutlet weak var v_productContainer: MyBaseView!
    @IBOutlet weak var iv_product: URLImageView!
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var lbl_soldCount: UILabel!
    @IBOutlet weak var star_productRate: HCSStarRatingView!
    @IBOutlet weak var lbl_productRate: BaseLabel!
    @IBOutlet weak var lbl_productPrice: UILabel!
    @IBOutlet weak var txt_bidPrice: BaseTextField!
    @IBOutlet weak var btn_bidNow: MDCFloatingButton!
    
    var selectedProduct: Product? {
        didSet {
            if let product = selectedProduct {
                iv_product.fromURL(urlString: product.url)
                lbl_productName.text = product.name
                lbl_productRate.text = product.rate.toString(toFixed: 1)
                star_productRate.value = CGFloat(product.rate)
                lbl_soldCount.text = "\(product.soldCount)+ Sold"
                lbl_productPrice.text = product.fullPrice
                txt_bidPrice.isEnabled = true
                btn_bidNow.isEnabled = true
                
                btn_selectProduct.alpha = 0
                v_productContainer.alpha = 1
                
                
            } else {
                txt_bidPrice.isEnabled = false
                btn_bidNow.isEnabled = false
                btn_selectProduct.alpha = 1
                v_productContainer.alpha = 0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootScrollView = tableView as UIScrollView
        
        setupPostData()
    }
    
    func setupPostData() {
        if let post = postData {
            txt_bidPrice.text = Float((post.minPrice + post.maxPrice) / 2).toString(toFixed: 0)
            lbl_postName.text = post.name
            lbl_postDetail.text = post.content
            lbl_postPrice.text = post.rangePrice()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectProductToBidSegue" {
            let vc = segue.destination as! SellerProductListViewController
            vc.categoryId = postData?.categoryId
            vc.parentController = self
        }
    }
    
    @IBAction func CloseController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionUnselectProduct(_ sender: Any) {
        selectedProduct = nil
    }
    @IBAction func actionBidNow(_ sender: Any) {
        if let product = selectedProduct, let post = postData, let bidPrice = txt_bidPrice.text {
            let bidData = BidData()
            bidData.productId = product.id
            bidData.postId = post.id
            bidData.bidPrice = Float(bidPrice)!
            bidData.create { (response) in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension SellerPostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if postData?.attaches.count == 0 {
            return 1
        } else {
            return postData?.attaches.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if postData?.attaches.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoneAttachedImageCell", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttacheTableViewCell", for: indexPath) as! AttacheTableViewCell
            cell.imageInfo = postData!.attaches[indexPath.item]
            return cell
        }
    }
}


class AttacheTableViewCell: UITableViewCell {
    var imageInfo: ImageInfo? {
        didSet {
            if let url = self.imageInfo?.url {
                print(url)
                attachImage.fromURL(urlString: url)
            }
            attachName.text = self.imageInfo?.name
            attachTimeAgo.text = Date().elapsedTime
        }
    }
    
    @IBOutlet weak var attachImage: URLImageView!
    @IBOutlet weak var attachName: UILabel!
    @IBOutlet weak var attachTimeAgo: UILabel!
    
}
