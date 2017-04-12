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
    var userName = ""
    
    func Init(amountOfFeets: Int, positionX: CGFloat, gameScene: GameScene, sprite: String, userName:String ){
        position.y = 0
        position.x = positionX
        
        self.userName = userName
        
        //Get data from socket
        let socket = SocketIOManager.sharedInstance.getSocket();
        socket.on("getPositionYforAppleTV") {data, ack in
           // print(data)
            let inputUser = (data[1] as? String)!
            if(inputUser == userName){
                self.positionY = (data[0] as? CGFloat)!
            }
        }
        socket.on("getPositionXforAppleTV") {data, ack in
           // print(data)
            let inputUser = (data[1] as? String)!
            if(inputUser == userName){
            self.footPositionX = (data[0] as? CGFloat)!
            }
        }
        
        //Make amount of feets
        amount = amountOfFeets - 1
        
        makeFoots(amount: amount, gameScene: gameScene, sprite: sprite)
    }
    
    func makeFoots(amount: Int, gameScene: GameScene, sprite: String ){
        switch amount{
        case 0: // 1 foot
            for i in 0...amount{
                theFoots[i].Init(postionX: position.x, positionY: 0, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene, maxOffset: 266)
            }
            break;
        case 1: //2 foots
            for i in 0...amount{
                if(i == 0){
                    theFoots[i].Init(postionX: position.x, positionY: 92, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene, maxOffset: 92)
                } else {
                    theFoots.append(Foot())
                    theFoots[i].Init(postionX: position.x, positionY: -92, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene, maxOffset: 92)
                }
            }
        case 2: //3 foots
            for i in 0...amount{
                if(i == 0){
                    theFoots[i].Init(postionX: position.x, positionY: 0, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene,  maxOffset: 108)
                } else{
                    theFoots.append(Foot())
                    if(i == 1){
                        theFoots[i].Init(postionX: position.x, positionY: -180, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene,  maxOffset: 108)
                    }else{
                        theFoots[i].Init(postionX: position.x, positionY: 180, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene,  maxOffset: 108)
                    }
                }
            }
            break;
        case 4: // 5 foots
            for i in 0...amount{
                if(i == 0){
                    theFoots[i].Init(postionX: position.x, positionY: 0, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene,  maxOffset: 68)
                } else{
                    theFoots.append(Foot())
                    if(i == 1){
                        theFoots[i].Init(postionX: position.x, positionY: -220, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene,  maxOffset: 68)
                    }else if (i == 2){
                        theFoots[i].Init(postionX: position.x, positionY: 220, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene,  maxOffset: 68)
                    }else if(i == 3){
                        theFoots[i].Init(postionX: position.x, positionY: 110, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene,  maxOffset: 68)
                    }else{
                        theFoots[i].Init(postionX: position.x, positionY: -110, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene,  maxOffset: 68)
                    }
                }}
            break;
        default: // default 1 foot
            for i in 0...amount{
                theFoots[i].Init(postionX: position.x, positionY: 0, size: CGSize(width: 40, height: 80), name: "foot", colorSprite: sprite, gameScene: gameScene,  maxOffset: 266)
            }
            break;
        }
    }
    
    func update(){
        //Update each foot of this stick
        for i in theFoots{
            i.update( direction: CGVector(dx: footPositionX, dy: positionY))
        }
        print(userName)
    }
}
