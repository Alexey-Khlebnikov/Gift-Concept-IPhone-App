//
//  Data.swift
//  GIFT_APP
//
//  Created by Alguz on 11/29/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation
import MobileCoreServices

extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

extension NSMutableData {
    func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
