//
//  Ball.swift
//  Testball
//
//  Created by HuubvandeHoef on 3/14/17.
//  Copyright © 2017 HuubvandeHoef. All rights reserved.
//

import Foundation
import SpriteKit

class Ball: SKSpriteNode {
    
    var isScored:Bool = false
    var isShot:Bool = false
    var score:Score = Score()
    
    var ballSpeed:CGFloat = 3
    
    var touchFoot:SKNode = SKNode()
    var footNode:Foot = Foot()
    
    func Init(gamescene:GameScene, scoreLimit: Int){
        //Initialize the ball here
        let imageTexture = SKTexture(imageNamed: "ballSprite")
        name = "ball"
        
        let body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: imageTexture.size().width/2)
        body.isDynamic = true
        body.affectedByGravity = true;
        body.allowsRotation = true;
        body.mass = 0.2
        body.categoryBitMask = 1
        body.contactTestBitMask = 2
        
        position = CGPoint(x:300, y:0)
        
        score.Init(gamescene: gamescene, _scoreLimit: scoreLimit)
    }
    
    func didScored(){
        isScored = true
       // print("Goal")
    }
    
    func collidesWithWallVertical(){
        physicsBody?.velocity.dy *= -1
    }
    
    func collidesWithWallHorizintal(){
        physicsBody?.velocity.dx *= -1
    }
    
    func collidesWithFoot(foot: SKNode){
        isShot = true
        touchFoot = foot
        
    }
    
    func checkIfWon(){
        if(score.hasWon){
            //Some one won
            if(score.winnerRed){
                //Red has won
            }else {
                //blue has Won
            }
            alpha = 0
            
            physicsBody?.velocity.dy = 0
            physicsBody?.velocity.dx = 0
        }
    }
    
    func update(){
        if(isScored){
            isScored = false
            if(position.x < 0){
                //Left scored (Blue)
                score.blueScored()
                position = CGPoint(x:-220, y:0)
            }
            else{
                //Right Scored (Red)
                score.redScores()
                position = CGPoint(x:220, y:0)
            }
            checkIfWon()
            //Set velocity to 0
            physicsBody?.velocity.dy = 0
            physicsBody?.velocity.dx = 0
            
        }
        
        if(isShot){
            isShot = false
            let direction:CGVector = CGVector(dx: (position.x - (touchFoot.position.x)) * 3, dy: (position.y - (touchFoot.position.y)) * 3)
            
            physicsBody?.applyForce(direction)
        }
    }
}

