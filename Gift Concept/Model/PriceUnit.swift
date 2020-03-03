//
//  PriceUnit.swift
//  GIFT_APP
//
//  Created by Alguz on 12/24/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation
class PriceUnit: SafeJsonObject {
    var id: String = ""
    var name: String = "dollar"
    var symbol: String = "$"
    var detail: String  = ""
    var rate: Float = 1
    
    private static var _priceUnits: [PriceUnit]?
    
    static func all(complete: @escaping ([PriceUnit]) -> ()) {
        if let units = self._priceUnits {
            complete(units)
        } else {
            ApiService.sharedService.find(url: "/priceUnit/find") { (dics) in
                complete(dics.map({return PriceUnit($0)}))
            }
        }
    }
}
