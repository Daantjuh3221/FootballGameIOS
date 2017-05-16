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
    
    var swipeLength:CGFloat = 0
    
    func Init(amountOfFeets: Int, positionX: CGFloat, gameScene: GameScene, sprite: String, userName:String ){
        //Begins in centre of screen,
        position.y = 0
        position.x = positionX
        
        self.userName = userName
        
        
        //Make amount of feets
        amount = amountOfFeets - 1
        
        makeFoots(amount: amount, gameScene: gameScene, sprite: sprite)
        
        //Get data from socket
        let socket = SocketIOManager.sharedInstance.getSocket();
        socket.on("getPositionYforAppleTV") {data, ack in
            //Get the Y position for the player
            let inputUser = (data[1] as? String)!
            if(inputUser == userName){
                self.positionY = (data[0] as? CGFloat)!
            }
        }
        socket.on("getPositionXforAppleTV") {data, ack in
           // print(data)
            let inputUser = (data[1] as? String)!
            if(inputUser == userName){
            self.swipeLength = (data[0] as? CGFloat)!
                print("swipe \(self.swipeLength)")
                //Gets the X swipe for the player
                //Call methode here
                for i in self.theFoots{
                    i.addImpulse(length: self.swipeLength)
                }
            }
        }
        
        //Swipe left of right
        //With the length of the swipe
        //Positive = right
        //negative = left
        // Swipelength bla bla bla
        
    }
    
    func makeFoots(amount: Int, gameScene: GameScene, sprite: String ){
        switch amount{
        case 0: // 1 foot
            for i in 0...amount{
                theFoots[i].Init(postionX: position.x, positionY: 0, size: Constants.FOOT_SIZE, name: "foot", colorSprite: sprite, gameScene: gameScene, maxOffset: 266)
            }
            break;
        case 1: //2 foots
            for i in 0...amount{
                if(i == 0){
                    theFoots[i].Init(postionX: position.x, positionY: 92, size: Constants.FOOT_SIZE, name: "foot", colorSprite: sprite, gameScene: gameScene, maxOffset: 92)
                } else {
                    theFoots.append(Foot())
                    theFoots[i].Init(postionX: position.x, positionY: -92, size: Constants.FOOT_SIZE, name: "foot", colorSprite: sprite, gameScene: gameScene, maxOffset: 92)
                }
            }
        case 2: //3 foots
            for i in 0...amount{
                if(i == 0){
                    theFoots[i].Init(postionX: position.x, positionY: 0, size: Constants.FOOT_SIZE, name: "foot", colorSprite: sprite, gameScene: gameScene,  maxOffset: 108)
                } else{
                    theFoots.append(Foot())
                    if(i == 1){
                        theFoots[i].Init(postionX: position.x, positionY: -180, size: Constants.FOOT_SIZE, name: "foot", colorSprite: sprite, gameScene: gameScene,  maxOffset: 108)
                    }else{
                        theFoots[i].Init(postionX: position.x, positionY: 180, size: Constants.FOOT_SIZE, name: "foot", colorSprite: sprite, gameScene: gameScene,  maxOffset: 108)
                    }
                }
            }
            break;
        case 4: // 5 foots
            for i in 0...amount{
                if(i == 0){
                    theFoots[i].Init(postionX: position.x, positionY: 0, size: Constants.FOOT_SIZE, name: "foot", colorSprite: sprite, gameScene: gameScene,  maxOffset: 68)
                } else{
                    theFoots.append(Foot())
                    if(i == 1){
                        theFoots[i].Init(postionX: position.x, positionY: -220, size: Constants.FOOT_SIZE, name: "foot", colorSprite: sprite, gameScene: gameScene,  maxOffset: 68)
                    }else if (i == 2){
                        theFoots[i].Init(postionX: position.x, positionY: 220, size: Constants.FOOT_SIZE, name: "foot", colorSprite: sprite, gameScene: gameScene,  maxOffset: 68)
                    }else if(i == 3){
                        theFoots[i].Init(postionX: position.x, positionY: 110, size: Constants.FOOT_SIZE, name: "foot", colorSprite: sprite, gameScene: gameScene,  maxOffset: 68)
                    }else{
                        theFoots[i].Init(postionX: position.x, positionY: -110, size: Constants.FOOT_SIZE, name: "foot", colorSprite: sprite, gameScene: gameScene,  maxOffset: 68)
                    }
                }}
            break;
        default: // default 1 foot
            for i in 0...amount{
                theFoots[i].Init(postionX: position.x, positionY: 0, size: Constants.FOOT_SIZE, name: "foot", colorSprite: sprite, gameScene: gameScene,  maxOffset: 266)
            }
            break;
        }
    }
    
    func update(){
        //Update each foot of this stick
        //print("Update \(swipeLength)")
        for i in theFoots{
            i.update( swipeLength: swipeLength, positionY: positionY)
        }
        print(userName)
    }
}
