//
//  ProductCell.swift
//  gift_app
//
//  Created by Lexy on 8/31/19.
//  Copyright © 2019 Lexy. All rights reserved.
//

import UIKit

class SoldProductCell: BaseCell {
    
    let endPoint = "\(Setting.serverURL)/assets/img/category/"
    
    var soldProduct: SoldProduct? {
        didSet {
            loadImages()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        shadow(left: 8.0, top: 8.0, feather: 15, color: .black, opacity: 0.1)
        
    }
    
    func loadImages() {
    }
    
}
