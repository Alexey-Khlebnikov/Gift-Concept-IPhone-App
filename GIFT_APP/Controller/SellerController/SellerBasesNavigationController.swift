//
//  SellerBasesNavigationController.swift
//  GIFT_APP
//
//  Created by Alguz on 12/4/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

class SellerBasesNavigationController: UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationBar.titleTextAttributes = textAttributes
        // Do any additional setup after loading the view.
    }
    
    var homeController: HomeController? {
        get {
            return viewControllers[0] as? HomeController ?? nil
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
