//
//  UserPaymentProcessingViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 2/10/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import UIKit

class UserPaymentProcessingViewController: BaseViewController {
    @IBOutlet weak var lbl_state: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StoreCart.shared.userPaymentProcessingViewController = self
    }
    
    
    func action_paymentProcessing() {
        GiftHttp.sharedApi.Post("/payment/action_result", data: [
            "paymentTempId": StoreCart.shared.userOrderViewController!.paymentTempId!,
            "result": true
        ]) { (response) in
            DispatchQueue.main.async {
                if let error = response.error {
                    self.lbl_state.text = error.code + "::" + error.message
                } else {
                    let result = response.data as! [String:String]
                    if result["result"] == "true" { StoreCart.shared.userOrderViewController?.currentPage = 3
                        StoreCart.shared.cart = []
                    } else {
                        self.lbl_state.text = result["message"]
                    }
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
