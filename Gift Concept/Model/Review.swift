//
//  Review.swift
//  GIFT_APP
//
//  Created by Alguz on 11/18/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

class Review: SafeJsonObject {
    var rate: Float = 0.0
    var content: String = ""
    var owner: User?
    var bidDataId: String = ""
    var createdAt: String = "0000/00/00"
    
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "owner":
            self.owner = User(value as! [String: AnyObject])
        default:
            super.setValue(value, forKey: key)
        }
    }
    
    static func getReviewsByPostId(postId: String?, complete: @escaping ([Review]) -> ()) {
        if postId == nil {
            complete([])
        } else {
            ApiService.sharedService.find(url: "/review/findByPostId") { (reviews) in
                complete(reviews.map({return Review($0)}))
            }
        }
    }
}
