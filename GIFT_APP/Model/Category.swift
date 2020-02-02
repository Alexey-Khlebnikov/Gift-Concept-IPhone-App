//
//  Category.swift
//  gift_app
//
//  Created by Lexy on 8/6/19.
//  Copyright © 2019 Lexy. All rights reserved.
//

import Foundation

class Category: SafeJsonObject {
    var id: String?
    var imageURL: String = ""
    var iconURL: String = ""
    var name: String?
    
    let endPoint = "\(Setting.serverURL)/assets/img/category/"
    
    var categoryURL: String {
        get {
            return endPoint + imageURL
        }
    }
    var categoryIconURL: String {
        get {
            return endPoint + iconURL
        }
    }
}
