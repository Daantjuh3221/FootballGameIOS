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
    
    var rotationSpeed:CGFloat = 0
    
    func Init(gamescene:GameScene, scoreLimit: Int){
        //Initialize the ball here
        let imageTexture = SKTexture(imageNamed: "ballSprite")
        name = "ball"
        
        let body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: imageTexture.size().width/2)
        body.isDynamic = true
        body.affectedByGravity = false;
        body.allowsRotation = true;
        body.mass = 0.2
        body.categoryBitMask = 1
        body.contactTestBitMask = 2
        body.restitution = 0
        
        position = CGPoint(x:300, y:0)
        
        score.Init(gamescene: gamescene, _scoreLimit: scoreLimit)
    }
    
    func didScored(){
        isScored = true
       // print("Goal")
    }
    
    func collidesWithWallVertical(wallPosition: CGFloat){
        
        physicsBody!.velocity.dx = 0
        var tempForce = 0
        
        if(wallPosition > 0){
            tempForce = (-1 * 20)
        }else{
            tempForce = 20
        }
        physicsBody!.applyImpulse(CGVector(dx:tempForce, dy: 0))
    }
    
    func collidesWithWallHorizintal(wallPosition: CGFloat){
        
        physicsBody!.velocity.dy = 0
        var tempForce = 0
        
        if(wallPosition > 0){
        tempForce = (-1 * 20)
        }else{
            tempForce = 20
        }
        
        physicsBody!.applyImpulse(CGVector(dx:0, dy: tempForce))
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
                position = CGPoint(x:-300, y:0)
            }
            else{
                //Right Scored (Red)
                score.redScores()
                position = CGPoint(x:300, y:0)
            }
            checkIfWon()
            //Set velocity to 0
            physicsBody?.velocity.dy = 0
            physicsBody?.velocity.dx = 0
        }
        if((physicsBody?.velocity.dy)! > CGFloat(0) || (physicsBody?.velocity.dy)! < CGFloat(0)){
            if((physicsBody?.velocity.dx)! > CGFloat(0) || (physicsBody?.velocity.dx)! < CGFloat(0)){
            //rotate sprite
                rotationSpeed += (physicsBody?.velocity.dx)! - (physicsBody?.velocity.dy)!
                if(rotationSpeed > 360){
                    rotationSpeed = -300
                }
                self.zRotation = rotationSpeed
                
            }}
    }
}

