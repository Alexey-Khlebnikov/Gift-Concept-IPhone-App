//
//  Errors.swift
//  gift_app
//
//  Created by Lexy on 8/6/19.
//  Copyright © 2019 Lexy. All rights reserved.
//

import Foundation

enum HttpRequestError: Error {
    case invalidURL
    case callingError
    case emptyResponse
    case jsonError
}
