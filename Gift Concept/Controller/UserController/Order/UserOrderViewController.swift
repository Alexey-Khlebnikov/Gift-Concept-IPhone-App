//
//  CartViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 1/22/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import UIKit

class UserOrderViewController: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    var currentPage: CGFloat = 0 {
        didSet {
            DispatchQueue.main.async {
                self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * self.currentPage, y: 0), animated: true)
            }
        }
    }
    var paymentTempId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
