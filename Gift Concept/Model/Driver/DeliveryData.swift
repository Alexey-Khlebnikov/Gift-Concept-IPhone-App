//
//  DeliveryData.swift
//  GIFT_APP
//
//  Created by Alguz on 2/19/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import Foundation
class DeliveryData: SafeJsonObject {
    var bidId: String!
    var productName: String!
    var productImageId: String!
    var from: String!
    var to: String!
    var deliveryPrice: Float = 0
    var priceUnit: PriceUnit!
    var deliverierIds: [String] = []
    var awardedDeliverierIds: [String] = []
    var deliveryId: String!
    
    var isBid: Bool {
        get {
            return deliverierIds.contains(User.Me.id)
        }
    }
    var deliveryPriceString: String {
        get {
            return String.currencyFormat(price: deliveryPrice, unit: priceUnit.symbol, decimal: 2)
        }
    }
    
    public func bidNow(complete: @escaping (GiftResponse) -> ()) {
        GiftHttp.sharedApi.Post("/bid/bidDelivery/" + self.bidId, data: [:]) { (response) in
            complete(response)
        }
    }
    
    public func accept(complete: @escaping () -> ()) {
        GiftHttp.sharedApi.Post("/bid/acceptDelivery/" + bidId, data: [:]) { (response) in
            
        }
    }
    
    public static func getList(complete: @escaping ([DeliveryData]) -> ()) {
        GiftHttp.sharedApi.Get("/bid/deliveryRequests") { (response) in
            if response.error != nil {
                complete([])
            } else {
                let data = response.data as! [[String: AnyObject]]
                complete(data.map({return DeliveryData($0)}))
            }
        }
    }
    
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "priceUnit":
            self.priceUnit = PriceUnit(value as! [String: AnyObject])
            break
        default:
            super.setValue(value, forKey: key)
        }
    }
}

