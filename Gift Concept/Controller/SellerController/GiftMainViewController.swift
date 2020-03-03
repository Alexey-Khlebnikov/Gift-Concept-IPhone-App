//
//  SellerMainViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 12/3/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

class GiftMainViewController: MenuContainerViewController {
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    var allMenus: Dictionary<String, UIViewController> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOptions()
        setupMenuController()
        contentControllers()
        
        selectContentViewController(allMenus["SellerMain"]!)
        // Do any additional setup after loading the view.
    }
    
    func setupOptions() {
        self.currentItemOptions.cornerRadius = 10.0
        
        let screenSize: CGRect = UIScreen.main.bounds
        self.transitionOptions = TransitionOptions(duration: 0.4, visibleContentWidth: screenSize.width / 3)
    }
    func setupMenuController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.menuViewController = storyboard.instantiateViewController(identifier: "GiftMenuViewController")
    }
    
    func contentControllers() {
        let sellerStoryboard = UIStoryboard(name: "Seller", bundle: nil)
        let sellerMainViewController = sellerStoryboard.instantiateViewController(identifier: "SellerMainViewController")
        allMenus["SellerMain"] = sellerMainViewController
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
