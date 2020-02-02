//
//  EnterCodeViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 12/2/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

class EnterCodeViewController: BaseViewController, SideMenuItemContent {

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootScrollView = scrollView
        // Do any additional setup after loading the view.
    }
    
    @IBAction func gotoBack(_ sender: Any) {
        Global.selectMenu(index: 5)
        Global.gotoSelectedView()
    }
    @IBAction func actionLogin(_ sender: Any) {
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
