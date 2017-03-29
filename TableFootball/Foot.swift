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
    
    var positionOnStick:CGFloat = 0
    var maxOffsets:CGFloat = 0
    
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
        theFoot.physicsBody?.isDynamic = true
        theFoot.physicsBody?.mass = 50
        theFoot.name = "foot"
        gameScene.addChild(theFoot)
        
        
        //Set value per position
        startPos = theFoot.position.x
        
        rest = true
        
        positionOnStick = 0 + theFoot.position.y
        maxOffsets = maxOffset
        speedCounter = 0
        for i in 0...10{
            lastSpeed.append(CGFloat(i))
        }
    }
    
    func getSpeed() -> CGFloat{
        var speedGiven:CGFloat = 0
        for i in lastSpeed{
            speedGiven += i
        }
        return speedGiven/CGFloat(lastSpeed.count)
    }
    
    func update(direction: CGVector){

        var tempVector:CGVector = direction
        print("PosY: " + String(describing: tempVector.dy))
        
        //Clamp Foots
        /*
        if(tempVector.dy >  positionOnStick + maxOffsets){
            tempVector.dy = positionOnStick + maxOffsets
        }
        if(tempVector.dy <  positionOnStick - maxOffsets){
            tempVector.dy =   positionOnStick - maxOffsets
        }*/
        
        
        theFoot.position.x = startPos + tempVector.dx
        theFoot.position.y = positionOnStick + tempVector.dy
        
        
        /*
        if(speedCounter > 10){
            speedCounter = 0
        }
        
      //  lastSpeed[speedCounter] = theFoot.position.x
        print(getSpeed())
        speedCounter += 1*/
    }
    
}
