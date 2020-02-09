//
//  Payment.swift
//  GIFT_APP
//
//  Created by Alguz on 2/10/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import Foundation
class Payment: SafeJsonObject {
    var id: String?
    var buyerId: String?
    var buyerUdid: String?
    var bidIds: [String] = []
    var bonusPrice: Float = 0
    var state: String?
}
