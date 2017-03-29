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
    
    //Create the vartiables
    var theBall:Ball = Ball()
    var stick01 = Stick()
    var stick02 = Stick()
    var stick03 = Stick()
    var stick04 = Stick()
    var stick05 = Stick()
    var stick06 = Stick()
    var stick07 = Stick()
    var stick08 = Stick()
    //set sticks  on or of (1, 2, 3, 4, 5, 6, 7, 8)th Stcick
    var stickEnabled:[Bool] = [true, false, false, false, false, false, false ,true]
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        //Init the ball
        if(self.childNode(withName: "ball") != nil){
            theBall = self.childNode(withName: "ball") as! Ball
            theBall.Init(gamescene: self)
        }
        
        //1
        if(stickEnabled[0]){
        if(self.childNode(withName: "stick01") != nil){
            stick01 = self.childNode(withName: "stick01") as! Stick
            stick01.Init(amountOfFeets: 1, positionX: -340, gameScene: self, sprite:"red")
            }}
        //2
        if(stickEnabled[1]){
        if(self.childNode(withName: "stick02") != nil){
            stick02 = self.childNode(withName: "stick02") as! Stick
            stick02.Init(amountOfFeets: 2, positionX: -243, gameScene: self, sprite:"red")
            }}
        //3
        if(stickEnabled[2]){
        if(self.childNode(withName: "stick03") != nil){
            stick03 = self.childNode(withName: "stick03") as! Stick
            stick03.Init(amountOfFeets: 3, positionX: -146, gameScene: self, sprite:"blue")
            }}
        //4
        if(stickEnabled[3]){
        if(self.childNode(withName: "stick04") != nil){
            stick04 = self.childNode(withName: "stick04") as! Stick
            stick04.Init(amountOfFeets: 5, positionX: -49, gameScene: self, sprite:"red")
            }}
        //5
        if(stickEnabled[4]){
        if(self.childNode(withName: "stick05") != nil){
            stick05 = self.childNode(withName: "stick05") as! Stick
            stick05.Init(amountOfFeets: 5, positionX: 49, gameScene: self, sprite:"blue")
            }}
        //6
        if(stickEnabled[5]){
        if(self.childNode(withName: "stick06") != nil){
            stick06 = self.childNode(withName: "stick06") as! Stick
            stick06.Init(amountOfFeets: 3, positionX: 146, gameScene: self, sprite:"red")
            }}
        //7
        if(stickEnabled[6]){
        if(self.childNode(withName: "stick07") != nil){
            stick07 = self.childNode(withName: "stick07") as! Stick
            stick07.Init(amountOfFeets: 2, positionX: 243, gameScene: self, sprite:"blue")
            }}
        //8
        if(stickEnabled[7]){
        if(self.childNode(withName: "stick08") != nil){
            stick08 = self.childNode(withName: "stick08") as! Stick
            stick08.Init(amountOfFeets: 1, positionX: 340, gameScene: self, sprite:"blue")
            }}
    }
    
    override func sceneDidLoad() {
        
    }
    
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
          //  theBall.collidesWithWallVertical()
        } else
        if(firstBody.node?.name == "ball" && secondBody.node?.name == "walls"){
          //  theBall.collidesWithWallHorizintal()
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
        if(stickEnabled[0]){stick01.update()}
        if(stickEnabled[1]){stick02.update()}
        if(stickEnabled[2]){stick03.update()}
        if(stickEnabled[3]){stick04.update()}
        if(stickEnabled[4]){stick05.update()}
        if(stickEnabled[5]){stick06.update()}
        if(stickEnabled[6]){stick07.update()}
        if(stickEnabled[7]){stick08.update()}
        theBall.update()
        
    }
    
    
}
