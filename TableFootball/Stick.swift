//
//  Stick.swift
//  Testball
//
//  Created by HuubvandeHoef on 3/15/17.
//  Copyright © 2017 HuubvandeHoef. All rights reserved.
//

import Foundation
import SpriteKit

class Stick: SKSpriteNode{
    
    var theFoots = [Foot()]
    var amount:Int = 0
    
    var counter = 20
    var timer = 0
    var mcounter = 20
    var diff:CGFloat = 1
    
    var positionY:CGFloat = 0
    var footPositionX:CGFloat = 0
    
    
    func Init(amountOfFeets: Int, positionX: CGFloat, gameScene: GameScene, sprite: String ){
        position.y = 0
        
        //Get data from socket
        let socket = SocketIOManager.sharedInstance.getSocket();
        socket.on("getPositionY") {data, ack in
            print(data)
            self.positionY = (data[0] as? CGFloat)!
        }
        socket.on("getPositionX") {data, ack in
            print(data)
            self.footPositionX = (data[0] as? CGFloat)!
        }
        
        //Make amount of feets
        amount = amountOfFeets - 1
        
        //Forloop which makes all the foots
        //Needs to be better.
        for i in 0...amount{
            if(i == 0){
                theFoots[i].Init(postionX: position.x, positionY: 0, size: CGSize(width: 40, height: 80), name: "firstfoot", colorSprite: sprite, gameScene: gameScene)
            }else{
                theFoots.append(Foot())
                theFoots[i].Init(postionX: position.x, positionY: 120, size: CGSize(width: 40, height: 80), name: "SecondFoot", colorSprite: sprite, gameScene: gameScene)
            }
        }
    }
    
    
    func update(){
        //Update each foot of this stick
        for i in 0...amount{
            theFoots[i].update(baseStick: self, direction: CGVector(dx: footPositionX, dy: positionY))
        }
        
        //Update the stick self
        //position.y = (self.positionY)
       // body.velocity = CGVector(0, self.positionY);
        
    }
}
