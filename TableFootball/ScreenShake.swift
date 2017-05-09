//
//  ScreenShake.swift
//  TableFootball
//
//  Created by HuubvandeHoef on 5/3/17.
//  Copyright © 2017 HuubvandeHoef. All rights reserved.
//

import Foundation

import SpriteKit
import GameplayKit

class ScreenShake: SKScene {
    
    var theCamera:SKCameraNode?
    var cameraStartPos: CGPoint?
    var cameraStartRotation: CGFloat?
    
    var duration:Int32?
    var intensity: CGFloat?
    var isShaking:Bool = false
    var counter:Int32?
    var divNum:CGFloat?
    
    func Init(thisCamera: SKCameraNode, duration: Int32, intensity: CGFloat){
        theCamera = thisCamera
        self.duration = duration
        self.intensity = intensity
        counter = duration
        
        divNum = 2
        
        cameraStartPos = theCamera?.position
        cameraStartRotation = theCamera?.zRotation
    }
    
    func StartShake(){
        isShaking = true
    }
    
    func EndShake(){
        isShaking = false
        theCamera?.position = cameraStartPos!
        theCamera?.zRotation = cameraStartRotation!
        counter = duration
        divNum = 2
    }
    
    func Shake(){
        
        counter! -= 1
        
        if(counter! < 0){
            EndShake()
        }
        /*
         divNum zorgt voor bugs, Weg halen als het irritant is
         De intensiteit moet steeds kleiner worden, waardoor het scherm steeds minder hard gaat shaken!
        */
        if(isShaking){
            let randomNum:UInt32 = arc4random_uniform(100)
            
            if(randomNum < 50){
                theCamera?.position.x += (intensity!) / divNum!
                theCamera?.zRotation += (intensity!/1000) / divNum!
            }else{
                theCamera?.position.x -= intensity! / divNum!
                theCamera?.zRotation -= (intensity!/1000) / divNum!
            }
            let randomNum1:UInt32 = arc4random_uniform(100)
            if(randomNum1 < 50){
                theCamera?.position.x += (intensity!) / divNum!
            }else{
                theCamera?.position.x -= (intensity!) / divNum!
            }
            divNum! *= 1.1

        }
    }
    
}
