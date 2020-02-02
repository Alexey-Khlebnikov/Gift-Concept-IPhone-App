//
//  DeliveryBid.swift
//  GIFT_APP
//
//  Created by Alguz on 12/12/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation
class DeliveryData: SafeJsonObject {
    var postId: String = ""
    var post: Post?
    var deliveryPrice: Float = 0.0
    var deliverier: Deliverier?
    
    public static func getList(complete: @escaping ([DeliveryData]) -> ()) {
        complete([DeliveryData(), DeliveryData(), DeliveryData()])
//        ApiService.sharedService.find(url: "") { (dictionaries) in
//            complete(dictionaries.map({return DeliveryData($0)}))
//        }
    }
}
