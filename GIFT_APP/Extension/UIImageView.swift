//
//  UIImageView.swift
//  GIFT_APP
//
//  Created by Alguz on 11/8/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation
extension UIImageView {
    func setImageRenderingMode(_ renderMode: UIImage.RenderingMode) {
        assert(image != nil, "Image must be set before setting rendering mode")
        // AlwaysOriginal as an example
        image = image?.withRenderingMode(renderMode)
    }
}
