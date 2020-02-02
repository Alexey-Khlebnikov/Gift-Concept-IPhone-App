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
        UIApplication.presentedViewController?.present(userOrderViewController!, animated: true, completion: {
                self.isBusy = false
            })
    }
    
    let userOrderViewController: UserOrderViewController? = {
        let vc = Global.instantiateVC(storyboardName: "Main", identifier: "CartViewController") as! UserOrderViewController
        return vc
    }()
}
