//
//  SocketIO.swift
//  GIFT_APP
//
//  Created by Alguz on 12/23/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOApi {
    let manager: SocketManager
    let socket: SocketIOClient
    init(url: String) {
        manager = SocketManager(socketURL: URL(string: url)!, config: [.log(false), .compress])
        socket = manager.defaultSocket
        connect()
    }
    func connect() {
        ApiService.sharedService.find(url: "/buyer/registeGuest/\(Global.udid)") { (res) in
            print(res)
            self.socket.connect()
        }
    }
    
    func on(_ event: String, callback: @escaping (_ res: [String: AnyObject]) -> ()) {
        self.socket.on(event) { (res, ack) in
            print(res[0])
            callback(res[0] as! [String: AnyObject])
        }
    }
    
    static var shared: SocketIOApi = SocketIOApi(url: Setting.serverURL)
}
