//
//  TopSellersView.swift
//  gift_app
//
//  Created by Lexy on 10/1/19.
//  Copyright © 2019 Lexy. All rights reserved.
//
import UIKit


class TopSellerCell : BaseCell {
    var seller: Seller? {
        didSet {
            nameLabel.text = seller?.displayName
            loadAvatarImage()
        }
    }
    
    let nameLabel: UILabel = {
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        return nl
    }()
    
    let avatarView: URLImageView = {
        let av = URLImageView()
        av.translatesAutoresizingMaskIntoConstraints = false
        av.contentMode = .scaleAspectFit
        return av
    }()
    
    
    override func setupViews() {
        super.setupViews()
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = .mainBgColor
        addSubview(avatarView)
        addSubview(nameLabel)
        
        addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: avatarView)
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat(format: "V:|-15-[v0]-10-[v1(20)]-10-|", views: avatarView, nameLabel)
    }
    
    func loadAvatarImage() {
        let endPoint = "\(Setting.serverURL)/assets/img/sellers/"
        if let imageURL = seller?.photoURL {
            self.avatarView.fromURL(urlString: endPoint + imageURL)
        }
    }
}
