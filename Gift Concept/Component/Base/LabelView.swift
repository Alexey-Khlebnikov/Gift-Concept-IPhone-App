//
//  LabelView.swift
//  GIFT_APP
//
//  Created by Alguz on 11/1/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit
class LabelView: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        numberOfLines = 0
        lineBreakMode = NSLineBreakMode.byWordWrapping
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
