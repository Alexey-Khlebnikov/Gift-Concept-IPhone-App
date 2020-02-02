//
//  SignupViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 11/23/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

class SignupViewController: BaseViewController, SideMenuItemContent {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lbl_username: BaseTextField!
    @IBOutlet weak var lbl_email: BaseTextField!
    @IBOutlet weak var lbl_password: BaseTextField!
    @IBOutlet weak var lbl_confirmPassword: BaseTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        accessibilityLabel = "Signup"
        rootScrollView = scrollView
        // Do any additional setup after loading the view.
    }
    @IBAction func goToMenu(_ sender: Any) {
        showSideMenu()
    }
    @IBAction func actionSignup(_ sender: Any) {
    }
    @IBAction func goToLogin(_ sender: Any) {
        Global.setOpenContinueAsUser()
//        Global.selectMenu(index: 5)
//        Global.gotoSelectedView()
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
