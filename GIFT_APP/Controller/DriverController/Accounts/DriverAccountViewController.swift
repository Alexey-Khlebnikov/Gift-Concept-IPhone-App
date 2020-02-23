//
//  DriverAccountViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 2/17/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import UIKit

class DriverAccountViewController: BaseViewController {

    @IBOutlet weak var iv_avatar: AvatarImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iv_avatar.fromURL(urlString: "girl.png")
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
