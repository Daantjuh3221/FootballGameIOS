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
    
    
    let theFoot = SKSpriteNode(imageNamed: "")
    
    var positionOnStick:CGFloat = 0
    
    func Init(postionX: CGFloat, positionY: CGFloat, size: CGSize, name:String, colorSprite:String, gameScene: GameScene){
        
        //Create Cube as a Foot
        // let theFoot = SKSpriteNode(imageNamed: "red")
        theFoot.texture = SKTexture(imageNamed: colorSprite)
        theFoot.size = CGSize(width: 40, height: 80)
        theFoot.position.x = postionX
        theFoot.position.y = positionY
        theFoot.physicsBody = SKPhysicsBody(rectangleOf: theFoot.frame.size)
        theFoot.physicsBody?.allowsRotation = false
        theFoot.physicsBody?.affectedByGravity = false
        theFoot.physicsBody?.isDynamic = true
        theFoot.physicsBody?.mass = 50
        theFoot.name = name
        gameScene.addChild(theFoot)
        
        
        //Set value per position
        startPos = theFoot.position.x
        maxOffset = startPos + 50
        rest = true
        
        positionOnStick = 0 - theFoot.position.y
    }
    
    func shootLeft(){
        
    }
    
    func shootRight(){
        
    }
    
    func update(baseStick: Stick, direction: CGVector){
        
        theFoot.position.x = startPos + direction.dx
        theFoot.position.y = positionOnStick + direction.dy
        
        
        /*
        var goalPosition:CGVector = CGVector(dx:theFoot.position.x + direction.dx , dy: theFoot.position.y + direction.dy)
        
        var forceGiven:CGVector = CGVector(dx: goalPosition.dx - direction.dx , dy: goalPosition.dy - direction.dy)
        theFoot.physicsBody?.applyForce(forceGiven)
        */
        
        //theFoot.position.x = startPos + rotation
        theFoot.physicsBody?.velocity.dx =  direction.dx * sensitivity
        
        if(theFoot.position.x > startPos + 90){
            theFoot.position.x = startPos + 90
            
            if((theFoot.physicsBody?.velocity.dx)! > 0){
                theFoot.physicsBody?.velocity.dx = 0
            }
        }
        if(theFoot.position.x < startPos - 90){
            theFoot.position.x = startPos - 90
            
            if((theFoot.physicsBody?.velocity.dx)! < 0){
                theFoot.physicsBody?.velocity.dx = 0
            }
        }
        
        theFoot.physicsBody?.velocity.dy = direction.dy
        //Make vertical movement possible
        //theFoot.position.y = baseStick.position.y + positionOnStick
        //theFoot.physicsBody?.velocity.dy =  baseStick.position.y

    }
    
}
