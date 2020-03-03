//
//  ImageInfo.swift
//  GIFT_APP
//
//  Created by Alguz on 11/30/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation
import UIKit

class ImageInfo: SafeJsonObject {

    var name: String = ""
    var createdAt: String = ""
    
    var image: UIImage?
    var fullName: String = ""
    var mimeType: String = "image/png"
    var dimension: String = ""
    
    var url: String {
        get {
            return Setting.serverURL + "/post/files/\(fullName)"
        }
    }
    var data: Data? {
        get {
            if mimeType == "image/png" {
                return image?.pngData()
            } else {
                return image?.jpegData(compressionQuality: 1.0)
            }
        }
    }
    
    var fileName: String {
        get {
            return URL(string: fullName)?.deletingPathExtension().lastPathComponent ?? "unknown"
        }
        set {

            var name = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            name = name.isEmpty ? "unknown": name
            
            fullName = name + "." + (fullName as NSString).pathExtension
            print(fullName)
        }
    }
    
    var fileSize: Int {
        get {
            return data?.count ?? 0
        }
    }
    
    var fileSizeString: String {
        get {
            if fileSize < 1024 {
                return String(fileSize) + " Bytes"
            } else if fileSize < 1024 * 1024 {
                return String(fileSize / 1024) + " KB"
            } else {
                return String(fileSize / 1024 / 1024) + " MB"
            }
        }
    }
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "fileName" {
            self.fullName = value as? String ?? ""
        } else {
            super.setValue(value, forKey: key)
        }
    }
}
