//
//  ProductDetailViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 11/2/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit
import MaterialComponents
import HCSStarRatingView
import SwiftMessages

class ProductDetailViewController: UIViewController {


    @IBOutlet weak var iv_favorite: UIImageView!
    @IBOutlet weak var slv_product_image: UIScrollView!
    @IBOutlet weak var star_rate: HCSStarRatingView!
    @IBOutlet weak var lbl_rate: UILabel!
    @IBOutlet weak var lbl_product_name: UILabel!
    @IBOutlet weak var lbl_seller: UILabel!
    @IBOutlet weak var lbl_product_detail: UILabel!
    @IBOutlet weak var lbl_sold_price: UILabel!
    @IBOutlet weak var clv_reviews: UICollectionView!
    @IBOutlet weak var cnt_reviews_height: NSLayoutConstraint!
    @IBOutlet weak var cnt_description_height: NSLayoutConstraint!
    
    let pageControl = MDCPageControl()
    let review_item_height: CGFloat = 150
    
    private var product: Product? {
        didSet {
            self.refresh()
            self.setupPageControl()
            
            self.cnt_reviews_height.constant = self.review_item_height * CGFloat(product?.reviews.count ?? 0) + 10
            self.cnt_description_height.constant = 0
            
            self.clv_reviews.reloadData()
        }
    }
    
    var product_id: String? {
        didSet {
            if product_id != nil && product_id != "" {
                Product.get(productId: product_id!) { (product) in
                    self.product = product
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iv_favorite.setImageRenderingMode(.alwaysTemplate)
        
        setupTopWrapper()
    }
    
    @IBAction func showInvitationDialog(_ sender: Any) {
        let view: InviationView = try! SwiftMessages.viewFromNib()
        view.configureDropShadow()
        view.sendInvite = { _ in SwiftMessages.hide() }
        view.cancelAction = { SwiftMessages.hide() }
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .viewController(self)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .gray(interactive: true)
        SwiftMessages.show(config: config, view: view)
    }
    
    func testSwiftMessage() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Favorite")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        let messageView = BaseView(frame: .zero)
        messageView.layoutMargins = .zero
        do {
            let backgroundView = CornerRoundingView()
            backgroundView.cornerRadius = 15
            backgroundView.layer.masksToBounds = true
            messageView.installBackgroundView(backgroundView)
            messageView.installContentView(imageView)
            messageView.layoutMarginAdditions = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            messageView.backgroundHeight = 120.0
        }
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .viewController(self)
        SwiftMessages.show(config: config, view: messageView)
    }
    
    /// This method set up Page control
    func setupPageControl() {
        pageControl.numberOfPages = product?.imageIds.count ?? 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        let pageControlSize = pageControl.sizeThatFits(view.bounds.size)
        pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pageControl.topAnchor.constraint(equalTo: slv_product_image.topAnchor, constant: view.frame.width - pageControlSize.height).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: pageControlSize.height).isActive = true
                
        pageControl.addTarget(self, action: #selector(didChangePage), for: .valueChanged)
        pageControl.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
    }
    
    
    @objc func didChangePage(sender: MDCPageControl) {
        var offset = slv_product_image.contentOffset
        offset.x = CGFloat(sender.currentPage) * slv_product_image.bounds.size.width;
        slv_product_image.setContentOffset(offset, animated: true)
    }
    
    
    func refresh() {
        setupImageSlider()
    }
    func setupImageSlider() {
        for subview in slv_product_image.subviews {
            subview.removeFromSuperview()
        }
        var i = 0
        var previousView: UIView = slv_product_image
        for imageURL in product?.imageIds ?? [] {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            slv_product_image.addSubview(view)
            slv_product_image.addConstraintsWithFormat(format: "V:|[v0]|", views: view)
            view.heightAnchor.constraint(equalTo: slv_product_image.heightAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: slv_product_image.widthAnchor).isActive = true
            if i == 0 {
                view.leadingAnchor.constraint(equalTo: previousView.leadingAnchor).isActive = true
            } else {
                view.leadingAnchor.constraint(equalTo: previousView.trailingAnchor).isActive = true
            }
            let piv = ProductImageView()
            piv.fromURL(urlString: product!.getProductImageURL(imageId: imageURL))
            piv.contentMode = .scaleAspectFill
            piv.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(piv)
            view.addConstraintsWithFormat(format: "H:|[v0]|", views: piv)
            view.addConstraintsWithFormat(format: "V:|[v0]|", views: piv)
            
            previousView = view
            i += 1
        }
        if i > 0 {
            slv_product_image.trailingAnchor.constraint(equalTo: previousView.trailingAnchor).isActive = true
        }
    }
}

// MARK: - extension CollectionView
extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.reviews.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! ReviewsCell
        cell.data = product?.reviews[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: review_item_height)
    }
    
}

// MARK: - extension ScrollView
extension ProductDetailViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.scrollViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.scrollViewDidEndScrollingAnimation(scrollView)
    }
}
