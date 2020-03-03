//
//  AutoHeightCollectionViewCell.swift
//  GIFT_APP
//
//  Created by Alguz on 12/5/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

class AutoHeightCollectionViewCell: BaseCell {
    
    @IBOutlet weak var maxWidthConstraint: NSLayoutConstraint!
    
    var viewController: UIViewController?
    
    var maxWidth: CGFloat? = nil {
        didSet {
            guard let maxWidth = maxWidth else {
                return
            }
            maxWidthConstraint.constant = maxWidth
        }
    }
    
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
