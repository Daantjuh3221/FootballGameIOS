//
//  Score.swift
//  TableFootball
//
//  Created by HuubvandeHoef on 3/21/17.
//  Copyright © 2017 HuubvandeHoef. All rights reserved.
//

import Foundation
import SpriteKit

class Score:SKSpriteNode{
    var scoreRedLBL = SKLabelNode()
    var scoreBlueLBL = SKLabelNode()
    
    var scoreRed:Int = 0
    var scoreBlue:Int = 0
    
    func Init(gamescene: GameScene){
        scoreRed = 0
        scoreBlue = 0
        
        scoreRedLBL = gamescene.childNode(withName: "redscore") as! SKLabelNode
        scoreBlueLBL = gamescene.childNode(withName: "bluescore")as! SKLabelNode
        
        
    }
    
    func redScores(){
        scoreRed += 1
        scoreRedLBL.text = "Score:  \(scoreRed)"
        print(scoreRed)
        //Update ScoreBoard
    }
    
    func blueScored(){
        scoreBlue += 1
        scoreBlueLBL.text = "Score \(scoreBlue)"
        print(scoreBlue)
        //Update Scoreboard
    }
}
