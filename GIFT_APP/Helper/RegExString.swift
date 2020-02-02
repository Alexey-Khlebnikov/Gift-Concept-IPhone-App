//
//  RegExString.swift
//  GIFT_APP
//
//  Created by Alguz on 1/14/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import Foundation
class RegExString {
    public static var email: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    public static var username: String = "^.{3,10}$"
    public static var alpha_numeric: String = "^[A-Za-z0-9]{6,20}"
    public static var password: String = "^.{6,50}$"
    public static var phonenumber: String = "[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"
//    public static var globalPhone: String = "^(?:(?:\(?(?:00|\+)([1-4]\d\d|[1-9]\d?)\)?)?[-. \\/]?)?((?:\(?\d{1,}\)?[\-\.\ \\\/]?){0,})(?:[\-\.\ \\\/]?(?:#|ext\.?|extension|x)[\-\.\ \\\/]?(\d+))?$"
}
