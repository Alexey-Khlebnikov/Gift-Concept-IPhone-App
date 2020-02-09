//
//  StoreCart.swift
//  GIFT_APP
//
//  Created by Alguz on 1/22/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import Foundation
class StoreCart {
    static var shared: StoreCart = StoreCart()
    // bidIds
    var cart: [BidData] = [] {
        didSet {
            btn_Cart.badgeText = cart.count == 0 ? "" : String(cart.count)
        }
    }
    var paymentInfo: Dictionary<String, (totalPrice: Float, totalProductPrice: Float, totalDeliveryPrice: Float)>!
    
    var totalPrice: Float = 0
    var totalProductPrice: Float = 0
    var totalDeliveryPrice: Float = 0
    var bonusPrice: Float = 0 {
        didSet {
            refreshPaymentPrice()
        }
    }
    
    var totalPriceString: String {
        get {
            return String.currencyFormat(price: totalPrice, unit: myPriceUnit.symbol, decimal: 2)
        }
    }
    
    var totalProductPriceString: String {
        get {
            return String.currencyFormat(price: totalProductPrice, unit: myPriceUnit.symbol, decimal: 2)
        }
    }
    
    var totalDeliveryPriceString: String {
        get {
            return String.currencyFormat(price: totalDeliveryPrice, unit: myPriceUnit.symbol, decimal: 2)
        }
    }
    
    var bonusPriceString: String {
        get {
            return String.currencyFormat(price: bonusPrice, unit: myPriceUnit.symbol, decimal: 2)
        }
    }
    
    var myPriceUnit: PriceUnit = PriceUnit()
    
    func refreshPaymentPrice() {
        paymentInfo = Dictionary<String, (totalPrice: Float, totalProductPrice: Float, totalDeliveryPrice: Float)>()
        totalPrice = 0
        totalProductPrice = 0
        totalDeliveryPrice = 0
        
        cart.forEach { (bidData) in
            let priceUnit = bidData.priceUnit
            let priceRate = myPriceUnit.rate / priceUnit.rate
            if !paymentInfo.keys.contains(where: {$0 == bidData.priceUnit.id}) {
                paymentInfo[bidData.priceUnit.id] = (0.0, 0.0, 0.0)
            }
            var info = paymentInfo[bidData.priceUnit.id]!
            info.totalPrice += bidData.bidPrice + bidData.deliveryPrice
            info.totalProductPrice += bidData.bidPrice
            info.totalDeliveryPrice += bidData.deliveryPrice
            
            totalPrice += info.totalPrice * priceRate
            totalDeliveryPrice += info.totalDeliveryPrice * priceRate
            totalProductPrice += info.totalProductPrice * priceRate
        }
        
        totalPrice += bonusPrice
    }

    lazy var btn_Cart: BadgeButton = {
        let btn = BadgeButton(frame: CGRect(x: 0, y: 0, width: 37.5, height: 30))
        btn.setImage(UIImage(systemName: "cart.fill"), for: .normal)
        btn.addTarget(self, action: #selector(toggleCartViewController), for: .touchUpInside)
        return btn
    }()
    
    private var isBusy: Bool = false
    
    @objc func toggleCartViewController() {
        if cart.count == 0 {
            return
        }
        if isBusy {
            return
        }
        isBusy = true
        bonusPrice = 0
        UIApplication.presentedViewController?.present(userOrderViewController!, animated: true, completion: {
                self.isBusy = false
            })
    }
    
    let userOrderViewController: UserOrderViewController? = {
        let vc = Global.instantiateVC(storyboardName: "Main", identifier: "CartViewController") as! UserOrderViewController
        return vc
    }()
    var userPaymentProcessingViewController: UserPaymentProcessingViewController?
}
