//
//  UIImage.swift
//  GIFT_APP
//
//  Created by Alguz on 11/29/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    var dimension: String {
        get {
            self.size.width.toString(toFixed: 0) + " X " + self.size.height.toString(toFixed: 0)
        }
    }
}
