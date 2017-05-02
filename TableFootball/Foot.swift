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
        theFoot.physicsBody?.isDynamic = false
        theFoot.name = "foot"
        gameScene.addChild(theFoot)
        
        drawHead(sprite: colorSprite, gameScene: gameScene)
        
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
    
    func drawHead(sprite:String, gameScene: GameScene){
        theHead.texture = SKTexture(imageNamed: sprite)
        theHead.position = theFoot.position
        theHead.size = CGSize(width: 35, height: 65)
        
        gameScene.addChild(theHead)
    }
    
    
    func update(swipeLength: CGFloat){

        //Set foot back to its centre
        if(theFoot.position.x > startPos){
            //Go left
            theFoot.physicsBody?.velocity.dx = -5
        }else if(theFoot.position.x < startPos){
            //Go right
            theFoot.physicsBody?.velocity.dx = 5
        }
        
        //Apply impulse to the foot
        theFoot.physicsBody?.applyImpulse(CGVector(dx:swipeLength , dy:0 ))
        
        //The head. Later needs to be animation!
        theHead.position.y = theFoot.position.y

    }
    
}
