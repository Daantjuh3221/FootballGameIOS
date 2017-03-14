//
//  ViewController.swift
//  IphoneSocketTest
//
//  Created by Daan Befort on 11/03/2017.
//  Copyright © 2017 Daan Befort. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var name: String?
    var socket: SocketIOClient?
    var list = [String]()
    @IBOutlet var TableRooms: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        socket = SocketIOClient(socketURL: NSURL(string:"http://localhost:3000")! as URL)
        addHandlers()
        socket!.connect()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (list.count)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "roomName")
        cell.textLabel?.text = list[indexPath.row]
        
        return cell
    }

    
    func addHandlers(){
        socket?.on("connect") {data, ack in
            print("socket connected")
        }
        
        
        socket?.on("getRooms") {data, ack in
            if let dataDict = data[0] as? [String]{
                for item in dataDict{
                    self.list.append(item)
                }
                self.TableRooms.reloadData()
            }
        }
        
        socket?.on("message") {data, ack in
            print(data)
        }
        
        //socket?.onAny {print("Got event: \($0.event), with items: \($0.items)")}
    }
    
    @IBAction func btnClick(_ sender: Any) {
        socket?.emit("joinserver", "DaanBefort","Iphone")
        print("button clicked")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

