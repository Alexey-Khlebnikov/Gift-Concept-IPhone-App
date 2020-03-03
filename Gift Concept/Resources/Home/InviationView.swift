//
//  InviationView.swift
//  GIFT_APP
//
//  Created by Alguz on 11/7/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation
import SwiftMessages
class InviationView: MessageView {
    @IBAction func btnClick_Invite(_ sender: Any) {
        sendInvite?(10)
    }
    @IBAction func btnClick_Cancel(_ sender: Any) {
        cancelAction?()
    }
    
    var sendInvite: ((_ count: Int) -> Void)?
    var cancelAction: (() -> Void)?
    
}
