//
//  SocketIOManager.swift
//  TableFootball
//
//  Created by Daan Befort on 21/03/2017.
//  Copyright © 2017 HuubvandeHoef. All rights reserved.
//

import Foundation

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    // ip Huub  "http://192.168.10.28:3000"
    // ip Daan  "http://192.168.10.49:3000"
    var socket = SocketIOClient(socketURL: URL(string:"http://192.168.10.49:3000")! as URL)
    
    override public init() {
        super.init()
        socket.on("connect") {data, ack in
            self.connectAppleTV();
            print("socket connected")
        }
        socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}
        
        
    }
    
    func getSocket() -> SocketIOClient {
        return socket
    }

    
    func connectAppleTV() {
        socket.emit("connectAppleTV")
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
