//
//  WebRequest.swift
//  GIFT_APP
//
//  Created by Alguz on 2/8/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import Foundation
import MobileCoreServices

class GiftHttp {
    static var shared: GiftHttp = GiftHttp(endPoint: Setting.serverURL)
    static var sharedApi: GiftHttp = GiftHttp(endPoint: Setting.serverApiURL)
    
    private var endPoint: String
    
    init(endPoint: String) {
        self.endPoint = endPoint
    }
    
    public func Get(_ path: String, response: @escaping (GiftResponse) -> ()) {
        GiftHttp.GET(self.endPoint + path) { (res) in
            response(res)
        }
    }
    
    public func Post(_ path: String, data: [String: Any], response: @escaping (GiftResponse) -> ()) {
        GiftHttp.POST(self.endPoint + path, data: data) { (res) in
            response(res)
        }
    }
    
    public func Binary(_ path: String, response: @escaping (GiftResponse) -> ()) {
        GiftHttp.BINARY(self.endPoint + path) { (res) in
            response(res)
        }
    }
    
    public func Download(_ path: String, response: @escaping (GiftResponse) -> ()) {
        
    }
    
    public func Upload(path: String, data: [String: Any], response: @escaping (GiftResponse) -> ()) {
        GiftHttp.UPLOAD(url: self.endPoint + path, data: data) { (res) in
            response(res)
        }
    }
    
    static func GET(_ url: String, response: @escaping (GiftResponse) -> ()) {
        
        guard let Url = URL(string: url) else {
            let error = [
                "error": [
                    "code": "Invalid URL",
                    "message": "\(url) can't create URL"
                ]
            ]
            return response(GiftResponse(error))
        }
        
        var urlRequest = URLRequest(url: Url)
        urlRequest.httpMethod = "GET"
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, res, error) in
            // check for any errors
            response(GiftHttp.ApiResponseProcess(urlRequest, data, res, error))
        }
        task.resume()
    }
    
    
    static func POST(_ url: String, data: [String: Any], response: @escaping (GiftResponse) -> ()) {
        
        guard let Url = URL(string: url) else {
            let error = [
                "error": [
                    "code": "Invalid URL",
                    "message": "\(url) can't create URL"
                ]
            ]
            return response(GiftResponse(error))
        }
        
        var urlRequest = URLRequest(url: Url)
        
        let session = URLSession.shared
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Powered by Sotinikov", forHTTPHeaderField: "X-Powered-By")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
        
        
        // make the request
        let task = session.uploadTask(with: urlRequest, from: jsonData) {
            (data, res, error) in
            // check for any errors
            response(GiftHttp.ApiResponseProcess(urlRequest, data, res, error))
        }
        task.resume()
    }
    
    static func BINARY(_ url: String, response: @escaping (GiftResponse) -> ()) {
        guard let Url = URL(string: url) else {
            let error = [
                "error": [
                    "code": "Invalid URL",
                    "message": "\(url) can't create URL"
                ]
            ]
            return response(GiftResponse(error))
        }
        
        var urlRequest = URLRequest(url: Url)
        urlRequest.httpMethod = "GET"
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        
        let task = session.dataTask(with: urlRequest) {
            (data, res, error) in
            guard error == nil else {
                let err = [
                    "error": [
                        "code": "Binary Error",
                        "message": "Error calling Binary on \(url)"
                    ]
                ]
                return response(GiftResponse(err))
            }
            // make sure we got data
            guard let responseData = data else {
                let err = [
                    "error": [
                        "code": "Binary Error",
                        "message": "did not receive data from \(url)."
                    ]
                ]
                return response(GiftResponse(err))
            }
            
            response(GiftResponse(binaryData: responseData))
        }
        task.resume()
        
    }
    
    static func DOWNLOAD(_ url: String, response: @escaping (GiftResponse) -> ()) {
        
    }
    
    static func UPLOAD(url: String, data: [String: Any], response: @escaping (GiftResponse) -> ()) {
        
        guard let Url = URL(string: url) else {
            let error = [
                "error": [
                    "code": "Invalid URL",
                    "message": "\(url) can't create URL"
                ]
            ]
            return response(GiftResponse(error))
        }
        
        let boundary = "Boundary-\(NSUUID().uuidString)"
        
        var body = Data()
        for (key, value) in data {
            if let val = value as? String {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(val)\r\n")
            } else {
                var fileInfos: [ImageInfo] = []
                if let fileInfo = value as? ImageInfo {
                    fileInfos = [fileInfo]
                } else if let fileInfo = value as? [ImageInfo] {
                    fileInfos = fileInfo
                }
                for fileInfo in fileInfos {
                    if let data = fileInfo.data {
                        body.append("--\(boundary)\r\n")
                        body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileInfo.fullName)\"\r\n")
                        body.append("Content-Type: \(fileInfo.mimeType)\r\n\r\n")
                        body.append(data)
                        body.append("\r\n")
                    }
                }
            }
        }
        body.append("--\(boundary)--\r\n")
        
        let urlRequest = NSMutableURLRequest(url: Url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = body
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest as URLRequest) { (data, res, error) in
            response(ApiResponseProcess(urlRequest as URLRequest, data, res, error))
        }
        task.resume()
    }
    
    
    private static func ApiResponseProcess(_ request: URLRequest, _ data: Data?, _ response: URLResponse?, _ error: Error?) -> GiftResponse {
        let url = request.url!.absoluteString
        let type = request.httpMethod!
        guard error == nil else {
            let err = [
                "error": [
                    "code": "\(type) Error",
                    "message": "Error calling \(type) on \(url)"
                ]
            ]
            return GiftResponse(err)
        }
        // make sure we got data
        guard let responseData = data else {
            let err = [
                "error": [
                    "code": "\(type) Error",
                    "message": "did not receive data from \(url)."
                ]
            ]
            return GiftResponse(err)
        }
        return GiftResponse(responseData)
    }
    
}

class GiftError {
    var code: String!
    var message: String!
    init(_ error: Any) {
        let dic = error as! [String: String]
        code = dic["code"]!
        message = dic["message"]!
    }
}

class GiftResponse {
    var error: GiftError? {
        didSet {
            if let error = error {
                print("\(String(describing: error.code))::\(String(describing: error.message))")
            }
        }
    }
    var data: Any!
    var rawData: Data
    
    init(_ rawData: Data) {
        self.rawData = rawData
        do {
            let todo = try JSONSerialization.jsonObject(with: rawData, options: []) as! [String:Any]
            resultProcess(todo)
        } catch let jsonError {
            error = GiftError([
                "code": "Invalid Response",
                "message": jsonError.localizedDescription
            ])
        }
    }
    
    init(binaryData: Data) {
        self.rawData = binaryData
    }
    
    init(_ data: [String: Any]) {
        self.rawData = try! JSONSerialization.data(withJSONObject: data, options: [])
        resultProcess(data)
    }
    
    private func resultProcess(_ data: [String: Any]) {
        if let error = data["error"] {
            self.error = GiftError(error)
        } else {
            self.data = data["data"]
        }
    }
    
    
}
