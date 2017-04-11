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
        socket.on("getPositionYforAppleTV") {data, ack in
           // print(data)
            self.positionY = (data[0] as? CGFloat)!
        }
        socket.on("getPositionXforAppleTV") {data, ack in
           // print(data)
            self.footPositionX = (data[0] as? CGFloat)!
        }
        
        //Make amount of feets
        amount = amountOfFeets - 1
        
        makeFoots(amount: amount, gameScene: gameScene, sprite: sprite)
    }
    
    func makeFoots(amount: Int, gameScene: GameScene, sprite: String ){
        
        switch amount{
        case 0:
            for i in 0...amount{
                theFoots[i].Init(postionX: position.x, positionY: 0, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene)
            }
            break;
        case 1:
            for i in 0...amount{
                if(i == 0){
                theFoots[i].Init(postionX: position.x, positionY: 92, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene)
                } else {
                    theFoots.append(Foot())
                    theFoots[i].Init(postionX: position.x, positionY: -92, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene)
                }
            }
        case 2:
            for i in 0...amount{
                if(i == 0){
                    theFoots[i].Init(postionX: position.x, positionY: 0, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene)
                } else{
                    theFoots.append(Foot())
                    if(i == 1){
                        theFoots[i].Init(postionX: position.x, positionY: -180, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene)
                    }else{
                        theFoots[i].Init(postionX: position.x, positionY: 180, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene)
                    }
                }
            }
            break;
        default:
            for i in 0...amount{
                theFoots[i].Init(postionX: position.x, positionY: 0, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene)
            }
            break;
        }
    }
    
    func update(){
        //Update each foot of this stick
        for i in theFoots{
            i.update( direction: CGVector(dx: footPositionX, dy: positionY))
        }
    }
}
