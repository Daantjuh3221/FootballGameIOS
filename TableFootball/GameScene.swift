//
//  GameScene.swift
//  Testball
//
//  Created by HuubvandeHoef on 3/14/17.
//  Copyright © 2017 HuubvandeHoef. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let socket = SocketIOManager.sharedInstance.getSocket();
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var canvas:SKSpriteNode = SKSpriteNode()
    
    //Create the vartiables
    var theBall:Ball = Ball()
    
    //GameRules
    var scoreLimit:Int = 10;
    
    let goalShake:ScreenShake = ScreenShake()
    
    let gameCamera:SKCameraNode = SKCameraNode()
    
    
    
    //set sticks  on or of (1, 2, 3, 4, 5, 6, 7, 8)th Stcick
    //<---- All value for the sticks, counting left to right, Excluding the first ---->
    var sticks:[Stick] = []
    var stickEnabled:[Bool] = [true, true, true, true, true, true ,true, true]
    var stickPositions:[Int] = [-390, -280, -170, -60, 60, 170, 280, 390]
    var stickColor:[String] = ["red", "red", "blue", "red", "blue", "red", "blue", "blue"]
    var userNames:[String] = ["", "", "", "", "", "", "", ""]
    var amountOfFeets:[Int] = [1, 2, 3, 5, 5, 3, 2, 1]

    
    //Lists of both teams
    var teamBlue:[String] = []
    var teamRed:[String] = []
    
    override func didMove(to view: SKView) {
        print(Constants.TEAMRED)
        print(Constants.TEAMBLUE)
        
        addChild(gameCamera)
        camera = gameCamera
        
        goalShake.Init(thisCamera: gameCamera, duration: 30, intensity: 50)
        
        //<---Team divide and stick devide! ---->
        for i in 0...7{
                if(stickColor[i] == "red"){
                    //Team red
                    if(Constants.TEAMRED.count > 0){
                    userNames[i] = Constants.TEAMRED[0]
                    }
                }else{
                    //Team blue
                    if(Constants.TEAMBLUE.count > 0){
                    userNames[i] = Constants.TEAMBLUE[0]
                    }
            }
        }
        
        print(userNames)
        
        
        physicsWorld.contactDelegate = self
        
        //Init the ball
        //<-----! The Ball acts as the referee !----->
        if(self.childNode(withName: "ball") != nil){
            theBall = self.childNode(withName: "ball") as! Ball
            theBall.Init(gamescene: self, scoreLimit: scoreLimit)
        }
        
//        //Username list must be equal to list send to server!
//        //To-Do code here
//        let socket = SocketIOManager.sharedInstance.getSocket();
//        socket.on("") {data, ack in
//            //teamRed = socketTeamRed
//            //teamBlue = socketTeamBlue
//        }
        
        for i in 0...7{
            //Makes all sticks
            //Using the arrays made above
                sticks.append(Stick())
                if(stickEnabled[i]){
                if(self.childNode(withName: "stick0" + String(i + 1)) != nil){
                    sticks[i] = self.childNode(withName: "stick0" + String(i + 1)) as! Stick
                    sticks[i].Init(amountOfFeets: amountOfFeets[i], positionX: CGFloat(stickPositions[i]), gameScene: self, sprite:stickColor[i], userName:userNames[i], footName: "foot" + String(i + 1))
                    }}else{
                    //Makes unused sticks invisible
                    self.childNode(withName: "stick0" + String(i + 1))?.alpha = 0
            }
        }
    }// End did move
    
    override func sceneDidLoad() {
        
 
    }
    
    //<---- Detects collision between objects ---->
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        switch contact.bodyA.node?.name {
        case "ball"?:
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            break;
        case "cube"?:
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            break;
        default:
            firstBody = contact.bodyB
            secondBody = contact.bodyA
            
            if(secondBody.node?.name == "ball"){
                secondBody = firstBody
                firstBody = contact.bodyB
            }
            break;
        }
    
        //Apply tthe collision with the walls
        if(firstBody.node?.name == "ball" && secondBody.node?.name == "wall"){
            theBall.collidesWithWallVertical(wallPosition: secondBody.node!.position.x, currentTouch: "wall")
        } else
        if(firstBody.node?.name == "ball" && secondBody.node?.name == "walls"){
           // print("wallBEFOREBEFORE \(firstBody.node?.physicsBody?.velocity.dy)")
            
            theBall.collidesWithWallHorizintal(wallPosition: secondBody.node!.position.y, currentTouch: "wall")
        }
        //Check if there is made a goal
        if(firstBody.node?.name == "ball" && secondBody.node?.name == "goal"){
            theBall.didScored()
        }
        
        if((firstBody.node?.name?.contains("foot"))! && secondBody.node?.name == "ball"){
            //fixes the collision between foot and ball
            theBall.collidesWithFoot(currentTouch: (firstBody.node?.name)!)
            
        }else if(firstBody.node?.name == "ball" && (secondBody.node?.name?.contains("foot"))!){
            //fixes the collision between foot and ball
            theBall.collidesWithFoot(currentTouch: (secondBody.node?.name)!)
        }
        
        
    }//End collision
    
    
    override func update(_ currentTime: TimeInterval) {
        //Update all objects
        if(theBall.isScored && theBall.isGoalAllowed()){
            goalShake.StartShake()
            print("Shake")
        }
        for i in sticks{
            i.update()
        }
        theBall.update()
        goalShake.Shake()
    }//End Update
}
