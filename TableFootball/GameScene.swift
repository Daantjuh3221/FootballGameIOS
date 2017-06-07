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
    var scoreLimit:Int = Constants.SCORELIMIT;
    
    let goalShake:ScreenShake = ScreenShake()
    
    let gameCamera:SKCameraNode = SKCameraNode()
    
    var gameOverCounter = Constants.GAMEOVER_COUNTER
    
    // we need to make sure to set this when we create our GameScene
    var viewController: GameViewController!
    
    //set sticks  on or of (1, 2, 3, 4, 5, 6, 7, 8)th Stcick
    //<---- All value for the sticks, counting left to right, Excluding the first ---->
    var sticks:[Stick] = []
    var stickEnabled:[Bool] = [true, true, true, true, true, true ,true, true]
    var stickPositions:[Int] = Constants.STICK_POSITION
    var stickColor:[String] = Constants.STICK_COLOR
    var stickOffset:[CGFloat] = Constants.STICK_OFFSET
    var userNames:[String] = ["", "", "", "", "", "", "", ""]
    var amountOfFeets:[Int] = Constants.STICK_AMOUNT_OF_FEETS

    
    //Lists of both teams
    var teamBlue:[String] = []
    var teamRed:[String] = []
    
    override func didMove(to view: SKView) {
        //print("team:  \(Constants.TEAMRED)")
        //print("team:  \(Constants.TEAMBLUE)")
        
        addChild(gameCamera)
        camera = gameCamera
        
        goalShake.Init(thisCamera: gameCamera, duration: 30, intensity: 50)
        
        //<---Team divide and stick devide! ---->
        for i in 0...7{
                if(stickColor[i] == Constants.TEAM.red.rawValue){
                    //Team red
                    if(Constants.TEAMRED.count > 0 && Constants.TEAMRED.count < 2){
                        //If one player is connected
                    userNames[i] = Constants.TEAMRED[0]
                    }else if(Constants.TEAMRED.count > 1 && Constants.TEAMRED.count < 3){
                        //if 2 players are connected
                        if(i < 3){
                            //Defender
                            userNames[i] = Constants.TEAMRED[0]
                        }else{
                            //Attacker
                            userNames[i] = Constants.TEAMRED[1]
                        }
                    }else if (Constants.TEAMRED.count > 1){
                        //If more than 2 players are connected
                        if(i < 3){
                            //Defender
                            userNames[i] = Constants.TEAMRED[0]
                        }else{
                            //Attacker
                            userNames[i] = Constants.TEAMRED[1]
                        }
                        //<--- Max players is 2 for now ---->
                    }
                }else{
                    //Team blue
                    if(Constants.TEAMBLUE.count > 0 && Constants.TEAMBLUE.count < 2){
                        //If 1 player is connected
                    userNames[i] = Constants.TEAMBLUE[0]
                    }else if(Constants.TEAMBLUE.count > 1 && Constants.TEAMBLUE.count < 3){
                        //if 2 players are connected
                        if(i < 5){
                            //Attackers
                            userNames[i] = Constants.TEAMBLUE[0]
                        }else{
                            //Defenders
                            userNames[i] = Constants.TEAMBLUE[1]
                        }
                    }else if(Constants.TEAMBLUE.count > 2){
                        //If more than 2 players
                        if(i < 5){
                            //Attackers
                            userNames[i] = Constants.TEAMBLUE[0]
                        }else{
                            //Defenders
                            userNames[i] = Constants.TEAMBLUE[1]
                        }
                        //<--- Max players is 2 for now ---->
                    }
            }
        }
        
        physicsWorld.contactDelegate = self
        
        //Init the ball
        //<-----! The Ball acts as the referee !----->
      //  if(self.childNode(withName: Constants.BALL_NAME) != nil){
            theBall = self.childNode(withName: Constants.BALL_NAME) as! Ball
            theBall.Init(gamescene: self, scoreLimit: scoreLimit)
       // }
        
        
        for i in 0...7{
            //Makes all sticks
            //Using the arrays made above
                sticks.append(Stick())
                if(stickEnabled[i]){
                if(self.childNode(withName: Constants.STICKNAMES.neutral.rawValue + String(i + 1)) != nil){
                    sticks[i] = self.childNode(withName: Constants.STICKNAMES.neutral.rawValue + String(i + 1)) as! Stick
                    sticks[i].Init(amountOfFeets: amountOfFeets[i], positionX: CGFloat(stickPositions[i]), gameScene: self, sprite:stickColor[i], userName:userNames[i], footName: Constants.FOOT_NAME + String(i + 1), yOffset: stickOffset[i] )
                    }}else{
                    //Makes unused sticks invisible
                    self.childNode(withName: Constants.STICKNAMES.neutral.rawValue + String(i + 1))?.alpha = 0
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
        case Constants.BALL_NAME?:
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            break;
        case Constants.CUBE?:
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            break;
        default:
            firstBody = contact.bodyB
            secondBody = contact.bodyA
            
            if(secondBody.node?.name == Constants.BALL_NAME){
                secondBody = firstBody
                firstBody = contact.bodyB
            }
            break;
        }
    
        //Apply tthe collision with the walls
        if(firstBody.node?.name == Constants.BALL_NAME && secondBody.node?.name == Constants.WALL_NAME){
            theBall.collidesWithWallVertical(wallPosition: secondBody.node!.position.x, currentTouch: Constants.WALL_NAME)
        } else
        if(firstBody.node?.name == Constants.BALL_NAME && secondBody.node?.name == Constants.WALLS_NAME){
           // print("wallBEFOREBEFORE \(firstBody.node?.physicsBody?.velocity.dy)")
            
            theBall.collidesWithWallHorizintal(wallPosition: secondBody.node!.position.y, currentTouch: Constants.WALL_NAME)
        }
        //Check if there is made a goal
        if(firstBody.node?.name == Constants.BALL_NAME && secondBody.node?.name == Constants.GOAL_NAME){
            theBall.didScored()
        }
        
        if((firstBody.node?.name?.contains(Constants.FOOT_NAME))! && secondBody.node?.name == Constants.BALL_NAME){
            //fixes the collision between foot and ball
            theBall.collidesWithFoot(currentTouch: (firstBody.node?.name)!)
            
        }else if(firstBody.node?.name == Constants.BALL_NAME && (secondBody.node?.name?.contains(Constants.FOOT_NAME))!){
            //fixes the collision between ball and foot
            theBall.collidesWithFoot(currentTouch: (secondBody.node?.name)!)
        }
        
        
    }//End collision
    
    func goToHomeScreen(){
        //Switch to home screen and reset list
        self.viewController.goToHome()
        
        //reset game rules
        let socket = SocketIOManager.sharedInstance.getSocket();
        socket.emit(Constants.EMIT_VALUES.resetGame.rawValue)
    }
    
//    var i = 50
    override func update(_ currentTime: TimeInterval) {
        //Update all objects
//        i -= 1
//        if(i < 0){
//            goToHomeScreen()
//        }
       // print("IW: \(i)")
        //Start a screenshake
        if(theBall.isScored && theBall.isGoalAllowed()){
            goalShake.StartShake()
        }
        
        //Updates all sticks
        for i in sticks{
            i.update()
        }
        
        //Update the ball
        theBall.update()
        
        //Allows screenshake
        goalShake.Shake()
        
        //Check if game is won and go to home screen
        if(theBall.isGameOver()){
            gameOverCounter -= 1
            if(gameOverCounter < 1){
                //Go to home screen
                goToHomeScreen()
            }
        }
    }//End Update
}
