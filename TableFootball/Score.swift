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
    //Text labels
    var scoreRedLBL = SKLabelNode()
    var scoreBlueLBL = SKLabelNode()
    var winLabel = SKLabelNode()
    var winLabelShadow = SKLabelNode()
    
    var scoreLBL = SKLabelNode()
    var scoreLBLShadow = SKLabelNode()
    
    //Score
    var scoreRed:Int = 0
    var scoreBlue:Int = 0
    
    var scoreLimit:Int = 5
    
    var winner:String = ""
    var hasWon:Bool = false
    
    func Init(gamescene: GameScene){
        scoreRed = 0
        scoreBlue = 0
        
        //Find all labels
        scoreRedLBL = gamescene.childNode(withName: "redscore") as! SKLabelNode
        scoreBlueLBL = gamescene.childNode(withName: "bluescore")as! SKLabelNode
        winLabel = gamescene.childNode(withName: "winlabel")as! SKLabelNode
        winLabelShadow = gamescene.childNode(withName: "winlabelshadow")as! SKLabelNode
        scoreLBL = gamescene.childNode(withName: "scorelabel")as! SKLabelNode
        scoreLBLShadow = gamescene.childNode(withName: "scorelabelshadow")as! SKLabelNode
        
        setScoreLabel(text:"")
        //Set basic value for labels
        setWinScoreText(text: "")
        winLabelShadow.fontColor = UIColor.black
    }
    
    func redScores(){
        //Red scores
        scoreRed += 1
        scoreRedLBL.text = "Score:  \(scoreRed)"
        checkWinConditions()
    }
    
    func blueScored(){
        //Blue scores
        scoreBlue += 1
        scoreBlueLBL.text = "Score \(scoreBlue)"
        checkWinConditions()
    }
    
    func checkWinConditions(){
        if(scoreRed >= scoreLimit || scoreBlue >= scoreLimit){
            //Someone has won
            setScoreLabel(text: String(scoreRed) + " : " + String(scoreBlue))
                
            if(scoreRed > scoreBlue){
                //Red has won
                winLabel.fontColor = UIColor.red
                setWinScoreText(text: "Red has won")
                winner = "red"
                hasWon = true
            }else if(scoreBlue > scoreRed){
                //Blue has won
                winLabel.fontColor = UIColor.blue
                setWinScoreText(text: "Blue has won!")
                winner = "blue"
                hasWon = true
            }
        }
    }
    
    func setWinScoreText(text: String){
        winLabel.text = text
        winLabelShadow.text = text
    }
    
    func setScoreLabel(text: String){
        scoreLBL.text = text
        scoreLBLShadow.text = text
    }
}
