//
//  LoginModeViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 12/2/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

class LoginModeViewController: BaseViewController, SideMenuItemContent {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func openContinueAsUser(_ sender: Any) {
        Global.setOpenContinueAsUser()
    }
    @IBAction func openContinueAsGuest(_ sender: Any) {
        Global.selectMenu(index: 0)
        Global.gotoSelectedView()
    }
    @IBAction func openEnterCode(_ sender: Any) {
        Global.setOpenEnterCode()
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
