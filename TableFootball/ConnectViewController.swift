//
//  ConnectViewController.swift
//  TableFootball
//
//  Created by Daan Befort on 29/03/2017.
//  Copyright © 2017 HuubvandeHoef. All rights reserved.
//

import Foundation
import UIKit

class ConnectViewController: UIViewController {
    
    @IBOutlet weak var listConnectedPlayers: UITextView!
    
    //List of both teams
    @IBOutlet weak var redList: UITextView!
    @IBOutlet weak var blueList: UITextView!
    
    

    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var i:Int = 0
    
    @IBOutlet weak var lblJoinCode: UILabel!
    let userSettings = UserDefaults.standard
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        //self.listConnectedPlayers.text.append("\n")
//        activityIndicator.center = self.view.center
//        activityIndicator.hidesWhenStopped = true
//        //activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        view.addSubview(activityIndicator)
//        
//        activityIndicator.startAnimating()
//        UIApplication.shared.beginIgnoringInteractionEvents()
        
        activityIndicator("Waiting for players...")
        
        //self.userSettings.set("elit7u", forKey: "joinCode")
        
        updatePlayerList()
        
        self.listConnectedPlayers.text = ""
        
        let socket = SocketIOManager.sharedInstance.getSocket();
        socket.on("userJoinedAppleTV") {data, ack in
            Constants.CONNECTEDPLAYERS.append((data[0] as? String)!)
            
           // self.redList.text.append((data[0] as? String)!)
            //self.redList.text.append(",")
            
            
            self.i += 1
            self.strLabel.text = "Waiting for players. \(self.i) joined"
        }
        socket.on("getJoinCode") {data, ack in
            let joinCode:String = (data[0] as? String)!
            self.lblJoinCode.text = joinCode
            //self.lblJoinCode.text?.append(joinCode) //= joinCode
            self.userSettings.set(joinCode, forKey: "joinCode")
        }
        
        //Red team list
        socket.on(Constants.EMIT_VALUES.getTeamRed.rawValue){data, ack in
            //Adds player to list if its not allready on the list
            if(!Constants.TEAMREDLIST.contains((data[0] as? String)!)){
                Constants.TEAMREDLIST.append((data[0] as? String)!)
            }
            
            //Check if other list contains player and delete it
            if let index = Constants.TEAMBLUELIST.index(of: (data[0] as? String)!) {
                Constants.TEAMBLUELIST.remove(at: index)
            }
            self.checkForHostPlayer()
        }
        //Blue team list
        socket.on(Constants.EMIT_VALUES.getTeamBlue.rawValue){data, ack in
            //Adds player to list if its not allready on the list
            if(!Constants.TEAMBLUELIST.contains((data[0] as? String)!)){
                Constants.TEAMBLUELIST.append((data[0] as? String)!)
            }
            
            //Check if other list contains player and delete it
            if let index = Constants.TEAMREDLIST.index(of: (data[0] as? String)!) {
                Constants.TEAMREDLIST.remove(at: index)
            }
            self.checkForHostPlayer()
        }
        //No team list
        socket.on(Constants.EMIT_VALUES.getTeamMidden.rawValue){data, ack in
            //Removes player from both list
            //Check if other list contains player and delete it
            if let index = Constants.TEAMBLUELIST.index(of: (data[0] as? String)!) {
                Constants.TEAMBLUELIST.remove(at: index)
            }
            
            //Check if other list contains player and delete it
            if let index = Constants.TEAMREDLIST.index(of: (data[0] as? String)!) {
                Constants.TEAMREDLIST.remove(at: index)
            }
            
            self.checkForHostPlayer()
        }
        
        //Ready after name
        socket.on(Constants.EMIT_VALUES.getPlayerReady.rawValue){data, ack in
            
            for i in 0...Constants.TEAMBLUELIST.count - 1{
                if(Constants.TEAMBLUELIST[i] == (data[0] as? String)!){
                    Constants.TEAMBLUELIST[i].append(" (Ready)")
                }
            }
            for i in 0...Constants.TEAMREDLIST.count - 1{
                if(Constants.TEAMREDLIST[i] == (data[0] as? String)!){
                    Constants.TEAMREDLIST[i].append(" (Ready)")
                }
            }
            //self.updatePlayerList()
            self.checkForHostPlayer()
        }
        
        //Set the host palyer
        socket.on(Constants.EMIT_VALUES.getHost.rawValue){data, ack in
            Constants.HOST_PLAYER = (data[0] as? String)!
            
            print("wqw:   \(data[0] as? String)!")
            print("wqw:   \(Constants.HOST_PLAYER)")
        }
        
        socket.on("startGameOnAppleTV") {data, ack in
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    
    func checkForHostPlayer(){
       /* if(Constants.TEAMBLUELIST.count > 0){
        for i in 0...Constants.TEAMBLUELIST.count - 1{
            if(Constants.TEAMBLUELIST[i] == Constants.HOST_PLAYER){
                Constants.TEAMBLUELIST[i].append(" (Host)")
            }
        }}
        if(Constants.TEAMREDLIST.count > 0){
        for i in 0...Constants.TEAMREDLIST.count - 1{
            if(Constants.TEAMREDLIST[i] == Constants.HOST_PLAYER){
                Constants.TEAMREDLIST[i].append(" (Host)")
            }
            }}
        */
        updatePlayerList()
    }
    
    func updatePlayerList(){
        //Updates both player lists!
        self.blueList.text = "Team Blue: \n"
        self.redList.text = "Team Red: \n"
        
        
        for players in Constants.TEAMBLUELIST{
            self.blueList.text.append("\(players) \n")
            print("list: blue: " + players)
        }
        for players in Constants.TEAMREDLIST{
            self.redList.text.append("\(players) \n")
            print("list: red: " + players)
        }
    }
    
    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 400, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightMedium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 320, height: 50)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.addSubview(activityIndicator)
        effectView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
//    @IBAction func btnJoin(_ sender: Any) {
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! UINavigationController
//        self.present(vc, animated: true, completion: nil)
//
//    }
    
}
