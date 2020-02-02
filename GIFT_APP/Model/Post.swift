//
//  Post.swift
//  GIFT_APP
//
//  Created by Alguz on 10/31/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation
class Post: SafeJsonObject {
    var id: String = ""
    var _id: String = ""

    var buyer: User?
    
    var categoryId: String = ""
    var name: String = "I need a small watch 2."
    var content: String = "I want professional game developer to build me web browser game like agar.io style game . with diférent mode . with level systeme and skin . and stats and tool. I want professional game developer to build me web browser game like agar"
    var minPrice: Float = 100
    var maxPrice: Float = 200
    var priceUnit: PriceUnit = PriceUnit()
    var createAt: Date = Date()
    var attaches: [ImageInfo] = []
    
    var bidIds: [String] = []
    var bidList: [BidData] = []
    var sellerIds: [String] = []
    
    func rangePrice() -> String {
        return String.rangePrice(min: minPrice, max: maxPrice, unit: priceUnit.symbol, decimal: 2)
    }
    
    // MARK: - Delivery Infomation
    var deliveryAddress: String = ""
    var deliveryDate: TimeInterval = 0
    var deliveryTimeScheduleId: String = ""
    var deliveryMethod: Int = 0 /// 0: by deliverier, 1: by owner
    var contactPhoneNumber: String = ""
    
    var deliveryTimeSchedule: DeliveryTimeSchedule?
    
    func getFullPrice(price: Float) -> String {
        return String.currencyFormat(price: price, unit: priceUnit.symbol, decimal: 2)
    }
    
    var deliveryDateAndTime: String {
        get {
            return (Date(timeIntervalSince1970: deliveryDate)).localDateString + " " +  String(deliveryTimeSchedule!.startTime) + ":00 ~ "
            + String(deliveryTimeSchedule!.endTime) + ":00"
        }
    }
    
    var deliveryPrice: Float = 0.0
    
    var isBided: Bool {
        get {
            return sellerIds.contains(User.Me.id)
        }
    }
    
    
    static func get(postId: String?, complete: @escaping (Post?) -> ()) {
        if let id = postId {
            ApiService.sharedService.get(url: "/post/get/" + id) { (data) in
                complete(Post(data))
            }
        } else {
            complete(nil)
        }
    }
    static func getByBidId(bidId: String, complete: @escaping (Post) -> ()) {
        ApiService.sharedService.get(url: "/post/getByBidId/" + bidId) { (postData) in
            complete(Post(postData))
        }
    }
    
    static func findByBuyer(complete: @escaping ([Post]) -> ()) {
        ApiService.sharedService.find(url: "/post/findByBuyer/" + Global.udid) { (dictoinaries) in
            complete(dictoinaries.map({return Post($0)}))
        }
    }
    
    func createPost(onSuccess: @escaping (Post) -> (), onError: ((Error?) -> ())? = nil) {
        
        let httpRequest = HttpRequest()
        httpRequest.appendParams([
            "udid": Global.udid,
            "userId": User.Me.id ,
            "categoryId": categoryId,
            "name": name,
            "content": content,
            "minPrice": String(minPrice),
            "maxPrice": String(maxPrice),
            "priceUnit": priceUnit.id,
            "deliveryAddress": deliveryAddress,
            "deliveryDate": String(deliveryDate),
            "deliveryTimeScheduleId": deliveryTimeScheduleId,
            "deliveryMethod": String(deliveryMethod),
            "contactPhoneNumber": contactPhoneNumber
        ])
        
        
        httpRequest.appendImageInfos(fileInfos: attaches, filePathkey: "postImage")

        httpRequest.send(url: Setting.serverApiURL + "/post/create", onSuccess: { (response) in
            let res = response as! [String: Any]
            if let data = res["data"], let dictionary = data as? [String: AnyObject] {
                DispatchQueue.main.async {
                    onSuccess(Post(dictionary))
                }
            }
        }) { (error) in
            if onError != nil {
                onError!(error)
            }
        }
    }
    
    static func find(complete: @escaping ([Post]) -> ()) {
        ApiService.sharedService.find(url: "/post/find") { (dictionaries) in
            complete(dictionaries.map({return Post($0)}))
        }
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "attaches":
            
            let dictionaries = value as! [[String: AnyObject]]
            self.attaches = dictionaries.map({return ImageInfo($0)})
            break
        case "buyer":
            self.buyer = User(value as! [String: AnyObject])
            break
        case "priceUnit":
            self.priceUnit = PriceUnit(value as! [String: AnyObject])
            break
        case "deliveryTimeSchedule":
            self.deliveryTimeSchedule = DeliveryTimeSchedule(value as! [String: AnyObject])
        default:
            super.setValue(value, forKey: key)
        }
    }
    
}
