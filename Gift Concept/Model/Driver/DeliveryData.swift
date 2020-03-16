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
    var deliveriers: [User] = []
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
    
    public static func getMyDeliveryTasks(complete: @escaping ([DeliveryData]) -> ()) {
        GiftHttp.sharedApi.Post("/bid/getMyDeliveryTasks", data: [:]) { (response) in
            if response.error != nil {
                complete([])
            } else {
                let dic = response.data as! [[String: AnyObject]]
                complete(dic.map({return DeliveryData($0)}))
            }
        }
    }
    
    public func bidNow(complete: @escaping (GiftResponse) -> ()) {
        GiftHttp.sharedApi.Post("/bid/bidDelivery/" + self.bidId, data: [:]) { (response) in
            complete(response)
        }
    }
    
    public func award(deliverierId: String, complete: @escaping (GiftResponse) -> ()) {
        GiftHttp.sharedApi.Post("/bid/awardDelivery", data: [
            "bidId": bidId!,
            "deliverierId": deliverierId
        ]) { (response) in
            complete(response)
        }
    }
    
    public func accept(complete: @escaping (GiftResponse) -> ()) {
        GiftHttp.sharedApi.Post("/bid/acceptDelivery/" + bidId, data: [:]) { (response) in
            complete(response)
        }
    }
    
    public func getDeliverier(deliveryId: String, complete: @escaping (User) -> ()) {
        GiftHttp.sharedApi.Post("/bid/getDeliverier", data: [
            "bidId": bidId!,
            "deliverierId": deliveryId
        ]) { (response) in
            if response.error == nil {
                let data = response.data as! [String: AnyObject]
                complete(User(data))
            }
        }
    }
    
    public static func getAlldeliveryRequests(complete: @escaping ([DeliveryData]) -> ()) {
        GiftHttp.sharedApi.Get("/bid/getAllDeliveryRequests") { (response) in
            if response.error != nil {
                complete([])
            } else {
                let data = response.data as! [[String: AnyObject]]
                complete(data.map({return DeliveryData($0)}))
            }
        }
    }
    
    public static func getDeliveryDataForSeller(bidId: String, complete: @escaping (DeliveryData) -> ()) {
        GiftHttp.sharedApi.Get("/bid/getDeliveryDataForSeller/\(bidId)") { (response) in
            if response.error == nil {
                let data = response.data as! [String: AnyObject]
                complete(DeliveryData(data))
            }
        }
    }
    
    public static func getData(bidId: String, complete: @escaping (DeliveryData) -> ()) {
        GiftHttp.sharedApi.Get("/bid/getDeliveryRequest/\(bidId)") { (response) in
            if response.error == nil {
                let deliveryData = DeliveryData(response.data as! [String: AnyObject])
                complete(deliveryData)
            }
        }
    }
    
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "priceUnit":
            self.priceUnit = PriceUnit(value as! [String: AnyObject])
            break
        case "deliveriers":
            let dic = value as! [[String: AnyObject]]
            self.deliveriers = dic.map({return User($0)})
        default:
            super.setValue(value, forKey: key)
        }
    }
}

