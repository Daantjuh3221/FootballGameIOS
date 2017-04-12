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
        body.restitution = 0
        
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
    
    func normalizeVector(vector:CGVector) -> CGVector{
        let vectorLength:CGFloat = sqrt((vector.dx * vector.dx) + (vector.dy * vector.dy))
        
       // var normalizedVector:CGVector = (1/vectorLength) * vector
        
        let normalizedVector:CGVector = CGVector(dx: ((1/vectorLength) * vector.dx), dy:((1/vectorLength) * vector.dy))
        
        return normalizedVector
    }
    
    func handleBallToFootCollision(){
        var positionDiff:CGVector = CGVector(dx:0,dy:0)
        positionDiff.dx = position.x - touchFoot.position.x
        positionDiff.dy = position.y - touchFoot.position.y
        
        var collisionNormal = positionDiff
        collisionNormal = normalizeVector(vector: collisionNormal)
        
        var resetVector:CGVector = collisionNormal
        position.x -= resetVector.dx/2
        position.y -= resetVector.dy/2
        
        var velDiff:CGVector = CGVector(dx:0,dy:0)
        //(self.physicsBody?.velocity)! - touchFoot.physicsBody?.velocity
        velDiff.dx = (self.physicsBody?.velocity.dx)! - (touchFoot.physicsBody?.velocity.dx)!
        velDiff.dy = (self.physicsBody?.velocity.dy)! - (touchFoot.physicsBody?.velocity.dy)!
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
            handleBallToFootCollision()
        }
    }
}

