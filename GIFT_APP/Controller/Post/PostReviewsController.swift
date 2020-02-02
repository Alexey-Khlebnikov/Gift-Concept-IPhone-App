//
//  PostReviewsController.swift
//  GIFT_APP
//
//  Created by Alguz on 11/18/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit
import HCSStarRatingView

class PostReviewsController: UIViewController {
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    @IBOutlet weak var clv_reviews: UICollectionView!
    
    var post: Post!
    var reviews: [BidData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    private func loadData() {
        BidData.getCompletedListByPostId(postId: self.post.id) { (reviews) in
            self.reviews = reviews
            self.clv_reviews.reloadData()
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

extension PostReviewsController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostReviewsCell", for: indexPath) as! PostReviewsCell
        cell.bidData = reviews[indexPath.item]
        cell.maxWidth = collectionView.bounds.width - 40
        return cell
    }

}

class PostReviewsCell: UICollectionViewCell {
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var lbl_review: UILabel!
    @IBOutlet weak var container: MyBaseView!
    @IBOutlet weak var iv_product: ProductImageView!
    @IBOutlet weak var star_rating: HCSStarRatingView!
    @IBOutlet weak var lbl_rate: BaseLabel!
    @IBOutlet weak var cnt_writeReviewWrapperHeight: NSLayoutConstraint!
    @IBOutlet weak var v_writeReviewWrapper: UIView!
    @IBOutlet weak var cnt_width: NSLayoutConstraint! {
        didSet {
            cnt_width.isActive = false
        }
    }
    var maxWidth: CGFloat? = nil {
        didSet {
            guard let maxWidth = maxWidth else {
                return
            }
            if cnt_width == nil {
                cnt_width = container.widthAnchor.constraint(equalToConstant: 0)
            }
            cnt_width.constant = maxWidth
            cnt_width.isActive = true
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if cnt_width == nil {
            print("cnt_width == nil")
        }
    }
    
    var bidData: BidData? {
        didSet {
            if bidData != nil {
                if let product = bidData?.product {
                    lbl_productName.text = product.name
                    iv_product.fromURL(urlString: product.imageURL)
                    if product.reviews.count > 0 {
                        let review = product.reviews[0]
                        lbl_rate.text = String(review.rate)
                        star_rating.value = CGFloat(review.rate)
                        lbl_review.text = product.detail
                        v_writeReviewWrapper.clipsToBounds = true
                        cnt_writeReviewWrapperHeight.constant = 0
                    } else {
                        lbl_rate.text = "-.-"
                        star_rating.value = 0.0
                        lbl_review.text = "Please give a review for this product"
                        cnt_writeReviewWrapperHeight.constant = 50
                        v_writeReviewWrapper.clipsToBounds = false
                    }
                }
            }
        }
    }
}
