//
//  TopProductsView.swift
//  gift_app
//
//  Created by Lexy on 10/2/19.
//  Copyright © 2019 Lexy. All rights reserved.
//
import UIKit
private let i_TopProductCell = "topProductCell"

//class TopProductsView: CustomCollectionView {
//    override func setupViews() {
//        super.setupViews()
//        self.direction = .horizontal
//        self.cellSize = defaultCellSize(index:)
//        loadTopProducts()
//    }
//
//    func defaultCellSize(index: Int) -> (groupCount: Int, itemSize: CGFloat) {
//        return (1, 150)
//    }
//
////    override func registerClass() {
////        register(TopProductCell.self, forCellWithReuseIdentifier: i_TopProductCell)
////    }
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: i_TopProductCell, for: indexPath) as! TopProductCell
//        cell.product = self.data[indexPath.item] as? Product
//        return cell
//    }
//
//    func loadTopProducts() {
//        ApiService.sharedService.fetchTopProducts { (topProducts: [Product]) in
//            self.data = topProducts
//            self.collectionView.reloadData()
//        }
//    }
//
//}

class TopProductCell: BaseCell {
    
    var product: Product? {
        didSet {
            nameLabel.text = product?.name
            if let product = self.product {
                self.avatarView.fromURL(urlString: product.url)
            }
        }
    }
    
    let nameLabel: UILabel = {
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        return nl
    }()
    
    let soldLabel: UILabel = {
        let sl = UILabel()
        sl.text = "300 sold"
        sl.font = sl.font.withSize(14)
        sl.textColor = .gray
        sl.translatesAutoresizingMaskIntoConstraints = false
        return sl
    }()
    
    let avatarView: URLImageView = { 
        let av = URLImageView()
        av.clipsToBounds = true
        av.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        av.translatesAutoresizingMaskIntoConstraints = false
        av.contentMode = .scaleAspectFill
        return av
    }()
    
    let priceLabel: UILabel = {
        let pl = UILabel()
        pl.translatesAutoresizingMaskIntoConstraints = false
        pl.text = "599$"
        return pl
    }()
    
    
    override func setupViews() {
        super.setupViews()
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = .mainBgColor
        addSubview(avatarView)
        addSubview(nameLabel)
        addSubview(soldLabel)
        addSubview(priceLabel)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: avatarView)
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: soldLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: priceLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10))
        
        addConstraintsWithFormat(format: "V:|[v0]-12-[v1(15)]-3-[v2(13)]-12-|", views: avatarView, nameLabel, soldLabel)
        addConstraintsWithFormat(format: "V:[v0(13)]-10-|", views: priceLabel)
        
    }
}
