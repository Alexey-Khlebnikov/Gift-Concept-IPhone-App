//
//  LoginViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 11/23/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit
import MaterialComponents.MDCFloatingButton


class LoginViewController: BaseViewController, SideMenuItemContent {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btn_login: MDCFloatingButton!
    
    @IBOutlet weak var txt_password: BaseTextField!
    @IBOutlet weak var txt_email: BaseTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessibilityLabel = "Login"
        rootScrollView = scrollView
        // Do any additional setup after loading the view.
        txt_email.addRegx(RegExString.email, withMsg: "Please insert a vaild email")
        txt_password.addRegx(RegExString.password, withMsg: "The length of password is 6~50.")
        
//        txt_email.text = "odcruningodc@gmail.com"
        txt_email.text = "sotnikov.uri@gmail.com"
        txt_password.text = "123456"
        btn_login.setEnabled(true, animated: false)
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        User.Me.login(email: txt_email.text!, password: txt_password.text!) { () in
            Global.refreshMenu()
            Global.gotoHome()
        }
    }
    
    @IBAction func goToBack(_ sender: Any) {
        Global.selectMenu(index: 5)
        Global.gotoSelectedView()
    }
    
    @IBAction func goToSignup(_ sender: Any) {
        Global.selectMenu(index: 6)
        Global.gotoSelectedView()
    }
    
    @IBAction func goToForgetPassword(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func changeValue(_ sender: Any) {
        if txt_email.validate() && txt_password.validate() {
            btn_login.setEnabled(true, animated: true)
        } else {
            btn_login.setEnabled(false, animated: true)
        }
    }
    
}
	
