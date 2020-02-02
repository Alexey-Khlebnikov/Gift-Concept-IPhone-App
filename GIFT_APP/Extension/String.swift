//
//  String.swift
//  GIFT_APP
//
//  Created by Alguz on 11/16/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation
extension String {
    static func currencyFormat(price: Float, unit: String?, decimal: Int) -> String {
        let _unit = unit ?? "$"
        switch unit {
        case "$":
            return _unit + price.toString(toFixed: decimal)
        default:
            return _unit + price.toString(toFixed: decimal)
        }
    }
    static func rangePrice(min: Float, max: Float, unit: String, decimal: Int) -> String {
        return currencyFormat(price: min, unit: unit, decimal: decimal) + "~" + currencyFormat(price: max, unit: unit, decimal: decimal)
    }
    
    func pathExtension(separator: String) -> String {
        let arr = self.components(separatedBy: ".")
        if arr.count > 1 {
            return arr.last!
        }
        return ""
    }
}
