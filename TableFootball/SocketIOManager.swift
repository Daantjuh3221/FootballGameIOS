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
    let userSettings = UserDefaults.standard
    
    // ip Huub  "http://192.168.10.28:3000"
    // ip Daan  "http://192.168.10.49:3000"
    var socket = SocketIOClient(socketURL: URL(string:"http://192.168.10.28:3000")! as URL)
    
    override public init() {
        super.init()
        socket.on("connect") {data, ack in
            if(self.userSettings.object(forKey: "joinCode") != nil){
                self.registeredConnectAppleTV()
                Constants.JOINCODE = self.userSettings.object(forKey: "joinCode") as! String
                print("JoinCode is: \(self.userSettings.object(forKey: "joinCode") as! String)")
            } else {
                self.newConnectAppleTV();
                print("No JoinCode")
            }
            
            print("socket connected")
        }
        self.socket.on("getTeams") {data, ack in
            for players in (data[0] as? NSArray)!{
                print(players)
                Constants.TEAMBLUE.append((players as? String)!)
            }
            for players in (data[1] as? NSArray)!{
                print(players)
                Constants.TEAMRED.append((players as? String)!)
            }
            
            //            personTeamBlue = (data[0] as? String)!
            //            personTeamRed = (data[1] as? String)!
        }
        //socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}
        
        
    }
    
    func getSocket() -> SocketIOClient {
        return socket
    }

    
    func newConnectAppleTV() {
        socket.emit("newConnectAppleTV")
    }
    
    func registeredConnectAppleTV() {
        socket.emit("registeredConnectAppleTV", userSettings.object(forKey: "joinCode") as! String)
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        
        socket.disconnect()
    }
}
