//
//  UserPaymentViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 1/23/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import UIKit

class UserPaymentViewController: BaseViewController {
    @IBOutlet weak var lbl_country: UILabel!
    @IBOutlet weak var txt_country: UITextField!
    @IBOutlet weak var v_cardInformation: UIView!
    
    @IBOutlet weak var btn_credit: UIButton!
    @IBOutlet weak var btn_mada: UIButton!
    @IBOutlet weak var btn_paypal: UIButton!
    
    @IBOutlet weak var cnt_Mada: NSLayoutConstraint!
    @IBOutlet weak var cnt_Paypal: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()        // Do any additional setup after loading the view.
        setActiveBtn(btn_credit)
        cancelActiveBtn(btn_mada)
        cancelActiveBtn(btn_paypal)
    }
    
    @IBAction func action_GotoBack(_ sender: Any) {
        StoreCart.shared.userOrderViewController?.currentPage = 0
    }
    @IBAction func action_Pay(_ sender: Any) {
    }
    @IBAction func setCreditMode(_ sender: Any) {
        cnt_Mada.priority = UILayoutPriority(1000)
        cnt_Paypal.priority = UILayoutPriority(999)
        setActiveBtn(btn_credit)
        cancelActiveBtn(btn_mada)
        cancelActiveBtn(btn_paypal)
    }
    @IBAction func setMadaMode(_ sender: Any) {
        cnt_Mada.priority = UILayoutPriority(997)
        cnt_Paypal.priority = UILayoutPriority(999)
        cancelActiveBtn(btn_credit)
        setActiveBtn(btn_mada)
        cancelActiveBtn(btn_paypal)
    }
    @IBAction func setPaypalMode(_ sender: Any) {
        cnt_Mada.priority = UILayoutPriority(997)
        cnt_Paypal.priority = UILayoutPriority(997)
        cancelActiveBtn(btn_credit)
        cancelActiveBtn(btn_mada)
        setActiveBtn(btn_paypal)
    }
    func setActiveBtn(_ button: UIButton) {
        button.backgroundColor = UIColor.mainColor1
        button.setTitleColor(.white, for: .normal)
    }
    func cancelActiveBtn(_ button: UIButton) {
        button.backgroundColor = UIColor.white
        button.setTitleColor(.systemGray, for: .normal)
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
