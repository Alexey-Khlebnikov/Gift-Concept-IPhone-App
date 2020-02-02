//
//  DeliveryTimeSchedule.swift
//  GIFT_APP
//
//  Created by Alguz on 1/13/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import Foundation

class DeliveryTimeSchedule: SafeJsonObject {
    var id: String = ""
    var startTime: Int = 0
    var endTime: Int = 0
    
    static private var _list: [DeliveryTimeSchedule]?
    
    static func all(complete: @escaping ([DeliveryTimeSchedule]) -> ()) {
        if let list = self._list {
            complete(list)
        } else {
            ApiService.sharedService.find(url: "/constants/find/deliveryTimeSchedule") { (dics) in
                complete(dics.map({return DeliveryTimeSchedule($0)}))
            }
        }
    }
}
