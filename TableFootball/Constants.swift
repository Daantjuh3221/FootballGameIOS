//
//  Constants.swift
//  TableFootball
//
//  Created by HuubvandeHoef on 4/12/17.
//  Copyright © 2017 HuubvandeHoef. All rights reserved.
//

import Foundation
import SpriteKit

struct Constants {
    //Enumerations
    enum TEAM:String{
        /*
         All team names, If a team is added, the sprites needs te be added as well
         */
        case red = "red"
        case blue = "blue"
        case neutral = ""
    }
    enum STICKNAMES:String{
        /*
         All names of the sticks.
 */
        case neutral = "stick0"
        case redKeeper = "stick01"
        case redDefender = "stick02"
        case blueAttacker = "stick03"
        case redMidfield = "stick04"
        case blueMidfield = "stick05"
        case redAttacker = "stick06"
        case blueDefender = "stick07"
        case blueKeeper = "stick08"
    }
    enum EMIT_VALUES:String{
        /*
         All the Strings used to get data from the apple tv
         Best is to make these on a database on the server en get them from there
 */
        //Get from server
        case getYPos = "getPositionYforAppleTV"
        case getXPos = "getPositionXforAppleTV"
        case getPlayerReady = "appletvplayerready"
        case getTeamRed = "addPlayerToTeamRed"
        case getTeamBlue = "addPlayerToTeamBlue"
        case getTeamMidden = "addPlayerToTeamMidden"
        case getHost = "getHost"
        
        //send to server
        case emitGoalScored = "goalisscored"
        case emitFalseGoal = "falsegoal"
        case resetGame = "resetGameData"
    }
    enum FOOT{
        /*
         Each team and their foot names. Not using red or blue, because there can be more teams
 */
        enum LEFT_TEAM:String{
            case keeper = "foot1"
            case defender = "foot2"
            case midfield = "foot4"
            case attack = "foot6"
        }
        enum RIGHT_TEAM:String{
            case keeper = "foot8"
            case defender = "foot7"
            case midfield = "foot5"
            case attack = "foot3"
        }
        
    }
    
    static var HOST_PLAYER:String = ""
    
    //Uses for the teams
    static var TEAMRED:[String] = []
    static var TEAMBLUE:[String] = []
    
    static var CONNECTEDPLAYERS:[String] = []
    static var JOINCODE = "notDefined"
    
    //Used for team on begin screen
    static var TEAMREDLIST:[String] = []
    static var TEAMBLUELIST:[String] = []
    
    //All positions off the ball
    static let STARTPOINT_TEAMBLUE:CGPoint = CGPoint(x:350,y:0)
    static let STARTPOINT_TEAMRED:CGPoint = CGPoint(x:-350,y:0)
    static let STARTPOINT_CENTRE:CGPoint = CGPoint(x:0,y:260)
    static let STARTPOINT_OFFSCREEN:CGPoint = CGPoint(x:12000,y:12000)
    
    //Ball settings
    static let BALL_NAME:String = "ball"
    static let BALL_SPRITE:String = "ballSprite"
    
    //Player and foot settings
    static let FOOT_SIZE:CGSize = CGSize(width: 25, height: 30)
    static let FOOT_MASS:CGFloat = CGFloat(50)
    static let FOOT_HEAD_HEIGHT:CGFloat = CGFloat(30)
    static let FOOT_NAME:String = "foot"
    static let FOOT_TEAM_LEFT:[String] = [FOOT.LEFT_TEAM.keeper.rawValue, FOOT.LEFT_TEAM.defender.rawValue, FOOT.LEFT_TEAM.midfield.rawValue, FOOT.LEFT_TEAM.attack.rawValue]
    static let FOOT_TEAM_RIGHT:[String] = [FOOT.RIGHT_TEAM.keeper.rawValue, FOOT.RIGHT_TEAM.defender.rawValue, FOOT.RIGHT_TEAM.midfield.rawValue, FOOT.RIGHT_TEAM.attack.rawValue]
    
    //Stick settings
    static let STICK_POSITION:[Int] = [-400, -300, -180, -65, 65, 180, 300, 400]
    static let STICK_COLOR:[String] = [TEAM.red.rawValue, TEAM.red.rawValue, TEAM.blue.rawValue, TEAM.red.rawValue, TEAM.blue.rawValue, TEAM.red.rawValue, TEAM.blue.rawValue, TEAM.blue.rawValue]
    static let STICK_AMOUNT_OF_FEETS:[Int] = [1, 2, 3, 5, 5, 3, 2, 1]
    static let STICK_OFFSET:[CGFloat] = [100, 150,80, 40, 40, 80, 150, 100]
    
    //Player var settings
    static var PLAYER_SENSITIVITY:CGFloat = CGFloat(250)
    
    //Goal values
    static let GOAL_NAME:String = "goal"
    
    //ScreenShake Constants
    static let SCREENSHAKE_DIV:CGFloat = CGFloat(1000)
    
    //Wall names
    static let WALLS_NAME:String = "walls"
    static let WALL_NAME:String = "wall"
    static let CUBE:String = "cube"
    
    //Game rules
    static var SCORELIMIT = 5 // Needs to be set from controller
    static let GAMEOVER_COUNTER = 120
    
    //Screen text Vlues
    
    
}
/*
 Weg met de strings, Constanten gebruiken
 Wat te doen met null exception
 Wat doet het inheritance
 
 
 besturing (gebruiksvriendelijkheid) moet nog beter!
 
 validator & sanitizer
 
 /////Tweede resit
 Singleton 
 Ovalen foots
*/
