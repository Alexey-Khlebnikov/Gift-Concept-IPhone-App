

class SoldProduct: SafeJsonObject {
    var id: String?
    var product: Product?
    var soldPrice: Int = 0
    var buyer: Buyer?
    var deliverier: Deliverier?
    var deliveredDate: String?
    
    static func get(productId: String?, complete: @escaping (SoldProduct) -> ()) {
        if let id = productId {
            ApiService.sharedService.get(url: "/soldProduct/get/" + id) { (res) in
                complete(SoldProduct(res))
            }
        }
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "product":
            self.product = Product(value as! [String : AnyObject])
            break
        case "buyer":
            self.buyer = Buyer(value as! [String: AnyObject])
            break
        case "deliverier":
            self.deliverier = Deliverier(value as! [String: AnyObject])
            break
        default:
            super.setValue(value, forKey: key)
        }
    }
}

class Order: SafeJsonObject {
    var date: String?
    var buyer: Buyer?
    var products: [SoldProduct]?
    var deliveryMethod: DeliveryMethod?
    var driver: Deliverier?
    var endDate: String?
}

class DeliveryMethod: SafeJsonObject {
    var type: Bool?     // 0: own, 1: by driver
    var date: String?   // date
    var from: String?   // time
    var to: String?     // time
    var name: String?
    var phoneNumber: String?
    var address: Address?
    var message: String?    // it's a message that is shown to the man who will be received the gift.
}
