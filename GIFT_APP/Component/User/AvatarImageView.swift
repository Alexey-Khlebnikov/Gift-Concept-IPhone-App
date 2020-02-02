//
//  AvatarImageView.swift
//  GIFT_APP
//
//  Created by Alguz on 11/1/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//
import UIKit

//class AvatarImageView: URLImageView {
//    let endPoint: String = Setting.serverURL + "/assets/img/avatar/"
//    override func fromURL(urlString: String) {
//        super.fromURL(urlString: endPoint + urlString)
//    }
//}
class AvatarImageView: MyBaseView {
    let endPoint: String = Setting.serverURL + "/assets/img/avatar/"
    
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
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(avatar)
        addSubview(borderView)
    }
    
    func fromURL(urlString: String) {
        avatar.fromURL(urlString: endPoint + urlString)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let borderWidth = self.bounds.width / 15
        borderView.layer.borderWidth = borderWidth
        borderView.frame = self.bounds
        avatar.frame = CGRect(x: borderWidth, y: borderWidth, width: self.bounds.width - borderWidth * 2, height: self.bounds.height - borderWidth * 2)
        
        borderView.layer.cornerRadius = self.bounds.width / 2
        avatar.layer.cornerRadius = borderView.layer.cornerRadius - borderWidth
    }
}
