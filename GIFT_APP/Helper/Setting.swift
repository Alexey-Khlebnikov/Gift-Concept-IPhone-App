//
//  Setting.swift
//  GIFT_APP
//
//  Created by Alguz on 11/1/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

class Setting {
    static var serverURL: String {
        get {
            return "http://192.168.208.104:3030"
        }
    }
    
    static var serverApiURL: String {
        return Setting.serverURL + "/api"
    }
    
}
