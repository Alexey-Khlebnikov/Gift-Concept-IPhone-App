//
//  HttpRequest.swift
//  gift_app
//
//  Created by Lexy on 8/6/19.
//  Copyright © 2019 Lexy. All rights reserved.
//

import Foundation
import MobileCoreServices

class HttpRequest {
    
    private var todoEndpoint: String
    private var body: Data
    private var boundary: String
    private var failedFileNames: [String] = []
    
    init(endPoint: String) {
        self.todoEndpoint = endPoint
        self.body = Data()
        self.boundary = "Boundary-\(NSUUID().uuidString)"
    }
    convenience init() {
        self.init(endPoint: "")
    }
    
    public func GET(url: String, isJson: Bool, onSuccess success: @escaping (_ data: Any) -> Void, onError failure: @escaping (_ error: Error?) -> Void) {
        
        guard let url = URL(string: todoEndpoint + url) else {
            print("Error: cannot create URL")
            failure(HttpRequestError.invalidURL)
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on \(url)")
                failure(error)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                failure(HttpRequestError.emptyResponse)
                return
            }
            if isJson {
                // parse the result as JSON, since that's what the API provides
                do {
                    let todo = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String:Any]
                    success(todo)
                } catch let jsonError  {
                    failure(jsonError)
                    return
                }
            } else {
                success(responseData)
            }
        }
        task.resume()
    }
    
    public func POST(url: String, isJson: Bool, data: [String: Any], onSuccess success: @escaping (_ data: Any) -> Void, onError failure: @escaping (_ error: Error?) -> Void) {
        guard let url = URL(string: self.todoEndpoint + url) else {
            print("Error: cannot create URL")
            failure(HttpRequestError.invalidURL)
            return
        }
        var request = URLRequest(url: url)
        
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Powered by Sotinikov", forHTTPHeaderField: "X-Powered-By")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
        
        let task = session.uploadTask(with: request, from: jsonData) {
            data, response, error in
            
            guard error == nil else {
                print("error calling GET on \(url)")
                failure(error)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                failure(HttpRequestError.emptyResponse)
                return
            }
            
            if isJson {
                // parse the result as JSON, since that's what the API provides
                do {
                    let todo = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String:Any]
                    success(todo)
                } catch let jsonError  {
                    failure(jsonError)
                    return
                }
            } else {
                success(responseData)
            }
        }
        
        task.resume()
    }
    
    public func binary(url: String, onSuccess success: @escaping (_ data: Data) -> Void, onError failure: @escaping (_ error: Error?) -> Void) {
        guard let url = URL(string: todoEndpoint + url) else {
            print("Error: cannot create URL")
            failure(HttpRequestError.invalidURL)
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on \(url)")
                failure(error)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                failure(HttpRequestError.emptyResponse)
                return
            }
            
            success(responseData)
        }
        task.resume()
    }
    
    func DELETE(url: String, id: String) {
        
    }
    
    
    func send(url: String, type: String = "POST", isJson: Bool = true, onSuccess success: @escaping (_ data: Any) -> (), onError failure: @escaping (_ error: Error?) -> ()) {
        guard let url = URL(string: self.todoEndpoint + url) else {
            print("Error: cannot create URL")
            failure(HttpRequestError.invalidURL)
            return
        }
        appendEnd()
        
        let urlRequest = NSMutableURLRequest(url: url)
        urlRequest.httpMethod = type
        urlRequest.setValue("multipart/form-data; boundary=\(self.boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = body
        body = Data()
        
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("error calling \(type) on \(url)")
                    failure(error)
                    return
                }
                // make sure we got data
                guard let responseData = data else {
                    print("Error: did not receive data")
                    failure(HttpRequestError.emptyResponse)
                    return
                }
                if isJson {
                    // parse the result as JSON, since that's what the API provides
                    do {
                        let todo = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String:Any]
                        success(todo)
                    } catch let jsonError  {
                        failure(jsonError)
                        return
                    }
                } else {
                    success(responseData)
                }
            }
        }
        task.resume()
    }
    
    public func appendParams(_ params: [String: String]?) {
        if params != nil {
            for (key, value) in params! {
                body.append("--\(self.boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
    }
    
    public func appendFileByURL(url: URL, filePathKey: String) {
        let filename = url.lastPathComponent
        let data = try! Data(contentsOf: url)
        let mimetype = url.mimeType()

        appendFile(data: data, filePathKey: filePathKey, filename: filename, mimeType: mimetype)
    }
    
    public func appendFilesByURLs(urls: [URL], filePathKey: String) {
        for url in urls {
            appendFileByURL(url: url, filePathKey: filePathKey)
        }
    }
    
    public func appendFile(data: Data?, filePathKey: String, filename: String, mimeType: String) {
        guard let data = data else {
            failedFileNames.append(filename)
            return
        }
        body.append("--\(self.boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.append("\r\n")
    }
    
    public func appendImageInfo(fileInfo: ImageInfo, filePathKey: String) {
        appendFile(data: fileInfo.data, filePathKey: filePathKey, filename: fileInfo.fullName, mimeType: fileInfo.mimeType)
    }
    
    public func appendImageInfos(fileInfos: [ImageInfo], filePathkey: String) {
        for fileInfo in fileInfos {
            appendImageInfo(fileInfo: fileInfo, filePathKey: filePathkey)
        }
    }
    
    private func appendEnd() {
        body.append("--\(self.boundary)--\r\n")
    }
    
}

