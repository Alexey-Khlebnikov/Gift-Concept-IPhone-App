//
//  SellerSettingViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 12/7/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit
import SelectionList

class SellerSettingViewController: BaseViewController, CheckBoxListViewDelegate {
    public static var sharedInstance: SellerSettingViewController!
    
    public static var shared: SellerSettingViewController {
        get {
            if let shared = sharedInstance {
                return shared
            }
            sharedInstance = Global.instantiateVC(storyboardName: "Seller", identifier: "SellerSettingViewStoryboard") as! SellerSettingViewController
            return sharedInstance
        }
    }
    
    func changeValues() {
    }
    @IBOutlet weak var categories_checkedlist: CheckBoxListView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        categories_checkedlist.delegate = self
    self.overlayView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(self.closeView(_:))))
    }
    @IBOutlet weak var contentVie: MyBaseView!
    var menuViewRate: CGFloat = 0.6
    
    var overlayView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    func showView() {
        if let keyWindow = UIApplication.keyWindow {
            overlayView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            keyWindow.addSubview(overlayView)
            keyWindow.addSubview(view)

            overlayView.frame = keyWindow.bounds
            view.frame = CGRect(x: keyWindow.bounds.width, y: 0, width: keyWindow.bounds.width * menuViewRate, height: keyWindow.bounds.height)
            
            overlayView.alpha = 0
            UIView.animate(withDuration: 0.4, animations: {
                self.overlayView.alpha = 1
                self.view.frame = CGRect(x: keyWindow.bounds.width * (1 - self.menuViewRate), y: 0, width: keyWindow.bounds.width * self.menuViewRate, height: keyWindow.bounds.height)
            }) { (finished) in
//                self.contentVie.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(self.closeView(_:))))
            }
        }
    }
    @objc func closeView(_ sender: UITapGestureRecognizer) {
        print("closeView")
//        if let keyWindow = UIApplication.keyWindow {
//            UIView.animate(withDuration: 0.4, animations: {
//                self.overlayView.alpha = 0
//                self.view.frame = CGRect(x: keyWindow.bounds.width, y: 0, width: keyWindow.bounds.width * self.menuViewRate, height: keyWindow.bounds.height)
//            }) { (finished) in
//            }
//        }
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
