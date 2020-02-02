//
//  LatestProductsView.swift
//  gift_app
//
//  Created by Lexy on 10/2/19.
//  Copyright © 2019 Lexy. All rights reserved.
//

import UIKit

import HCSStarRatingView
class ProductCell: BaseCell {
    var product: Product? {
        didSet {
            ui_name.text = product?.name
            if let product = self.product {
                ui_seller.text = "Seller: " + (product.seller?.displayName ?? "")
                ui_rating.value = CGFloat(product.rate)
                ui_price.text = (product.priceUnit.symbol) + String(product.price)
                self.ui_product_image.fromURL(urlString: product.url)
            }
        }
    }
    let ui_bgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    let ui_product_image: URLImageView = {
        let iv = URLImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    let ui_name: UILabel = {
        let ul = UILabel()
        ul.font = ul.font.withSize(14)
        ul.translatesAutoresizingMaskIntoConstraints = false
        return ul
    }()
    let ui_seller: UILabel = {
        let ul = UILabel()
        ul.font = ul.font.withSize(13)
        ul.textColor = .gray
        ul.translatesAutoresizingMaskIntoConstraints = false
        return ul
    }()

    let ui_rating: HCSStarRatingView = {
        let uv = HCSStarRatingView()
        uv.translatesAutoresizingMaskIntoConstraints = false
        uv.maximumValue = 5
        uv.minimumValue = 0
        uv.endEditing(true)
        uv.allowsHalfStars = true
        uv.accurateHalfStars = true
        uv.tintColor = UIColor(red: 250, green: 201, blue: 23)
        return uv
    }()
    let ui_price: UILabel = {
        let ul = UILabel()
        ul.textAlignment = .right
        ul.translatesAutoresizingMaskIntoConstraints = false
        return ul
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(ui_bgView)
        addSubview(ui_product_image)
        addSubview(ui_name)
        addSubview(ui_seller)
        addSubview(ui_rating)
        addSubview(ui_price)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: ui_bgView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: ui_bgView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: ui_product_image)
        addConstraintsWithFormat(format: "H:|-5-[v0]-5-|", views: ui_name)
        addConstraintsWithFormat(format: "H:|-5-[v0]-5-|", views: ui_seller)
        ui_rating.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        ui_price.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        addConstraintsWithFormat(format: "H:|-5-[v0]-[v1]-5-|", views: ui_rating, ui_price)

        addConstraintsWithFormat(format: "V:|[v0]-5-[v1(18)]-0-[v2(15)]-0-[v3(18)]-5-|", views: ui_product_image, ui_name, ui_seller, ui_rating)
        addConstraint(NSLayoutConstraint(item: ui_price, attribute: .centerY, relatedBy: .equal, toItem: ui_rating, attribute: .centerY, multiplier: 1, constant: 0))

    }
    
}


