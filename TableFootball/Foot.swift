//
//  Foot.swift
//  Testball
//
//  Created by HuubvandeHoef on 3/14/17.
//  Copyright © 2017 HuubvandeHoef. All rights reserved.
//

import Foundation
import SpriteKit

class Foot: SKSpriteNode{
    
    //offsets of the foot
    var offset:CGFloat = 0
    var maxOffset:CGFloat = 0
    var minOffset:CGFloat = 0
    
    
    var counter = 60
    
    var rest:Bool = false
    var arrived:Bool = false
    
    var sensitivity:CGFloat = 10
    
    //Basic vars for the foot
    var startPos:CGFloat = 0
    var maxSpeed:CGFloat = 10
    
    //SpeedValue
    var lastSpeed:[CGFloat] = []
    var speedCounter:Int = 0
    
    let theFoot = SKSpriteNode(imageNamed: "")
    let theHead = SKSpriteNode(imageNamed: "")
    
    var positionOnStick:CGFloat = 0
    var maxOffsets:CGFloat = 0
    var playerImages:[String] = ["","","","",""]
    
    
    func Init(postionX: CGFloat, positionY: CGFloat, size: CGSize, name:String, colorSprite:String, gameScene: GameScene, maxOffset: CGFloat){
        
        //Create Cube as a Foot
        // let theFoot = SKSpriteNode(imageNamed: "red")
        theFoot.texture = SKTexture(imageNamed: colorSprite)
        theFoot.size = CGSize(width: 25, height: 50)
        theFoot.position.x = postionX
        theFoot.position.y = positionY
        theFoot.physicsBody = SKPhysicsBody(rectangleOf: theFoot.frame.size)
        theFoot.physicsBody?.allowsRotation = false
        theFoot.physicsBody?.affectedByGravity = false
        //theFoot.physicsBody?.isDynamic = true
        theFoot.physicsBody?.mass = 50
        theFoot.physicsBody?.isDynamic = true
        theFoot.name = "foot"
        theFoot.zPosition = 0
        theFoot.alpha = 0
        gameScene.addChild(theFoot)
        
        if(colorSprite == "red"){
            //Get red team
            for i in 0...4{
            playerImages[i] = "PlayerRed" + String(i + 1)
            }
        }else{
            //Get blue team
            for i in 0...4{
                playerImages[i] = "Player" + String(i + 1)
            }
        }
        
        //Draw the head/Player
        theHead.texture = SKTexture(imageNamed: playerImages[0])
        theHead.zPosition = 1
        theHead.position = theFoot.position
        theHead.size = CGSize(width: theHead.size.width, height: 65)
        gameScene.addChild(theHead)
        
        rest = true
        
        positionOnStick = 0 + theFoot.position.y
        maxOffsets = maxOffset/2
        speedCounter = 0
        
        //Set value per position
        startPos = theFoot.position.x
    }
    
    func drawHead(sprite:String, isFliped: Bool){
         theHead.texture = SKTexture(imageNamed: sprite)
        
        if(isFliped){
            theHead.size = CGSize(width: (theHead.texture?.size().width)!/3, height: 65)
        }else{
            theHead.size = CGSize(width: ((theHead.texture?.size().width)!/3) * -1, height: 65)
        }
        
    }
    
    func clampFoots(){
        //clamp foot
        if(theFoot.position.x > startPos + maxOffsets){
            theFoot.physicsBody?.velocity.dx = 0
            theFoot.position.x = startPos + maxOffsets - 1
        }
        if(theFoot.position.x < startPos - maxOffsets){
            theFoot.physicsBody?.velocity.dx = 0
            theFoot.position.x = startPos - maxOffsets - 1
        }
        //<--- End Clamp ---->
    }
    
    func centreFoots(){
        //Return to centre
            //theFoot.physicsBody?.applyImpulse(CGVector(dx:(startPos - theFoot.position.x)*100 , dy:0))
        theFoot.physicsBody?.velocity.dx += (startPos - theFoot.position.x) * 1
        theFoot.physicsBody?.velocity.dx *= CGFloat(0.9)
    }
    
    var imageCounter:Int = 0
    func animatePlayer(relativePosition: CGFloat){
        
        print("rel: \(relativePosition)")
        print("img: \(imageCounter)")
        var flipped:Bool = true
        //-55 & plus 55
        
        
        if(relativePosition > 0){
            
            //Check if image must be flipped or not
            flipped = true
            
            //check which image needs to be displayed
            if(relativePosition > 40){
                imageCounter = 4
            }else if(relativePosition > 30){
                imageCounter = 3
            }else if(relativePosition > 20){
                imageCounter = 2
            }else if(relativePosition > 10){
                imageCounter = 1
            }else {
                //Need fix
            }
            
        }
        
        if(relativePosition < 0){
            //check if flipped of not
            flipped = false
            
            //And the other wat around
            if(relativePosition < -40){
                imageCounter = 4
            }else if(relativePosition < -30){
                imageCounter = 3
            }else if(relativePosition < -20){
                imageCounter = 2
            }else if(relativePosition < -10){
                imageCounter = 1
            }else {
                //Need fix
            }
        }
        if(relativePosition < 10 && relativePosition > -10){
            imageCounter = 0
        }
        drawHead(sprite: playerImages[imageCounter], isFliped: flipped)
    }
    
    func addImpulse(length: CGFloat){
        theFoot.physicsBody?.applyForce(CGVector(dx:length * 80, dy:0 ))
    }
    
    func update(swipeLength: CGFloat, positionY: CGFloat){
        let _:CGFloat = swipeLength
        
        theFoot.position.y = positionOnStick + positionY
        theHead.position.y = theFoot.position.y
        
        animatePlayer(relativePosition: (startPos - theFoot.position.x))
        clampFoots()
        centreFoots()
    }
    
}
