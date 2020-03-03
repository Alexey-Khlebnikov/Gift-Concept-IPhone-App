//
//  RatingView.swift
//  GIFT_APP
//
//  Created by Alguz on 1/13/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import Foundation
import HCSStarRatingView

@IBDesignable class RatingView: MyBaseView {
    @IBInspectable var value: CGFloat = 0 {
        didSet {
            if self.value == 0 {
                markView.text = "-.-"
            } else {
                markView.text = self.value.toString(toFixed: 1)
            }
            starView.value = self.value
        }
    }
    @IBInspectable var fontSize: CGFloat = 14 {
        didSet {
            markView.font = markView.font.withSize(self.fontSize)
        }
    }
    
    @IBInspectable var showMark: Bool = true {
        didSet {
            if self.showMark {
                self.cnt_markView.constant = 30
            } else {
                self.cnt_markView.constant = 0
            }
        }
    }
    
    @IBInspectable var editable: Bool = true {
        didSet {
            self.starView.isUserInteractionEnabled = self.editable
        }
    }
    
    let starView: HCSStarRatingView = {
        let starView = HCSStarRatingView()
        starView.spacing = 0
        starView.backgroundColor = .clear
        starView.starBorderColor = .clear
        starView.minimumValue = 0
        starView.maximumValue = 5
        starView.continuous = true
        starView.allowsHalfStars = true
        starView.accurateHalfStars = true
        starView.emptyStarColor = UIColor(rgb: 0xCACACA)
        starView.tintColor = .systemOrange
        
        starView.translatesAutoresizingMaskIntoConstraints = false
        return starView
    }()
    
    lazy var markView: BaseLabel = {
        let view = BaseLabel()
        view.textAlignment = .center
        view.cornerRadius = 5
        view.backgroundColor = .systemOrange
        view.textColor = .white
        view.font = view.font.withSize(14)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var cnt_markView: NSLayoutConstraint!
    
    override func setupViews() {
        super.setupViews()
        
        self.value = 5
        self.backgroundColor = .clear
        addSubview(starView)
        addSubview(markView)
        starView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        starView.trailingAnchor.constraint(equalTo: markView.leadingAnchor).isActive = true
        self.cnt_markView = markView.widthAnchor.constraint(equalToConstant: 28)
        self.cnt_markView.isActive = true
        markView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        addConstraintsWithFormat(format: "V:|[v0]|", views: starView)
        markView.centerYAnchor.constraint(equalTo: starView.centerYAnchor).isActive = true
        markView.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor).isActive = true
    }
}
