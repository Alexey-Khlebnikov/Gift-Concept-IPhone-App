//
//  BidData.swift
//  GIFT_APP
//
//  Created by Alguz on 11/16/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation

class BidData: SafeJsonObject {
    var id: String = ""
    var userId: String = ""
    var post: Post?
    var postId: String = ""
    var product: Product?
    var productId: String = ""
    var bidPrice: Float = 0.0
    var state: String = "Open"
    var createdAt: String = ""
    
    
    func create(complete: @escaping (BidData) -> ()) {
        ApiService.sharedService.post(url: "/bid/create", data: [
            "udid": Global.udid,
            "productId": productId,
            "postId": postId,
            "bidPrice": bidPrice.toString(toFixed: 2)
        ]) { (response) in
            complete(BidData(response))
        }
    }
    
    func actionAward() {
        ApiService.sharedService.post(url: "/bid/award", data: ["bidId": id]) { (res) in
        }
    }
    
    func actionAccept() {
        ApiService.sharedService.post(url: "/bid/accept/\(id)", data: [:]) { (res) in
            
        }
    }
    
    
    
    static func get(id: String, complete: @escaping (BidData) -> ()) {
        ApiService.sharedService.get(url: "/bid/get/\(id)") { (bidData) in
            complete(BidData(bidData))
        }
    }
    
    static func getMyBidInPost(postId: String, complete: @escaping (BidData) -> ()) {
        ApiService.sharedService.get(url: "/bid/getMyBidInPost/\(postId)") { (bidData) in
            complete(BidData(bidData))
        }
    }
    
    static func getListByPostId(postId: String, complete: @escaping ([BidData]) -> ()) {
        ApiService.sharedService.find(url: "/bid/getProposals/" + postId) { (dictionaries) in
            complete(dictionaries.map({return BidData($0)}))
        }
    }
    
    static func getCompletedListByPostId(postId: String?, complete: @escaping ([BidData]) -> ()) {
        if postId == nil {
            complete([])
        } else {
            ApiService.sharedService.find(url: "bid/getCompletedProposalsByPostId") { (dictionaries) in
                complete(dictionaries.map({return BidData($0)}))
            }
        }
    }
    
    static func getAwardedProposalsOfSeller(complete: @escaping ([BidData]) -> ()) {
        ApiService.sharedService.find(url: "/bid/getAwardedProposalsOfSeller") { (bidList) in
            complete(bidList.map({return BidData($0)}))
        }
    }
    
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "product":
            self.product = Product(value as! [String : AnyObject])
            break
        case "post":
            self.post = Post(value as! [String: AnyObject])
            break
        default:
            super.setValue(value, forKey: key)
        }
    }
}

