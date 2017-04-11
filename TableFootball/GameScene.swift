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
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var canvas:SKSpriteNode = SKSpriteNode()
    
    //GameRules
    var scoreLimit:Int = 5;
    
    
    //Create the vartiables
    var theBall:Ball = Ball()
    
    //set sticks  on or of (1, 2, 3, 4, 5, 6, 7, 8)th Stcick
    //<---- All value for the sticks, counting left to right, Excluding the first ---->
    var sticks:[Stick] = []
    var stickEnabled:[Bool] = [false, true, false, true, false, false, true ,false, true]
    var stickPositions:[Int] = [0, -340, -243, -146, -49, 49, 146, 243, 340]
    var stickColor:[String] = ["","red", "red", "blue", "red", "blue", "red", "blue", "blue"]
    var amountOfFeets:[Int] = [0, 1, 2, 3, 5, 5, 3, 2, 1]
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        //Init the ball
        //<-----! The Ball acts as the referee !----->
        if(self.childNode(withName: "ball") != nil){
            theBall = self.childNode(withName: "ball") as! Ball
            theBall.Init(gamescene: self, scoreLimit: scoreLimit)
        }
        
        /*
        for i in 0...8{
            if (i > 0){
                stickEnabled[i] = true
            }
        }
        */
        for i in 0...8{
            //Makes all sticks
                sticks.append(Stick())
                if(stickEnabled[i]){
                if(self.childNode(withName: "stick0" + String(i)) != nil){
                    sticks[i] = self.childNode(withName: "stick0" + String(i)) as! Stick
                    sticks[i].Init(amountOfFeets: amountOfFeets[i], positionX: CGFloat(stickPositions[i]), gameScene: self, sprite:stickColor[i])
                    }}
        }
    }
    
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
            theBall.collidesWithWallVertical()
        } else
        if(firstBody.node?.name == "ball" && secondBody.node?.name == "walls"){
            theBall.collidesWithWallHorizintal()
        }
        
        //Check if there is made a goal
        if(firstBody.node?.name == "ball" && secondBody.node?.name == "goal"){
            theBall.didScored()
        }
        
        //Check if a foot touches the ball
        if(firstBody.node?.name == "ball" && secondBody.node?.name == "foot"){
            theBall.collidesWithFoot(foot: secondBody.node!)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        //Update all objects
        for i in sticks{
            i.update()
        }
        theBall.update()
        
    }
    
    
}
