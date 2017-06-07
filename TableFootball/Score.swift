//
//  Score.swift
//  TableFootball
//
//  Created by HuubvandeHoef on 3/21/17.
//  Copyright © 2017 HuubvandeHoef. All rights reserved.
//

import Foundation
import SpriteKit

enum textShow:String{
    case goal = "GOOOOAAAAAALLL"
    case noGoal = "No GOAL!"
    case redFalseScore = "BLUE GETS THE BALL"
    case blueFalseScore = "RED GETS THE BALL"
    case redWin = "Red has won"
    case blueWin = "Blue has won"
}

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
    
    //Score limit, can be set in the constructor
    var scoreLimit:Int = 1
    
    var winnerRed:Bool = true
    var hasWon:Bool = false
    
    func Init(gamescene: GameScene, _scoreLimit: Int){
        //Initial scores
        scoreRed = 0
        scoreBlue = 0
        
        scoreLimit = _scoreLimit
        
        //Find all labels
        scoreRedLBL = gamescene.childNode(withName: "redscore") as! SKLabelNode
        scoreBlueLBL = gamescene.childNode(withName: "bluescore")as! SKLabelNode
        winLabel = gamescene.childNode(withName: "winlabel")as! SKLabelNode
        winLabelShadow = gamescene.childNode(withName: "winlabelshadow")as! SKLabelNode
        scoreLBL = gamescene.childNode(withName: "scorelabel")as! SKLabelNode
        scoreLBLShadow = gamescene.childNode(withName: "scorelabelshadow")as! SKLabelNode
        
        setText(text: "", textF: winLabel, textS: winLabelShadow)
        setText(text: "", textF: scoreLBL, textS: scoreLBLShadow)
        //Set basic value for labels
      //  setWinScoreText(text: "")
        winLabelShadow.fontColor = UIColor.black
    }
    
    func redScores(){
        //Red scores
        scoreRed += 1
        scoreRedLBL.text = "Score:  \(scoreRed)"
        
        //Set splash screen
        setText(text: String(scoreRed) + " : " + String(scoreBlue), textF: scoreLBL, textS: scoreLBLShadow)
        scoreLBL.alpha = 1
        scoreLBLShadow.alpha = 1
        
        setText(text: textShow.goal.rawValue, textF: winLabel, textS: winLabelShadow)
        winLabel.fontColor = UIColor.red
        winLabelShadow.alpha = 1
        winLabel.alpha = 1
        
        checkWinConditions()
    }
    
    func blueScored(){
        //Blue scores
        scoreBlue += 1
        scoreBlueLBL.text = "Score \(scoreBlue)"
        
        //Set splash screen
        setText(text: String(scoreRed) + " : " + String(scoreBlue), textF: scoreLBL, textS: scoreLBLShadow)
        scoreLBL.alpha = 1
        scoreLBLShadow.alpha = 1
        
        setText(text: textShow.goal.rawValue, textF: winLabel, textS: winLabelShadow)
        winLabel.fontColor = UIColor.blue
        winLabelShadow.alpha = 1
        winLabel.alpha = 1
        
        checkWinConditions()
    }
    
    func foulText(message: String){
        setText(text: message, textF: scoreLBL, textS: scoreLBLShadow)
        setText(text: textShow.noGoal.rawValue, textF: winLabel, textS: winLabelShadow)
        scoreLBL.alpha = 0.7
        scoreLBLShadow.alpha = 0.7
        winLabel.alpha = 0.7
        winLabelShadow.alpha = 0.7
    }
    
    func redFalseScore(){
        //Set splash screen
        setText(text: textShow.redFalseScore.rawValue, textF: scoreLBL, textS: scoreLBLShadow)
        scoreLBL.alpha = 1
        scoreLBLShadow.alpha = 1
        
        setText(text: textShow.noGoal.rawValue, textF: winLabel, textS: winLabelShadow)
        winLabel.fontColor = UIColor.red
        winLabelShadow.alpha = 1
        winLabel.alpha = 1
    }
    
    func blueFalseScore(){
        //Set splash screen
        setText(text: textShow.blueFalseScore.rawValue, textF: scoreLBL, textS: scoreLBLShadow)
        scoreLBL.alpha = 1
        scoreLBLShadow.alpha = 1
        
        setText(text: textShow.noGoal.rawValue, textF: winLabel, textS: winLabelShadow)
        winLabel.fontColor = UIColor.blue
        winLabelShadow.alpha = 1
        winLabel.alpha = 1
    }
    
    func checkWinConditions(){
        if(scoreRed >= scoreLimit || scoreBlue >= scoreLimit){
            //Someone has won
            //setText(text: String(scoreRed) + " : " + String(scoreBlue))
            setText(text: String(scoreRed) + " : " + String(scoreBlue), textF: scoreLBL, textS: scoreLBLShadow)
            
            hasWon = true
            
            if(scoreRed > scoreBlue){
                //Red has won
                winLabel.fontColor = UIColor.red
                setText(text: textShow.redWin.rawValue, textF: winLabel, textS: winLabelShadow)
                winnerRed = true
            }else if(scoreBlue > scoreRed){
                //Blue has won
                winLabel.fontColor = UIColor.blue
                setText(text: textShow.blueWin.rawValue, textF: winLabel, textS: winLabelShadow)
                winnerRed = false
            }
        }
    }
    
    //Set text
    func setText(text: String, textF: SKLabelNode, textS: SKLabelNode){
        textF.text = text
        textS.text = text
    }
}
