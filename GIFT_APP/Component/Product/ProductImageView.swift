//
//  ProductImageView.swift
//  GIFT_APP
//
//  Created by Alguz on 11/3/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//
import UIKit
class ProductImageView: URLImageView {
    override func fromURL(urlString: String) {
        super.fromURL(urlString: urlString)
    }
}


class ProductThumbImageView: MyBaseView {
    
    let borderView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 10
        view.layer.borderColor = UIColor.mainColor1.cgColor
        view.shadow(left: 0, top: 6, feather: 12, color: .black, opacity: 0.15)
        return view
    }()
    
    let avatar: URLImageView = {
        let imageView = URLImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(avatar)
        addSubview(borderView)
    }
    
    func fromURL(urlString: String) {
        avatar.fromURL(urlString: urlString)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let borderWidth = CGFloat(self.borderWidth)

        avatar.frame = CGRect(x: borderWidth, y: borderWidth, width: self.bounds.width - borderWidth * 2, height: self.bounds.height - borderWidth * 2)
        
        avatar.layer.cornerRadius = CGFloat(self.cornerRadius) - borderWidth
        avatar.layer.maskedCorners = self.layer.maskedCorners
    }
}


