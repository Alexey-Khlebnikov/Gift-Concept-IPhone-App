
//
//  User.swift
//  gift_app
//
//  Created by Lexy on 8/31/19.
//  Copyright © 2019 Lexy. All rights reserved.
//

import Foundation

@objcMembers
class SafeJsonObject: NSObject {
    override func setValue(_ value: Any?, forKey key: String) {
        let uppercasedFirstCharacter = String(key.first!).uppercased()
        let range = key.startIndex...key.startIndex
        let selectorString = key.replacingCharacters(in: range, with: uppercasedFirstCharacter)
        let selector = Selector("set\(selectorString):")
        let responds = self.responds(to: selector)
        
        if !responds {
            return
        }
        super.setValue(value, forKey: key)
    }
    init(_ data: [String: AnyObject]) {
        super.init()
        setValuesForKeys(data)
    }
    override init() {
        super.init()
    }
}


class User: SafeJsonObject {
    var id: String  = ""
    var email: String?
    var photoURL: String = ""
    var username: String?
    var displayName: String?
    var role: String?
    var phoneNumber: String?
    var gender: String?
    
    var loginStatus: Bool = false
    var loginTime: Double = 0
    var expireCycle: Int = 0
    var activated: Bool = false
    
    var isLogged: Bool {
        get {
            return loginStatus && now < expiredTime
        }
    }
    
    var now: Double {
        get {
            return Date().timeIntervalSince1970 * 1000
        }
    }
    
    var expiredTime: Double {
        get {
            return loginTime + Double(expireCycle * 60 * 1000)
        }
    }
    
    var url: String {
        get {
            return "\(Setting.serverURL)/assets/img/sellers/" + photoURL
        }
    }
    
    
    func logout(isExit: Bool = false) {
        if isLogged {
            ApiService.sharedService.post(url: "/users/logout", data: [:]) { (res) in
                
            }
        }
        
        User.Me = User()
        if(!isExit) {
            Global.refreshMenu()
            Global.selectMenu(menuName: "Login")
        }
    }
    
    
    func login(email: String, password: String, complete: @escaping () -> ()) {
        ApiService.sharedService.post(url: "/users/login", data: ["email": email,                                                       "password": password]) { (res) in
            
            let payload = res["payload"] as! [String: AnyObject]
            User.Me = User(payload)
            complete()
        }
    }
    
    static var Me: User = User()
}


class Buyer: User {
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
}

class Seller: User {
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    static func getMyProduct(categoryId: String, complete: @escaping ([Product]) -> ()) {
        ApiService.sharedService.find(url: "/seller/getMyProducts") { (categories) in
            complete(categories.map({return Product($0)}))
        }
    }
}

class Deliverier: User {
    var currentPosition: Address?
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "currentPosition" {
            self.currentPosition = Address(value as! [String : AnyObject])
        } else {
            super.setValue(value, forKey: key)
        }
    }
}

class Address: SafeJsonObject {
    var city: String?
    var neighborhood: String?
    var branch: String?
    var country: String?
}

