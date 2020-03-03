//
//  Product.swift
//  GIFT_APP
//
//  Created by Alguz on 11/3/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//


class Product: SafeJsonObject {
    var id: String = ""
    var name: String = ""
    var detail: String = ""
    var imageURL: String = ""
    var imageIds: [String] = []
//    var images: [ImageInfo] = []
    
    var price: Float = 0
    var priceUnit: PriceUnit = PriceUnit()
    
    var rate: Float = 0.0
    var reviewIds: [String] = []
    var reviews: [Review] = []
    var reviewCount: Int = 0
    var soldCount: Int = 0
    
    var seller: Seller?
    
    var fullPrice: String {
        get {
            return String.currencyFormat(price: price, unit: priceUnit.symbol, decimal: 2)
        }
    }
    
    func getFullPrice(price: Float) -> String {
        return String.currencyFormat(price: price, unit: priceUnit.symbol, decimal: 2)
    }
    
    var url: String {
        get {
            return Setting.serverApiURL + "/product/productImage/" + imageIds[0]
        }
    }
    
    func getProductImageURL(imageId: String) -> String {
        return Setting.serverApiURL + "/product/productImage/" + imageId
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "seller":
            self.seller = Seller(value as! [String: AnyObject])
            break
        case "reviews":
            let dictionaries = value as! [[String: AnyObject]]
            self.reviews = dictionaries.map({return Review($0)})
            break
        case "priceUnit":
            self.priceUnit = PriceUnit(value as! [String: AnyObject])
            break
        default:
            super.setValue(value, forKey: key)
        }
    }
    
    static func getMyProduct(categoryId: String, complete: @escaping ([Product]) -> ()) {
        print(categoryId)
        ApiService.sharedService.find(url: "/product/getMyProduct/\(categoryId)") {
            (categories) in
            complete(categories.map({return Product($0)}))
        }
    }
    
    static func get(productId: String, complete: @escaping (Product) -> ()) {
        ApiService.sharedService.get(url: "/product/get/\(productId)") { (data) in
            complete(Product(data))
        }
    }
}
