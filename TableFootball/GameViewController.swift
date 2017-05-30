//
//  GameViewController.swift
//  TableFootball
//
//  Created by HuubvandeHoef on 3/21/17.
//  Copyright © 2017 HuubvandeHoef. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
                
                sceneNode.viewController = self
                
            }
        }
    }

    func goToHome(){
        //Go to join Screen
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ConnectViewController")  as! ConnectViewController
        self.present(vc, animated: true, completion: nil)
        
        //Clear listst
        Constants.TEAMBLUE.removeAll()
        Constants.TEAMRED.removeAll()
        Constants.TEAMREDLIST.removeAll()
        Constants.TEAMBLUELIST.removeAll()
        
        //Emit to the android phones to go back
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
