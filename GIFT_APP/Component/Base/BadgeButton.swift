//
//  BadgeButton.swift
//  GIFT_APP
//
//  Created by Alguz on 1/22/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable class BadgeButton: UIButton {
    var lbl_badge: UILabel!
    
    func setupViews() {
        lbl_badge = UILabel(frame: CGRect(x: 20, y: 0, width: 15, height: 15))
        lbl_badge.text = badgeText
        lbl_badge.backgroundColor = badgeBg
        lbl_badge.clipsToBounds = true
        lbl_badge.layer.cornerRadius = 7
        lbl_badge.textColor = badgeColor
        lbl_badge.font = lbl_badge.font.withSize(9)
        lbl_badge.textAlignment = .center
        lbl_badge.isHidden = true
        
        
        self.addSubview(lbl_badge)
    }
    
    @IBInspectable var badgeColor: UIColor = .red {
        didSet {
            lbl_badge.textColor = self.badgeColor
        }
    }
    
    @IBInspectable var badgeBg: UIColor = .systemGreen {
        didSet {
            lbl_badge.textColor = badgeBg
        }
    }
    
    @IBInspectable var badgeText: String = "" {
        didSet {
            lbl_badge.isHidden = badgeText == ""
            lbl_badge.text = badgeText
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
}
