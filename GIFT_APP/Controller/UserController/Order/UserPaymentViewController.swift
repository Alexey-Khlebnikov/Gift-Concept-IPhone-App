//
//  UserPaymentViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 1/23/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import UIKit

class UserPaymentViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func action_GotoBack(_ sender: Any) {
        StoreCart.shared.userOrderViewController?.currentPage = 0
    }
    @IBAction func action_Pay(_ sender: Any) {
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
