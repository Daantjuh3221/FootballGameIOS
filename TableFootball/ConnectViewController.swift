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
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var i:Int = 0
    
    @IBOutlet weak var lblJoinCode: UILabel!
    let userSettings = UserDefaults.standard
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        self.listConnectedPlayers.text.append("\n")
//        activityIndicator.center = self.view.center
//        activityIndicator.hidesWhenStopped = true
//        //activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        view.addSubview(activityIndicator)
//        
//        activityIndicator.startAnimating()
//        UIApplication.shared.beginIgnoringInteractionEvents()
        
        activityIndicator("Waiting for players...")
        
        let socket = SocketIOManager.sharedInstance.getSocket();
        socket.on("userJoinedAppleTV") {data, ack in
            Constants.CONNECTEDPLAYERS.append((data[0] as? String)!)
            
            self.listConnectedPlayers.text.append((data[0] as? String)!)
            self.listConnectedPlayers.text.append(",")
            
            self.i += 1
            self.strLabel.text = "Waiting for players. \(self.i) joined"
        }
        socket.on("getJoinCode") {data, ack in
            let joinCode:String = (data[0] as? String)!
            self.lblJoinCode.text = joinCode
            self.userSettings.set(joinCode, forKey: "joinCode")
        }
        
        socket.on("startGameOnAppleTV") {data, ack in
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
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
