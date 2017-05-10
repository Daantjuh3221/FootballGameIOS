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
    var goalCounter:Int = 20
    var isPlaying:Bool = false
    
    //sound effects
    //let sound01 = SKAction.playSoundFileNamed("186469__paskis3__shot-soocer-table", waitForCompletion: false)
    var soundSoftBounce:[SKAction] = []
    var cheerSound:[SKAction] = []
    
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
        
        getSound()
        
        position = CGPoint(x:-12000, y:12000)
        
        score.Init(gamescene: gamescene, _scoreLimit: scoreLimit)
    }
    
    func getSound(){
        //get the soft bounce
        for i in 0...9{
            soundSoftBounce.append(SKAction.playSoundFileNamed("bounce0" + String(i + 1) + ".wav", waitForCompletion: false))
        }
        cheerSound.append(SKAction.playSoundFileNamed("cheering.mp3", waitForCompletion: false))
        
    }
    
    func didScored(){
        isScored = true
        run(cheerSound[0])
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
        playerBounceSound()
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
        playerBounceSound()
    }
    
    func collidesWithFoot(){
        //Play sound
        playerBounceSound()
    }
    
    
    
    func playerBounceSound(){
        let randomSound:Int = Int(arc4random_uniform(10))
        run(soundSoftBounce[randomSound])
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
        //Checks if is scored, adds score and resets the ball
        if(isScored){
            isScored = false
            if(position.x < 0){
                //Left scored (Blue)
                score.blueScored()
            }
            else{
                //Right Scored (Red)
                score.redScores()
            }
            checkIfWon()
            
            //Get ball out of screen and set timer to 80
            position = CGPoint(x:-12000, y:-12000)
            physicsBody?.velocity.dy = 0
            physicsBody?.velocity.dx = 0
            goalCounter = 80
            isPlaying = false
        }
        
        
        if(goalCounter >= 0){
            goalCounter -= 1
        }

        if(!isPlaying && goalCounter <= 1){
            isPlaying = true
            position = CGPoint(x:0, y :260)
            physicsBody?.velocity.dx = 0
            physicsBody?.velocity.dy = -100
        }
        //Check if splash screen needs to fade & fade if needed
        if(!score.hasWon){
            if(score.scoreLBL.alpha > 0){
                score.scoreLBL.alpha -= 0.01
                score.scoreLBLShadow.alpha -= 0.01
            }
            if(score.winLabel.alpha > 0){
                score.winLabel.alpha -= 0.01
                score.winLabelShadow.alpha -= 0.01
            }
        }else{
            position = CGPoint(x:-12000, y:-12000)
            physicsBody?.velocity.dy = 0
            physicsBody?.velocity.dx = 0
        }
        
        //Makes the ball rotate
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

