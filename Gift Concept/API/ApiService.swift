//
//  ApiService.swift
//  gift_app
//
//  Created by Lexy on 8/13/19.
//  Copyright © 2019 Lexy. All rights reserved.
//

import Foundation

class ApiService {
    static let sharedService = ApiService(endPoint: Setting.serverApiURL)
    
    init(endPoint: String) {
        self.apiEndPoint = endPoint
    }
    var apiEndPoint: String
    
    func find(url: String, complete: @escaping ([[String: AnyObject]]) -> ()) {
        let httpRequest = HttpRequest(endPoint: apiEndPoint)
        httpRequest.GET(url: url, isJson: true, onSuccess: { (response) in
            let res = response as! [String: Any]
            if let data = res["data"], let dictionaries = data as? [[String: AnyObject]] {
                DispatchQueue.main.async {
                    complete(dictionaries)
                }
            }
        }) { (error) in
            print(error ?? "Unknown Error")
        }
    }
    
    func get(url: String, complete: @escaping ([String: AnyObject]) ->()) {
        let httpRequest = HttpRequest(endPoint: apiEndPoint)
        httpRequest.GET(url: url, isJson: true, onSuccess: { (response) in
            let res = response as! [String: Any]
            if let data = res["data"], let dictionary = data as? [String: AnyObject] {
                DispatchQueue.main.async {
                    complete(dictionary)
                }
            }
        }) { (error) in
            print(error ?? "Unknown Error")
        }
    }
    func post(url: String, data: [String: Any], complete: @escaping ([String: AnyObject]) -> ()) {
        
        let httpRequest = HttpRequest(endPoint: apiEndPoint)
        httpRequest.POST(url: url, isJson: true, data: data, onSuccess: { (response) in
            let res = response as! [String: Any]
            if let data = res["data"], let dictionary = data as? [String: AnyObject] {
                DispatchQueue.main.async {
                    complete(dictionary)
                }
            }
        }) { (error) in
            print(error ?? "Unknown Error")
        }
    }
    
    func fetchCategories(complete: @escaping ([Category]) -> ()) {
        let httpRequest = HttpRequest(endPoint: apiEndPoint)
        httpRequest.GET(url: "/category/find", isJson: true, onSuccess: { (response) in
            let res = response as! [String: Any]
            if let data = res["data"], let dictionaries = data as? [[String: AnyObject]] {
                DispatchQueue.main.async {
                    complete(dictionaries.map({return Category($0)}))
                }
            }
        }) { (error) in
            print(error ?? "Unknown Error")
        }
    }
    func fetchBestSellers(complete: @escaping ([Seller]) -> ()) {
        let httpRequest = HttpRequest(endPoint: apiEndPoint)
        httpRequest.GET(url: "/seller/bestSellers", isJson: true, onSuccess: { (response) in
            let res = response as! [String: Any]
            if let data = res["data"], let dictionaries = data as? [[String: AnyObject]] {
                DispatchQueue.main.async {
                    complete(dictionaries.map({return Seller($0)}))
                }
            }
        }) { (error) in
            print(error ?? "Unknown Error")
        }
    }
    
    func fetchLatestProducts(complete: @escaping ([Product]) -> ()) {
        let httpRequest = HttpRequest(endPoint: apiEndPoint)
        httpRequest.GET(url: "/product/latestProducts", isJson: true, onSuccess: { (response) in
            let res = response as! [String: Any]
            if let data = res["data"], let dictionaries = data as? [[String: AnyObject]] {
                DispatchQueue.main.async {
                    complete(dictionaries.map({return Product($0)}))
                }
            }
        }) { (error) in
            print(error ?? "Unknown Error")
        }
    }
    
    func fetchTopProducts(categoryId: String, complete: @escaping ([Product]) -> ()) {
        let httpRequest = HttpRequest(endPoint: apiEndPoint)
        httpRequest.GET(url: "/product/topProducts/\(categoryId)", isJson: true, onSuccess: { (response) in
            let res = response as! [String: Any]
            if let data = res["data"], let dictionaries = data as? [[String: AnyObject]] {
                DispatchQueue.main.async {
                    complete(dictionaries.map({return Product($0)}))
                }
            }
        }) { (error) in
            print(error ?? "Unknown Error")
        }
    }
    
    
    func fetchSoldProducts(complete: @escaping ([SoldProduct]) -> ()) {
        let httpRequest = HttpRequest(endPoint: apiEndPoint)
        httpRequest.GET(url: "/sold_product/billData", isJson: true, onSuccess: { (response) in
            let res = response as! [String: Any]
            if let data = res["data"] {
//                print(data)
//                var soldProducts = [SoldProduct]()
//                for dictionary in data as! [[String: Any]] {
//                    let soldProduct = SoldProduct()
//                    let product = Product()
//                    product.imageURL = dictionary["imageURL"] as? String
//                    soldProduct.product = product
//                    soldProducts.append(soldProduct)
//                    DispatchQueue.main.async {
//                        complete(soldProducts)
//                    }
//                }
            }
        }) { (error) in
            print(error ?? "UnKnown Error")
        }
    }
}
