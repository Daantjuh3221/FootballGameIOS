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
    
    var isScored:Bool = false
    var isShot:Bool = false
    var score:Score = Score()
    
    var ballSpeed:CGFloat = 3
    
    var touchFoot:SKNode = SKNode()
    var footNode:Foot = Foot()
    
    var rotationSpeed:CGFloat = 0
    var goalCounter:Int = 20
    var isPlaying:Bool = false
    
    //sound effects
    //let sound01 = SKAction.playSoundFileNamed("186469__paskis3__shot-soocer-table", waitForCompletion: false)
    var soundSoftBounce:[SKAction] = []
    var cheerSound:[SKAction] = []
    
    var firstTouches:String = ""
    var secondTouches:String = ""
    
    var lastTouches:String = ""
    
    var redFalseScored:Bool = false
    
    var redInPosession:Bool = false
    
    //Socket
    let socket = SocketIOManager.sharedInstance.getSocket();
    
    func Init(gamescene:GameScene, scoreLimit: Int){
        //Initialize the ball here
        let imageTexture = SKTexture(imageNamed: "ballSprite")
        name = "ball"
        
        let body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: imageTexture.size().width/2)
        body.isDynamic = true
        body.affectedByGravity = false;
        body.allowsRotation = true;
        body.mass = 0.2
        body.categoryBitMask = 1
        body.contactTestBitMask = 2
        body.restitution = 0
        
        getSound()
        
        position = CGPoint(x:-12000, y:12000)
        
        score.Init(gamescene: gamescene, _scoreLimit: scoreLimit)
    }
    
    func getSound(){
        //get the soft bounce sound
        for i in 0...9{
            soundSoftBounce.append(SKAction.playSoundFileNamed("bounce0" + String(i + 1) + ".wav", waitForCompletion: false))
        }
        cheerSound.append(SKAction.playSoundFileNamed("cheering.mp3", waitForCompletion: false))
        
    }
    
    func didScored(){
        //mothode called when a goal is scored
        isScored = true
        run(cheerSound[0])
    }
    
    func setTouches(currentTouch: String){
        /*
         this method checks which two objects have been touches the last
         In this way you can check if a goal is allowed or not
         */
        if(currentTouch != firstTouches){
            secondTouches = firstTouches
            firstTouches = currentTouch
        }
        
        //print("Touch First: " + firstTouches)
        //print("Touch Second: " + secondTouches)
    }
    
    func isGoalAllowed() -> Bool{
        /*
         Checks if a goal is allowed or not. returns the outcome (True || False)!
         
         - foot1 = red keeper
         - foot2 = red defence
         - foot3 = blue attack
         - foot4 = red midfield
         - foot5 = blue midfield
         - foot6 = red attack
         - foot7 = blue defence
         - foot8 = red keeper
         
         - wall = wall... duh
         
         <--- Rules --->
         - A player cant score a own goal
         - You cant score trough the wall
         - middfielders cant score
 */
        if(firstTouches == "wall"){
            //Cant score with the wall
            return false
        }
        
        if(firstTouches.contains("foot")){
            //Checks if its a own goal
            if(position.x > 0){
                //red scored own goal
                if(checkPosession() == "red"){
                    //own goal red
                    return false
                }else if(checkPosession() == "blue"){
                    //goal blue
                    return true
                }
            }else {
                //invert if blue scored own goal
                if(checkPosession() == "red"){
                    //goal red
                    return true
                }else if(checkPosession() == "blue"){
                    //own goal blue
                    return false
                }
            }
            
            
            
            //What happens when its a foot
            if(firstTouches.contains("4") || firstTouches.contains("5")){
                //Midfield cant score
                return false
            }else {
                //Default return
                return true
            }
        }else {
            //default return
            return true
        }
    }

    func checkPosession() -> String{
        //This method checks which team has posession and returns a String with the team name
        //Returns "red" || "blue"
        /*
         1 = r
         2 = r
         3 = b
         4 = r
         5 = b
         6 = r
         7 = b
         8 = b
         */
        var teamPos:String = ""
        
        let teamRed:[String] = ["foot1", "foot2", "foot4", "foot6"]
        let teamBlue:[String] = ["foot3", "foot5", "foot7", "foot8"]
        
        
        if(teamRed.contains(firstTouches) && teamRed.contains(secondTouches)){
                teamPos = "red"
        }else if(teamBlue.contains(firstTouches) && teamBlue.contains(secondTouches)){
            teamPos = "blue"
        }else {
            teamPos = ""
        }

        
        return teamPos
    }
    
    func collidesWithWallVertical(wallPosition: CGFloat, currentTouch:String){
        
        physicsBody!.velocity.dx = 0
        var tempForce = 0
        
        if(wallPosition > 0){
            tempForce = (-1 * 20)
        }else{
            tempForce = 20
        }
        physicsBody!.applyImpulse(CGVector(dx:tempForce, dy: 0))
        setTouches(currentTouch: currentTouch)
        playerBounceSound()
    
    }
    
    func collidesWithWallHorizintal(wallPosition: CGFloat, currentTouch:String){
        
        physicsBody!.velocity.dy = 0
        var tempForce = 0
        
        if(wallPosition > 0){
        tempForce = (-1 * 20)
        }else{
            tempForce = 20
        }
        
        physicsBody!.applyImpulse(CGVector(dx:0, dy: tempForce))
        setTouches(currentTouch: currentTouch)
        playerBounceSound()
    }
    
    func collidesWithFoot(currentTouch: String){
        //Play sound
        setTouches(currentTouch: currentTouch)
        playerBounceSound()
    }
    
    func playerBounceSound(){
        let randomSound:Int = Int(arc4random_uniform(10))
        run(soundSoftBounce[randomSound])
    }
    
    func checkIfWon(){
        if(score.hasWon){
            //Some one won
            if(score.winnerRed){
                //Red has won
            }else {
                //blue has Won
            }
            alpha = 0
            
            physicsBody?.velocity.dy = 0
            physicsBody?.velocity.dx = 0
            
            //Go to home scene
        }
    }
    
    func isGameOver() -> Bool{
        if(score.hasWon){
            return true
        }else{
            return false
        }
    }
    
    func update(){
        //Checks if is scored, adds score and resets the ball
        if(isScored){
            isScored = false
            if(isGoalAllowed()){
                /*
                 This will be done when a goal is allowed
                 */
            if(position.x < 0){
                //Left scored (Blue)
                score.blueScored()
                
                //Emit to socket if scored
                socket.emit("goalisscored", "blue")
            }
            else{
                //Right Scored (Red)
                score.redScores()
                
                //Emit to socket if scored
                socket.emit("goalisscored", "red")
            }
            checkIfWon()
            
            }else{
                //this will be done when a goal is disallowed
                if(position.x < 0){
                    //Blue scored false
                    score.blueFalseScore()
                    redFalseScored = false
                    socket.emit("falsegoal", "blue")
                    
                }else{
                    //red score false
                    score.redFalseScore()
                    redFalseScored = true
                    socket.emit("falsegoal", "red")
                }
            }
            
            //Set the ball to its offscreen position and set the pause timer
            position = Constants.STARTPOINT_OFFSCREEN
            physicsBody?.velocity.dy = 0
            physicsBody?.velocity.dx = 0
            goalCounter = 80
            isPlaying = false
        }
        
        //Goal counter drain
        if(goalCounter >= 0){
            goalCounter -= 1
        }

        //If counter has ended
        if(!isPlaying && goalCounter <= 1){
            if(isGoalAllowed()){
            isPlaying = true
            position = Constants.STARTPOINT_CENTRE
            
                //Gives a random velocity to the ball
            let randomVel:CGFloat = CGFloat(arc4random_uniform(100))
                let random:CGFloat = CGFloat(arc4random_uniform(100))
                var x:CGFloat?
                if(random > 50){
                    x = 1
                }else {
                    x = -1
                }
            physicsBody?.velocity.dx = randomVel * x!
            physicsBody?.velocity.dy = -100
            }else{
                isPlaying = true
                if(redFalseScored){
                    position = Constants.STARTPOINT_TEAMBLUE
                }else{
                    position = Constants.STARTPOINT_TEAMRED
                }
                
            }
        }
        //Check if splash screen needs to fade & fade if needed
        if(!score.hasWon){
            if(score.scoreLBL.alpha > 0){
                score.scoreLBL.alpha -= 0.01
                score.scoreLBLShadow.alpha -= 0.01
            }
            if(score.winLabel.alpha > 0){
                score.winLabel.alpha -= 0.01
                score.winLabelShadow.alpha -= 0.01
            }
        }else{
            position = Constants.STARTPOINT_OFFSCREEN
            physicsBody?.velocity.dy = 0
            physicsBody?.velocity.dx = 0
        }
        
        //Makes the ball rotate
        if((physicsBody?.velocity.dy)! > CGFloat(0) || (physicsBody?.velocity.dy)! < CGFloat(0)){
            if((physicsBody?.velocity.dx)! > CGFloat(0) || (physicsBody?.velocity.dx)! < CGFloat(0)){
            //rotate sprite
                rotationSpeed += (physicsBody?.velocity.dx)! - (physicsBody?.velocity.dy)!
                if(rotationSpeed > 360){
                    rotationSpeed = -300
                }
                self.zRotation = rotationSpeed
                
            }}
    
}

}
