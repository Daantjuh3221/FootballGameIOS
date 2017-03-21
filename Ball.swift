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
    
    func Init(){
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
        
        position = CGPoint(x:220, y:0)
    }
    
    func didScored(){
        physicsBody?.velocity.dy = 0
        physicsBody?.velocity.dx = 0
        
       // position = CGPoint(x:220, y:0)
        
        self.position = CGPoint(x:220, y:0)
        print("Goal")
    }
    
    func collidesWithWallVertical(){
        physicsBody?.velocity.dy *= -1
        print("Boem")
    }
    
    func collidesWithWallHorizintal(){
        physicsBody?.velocity.dx *= -1
        print("Boem")
    }
    
    func update(){
        
    }
}

