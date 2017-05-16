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
    //Uses for the teams
    static var TEAMRED:[String] = []
    static var TEAMBLUE:[String] = []
    
    static var CONNECTEDPLAYERS:[String] = []
    static var JOINCODE = "notDefined"
    
    //All positions off the ball
    static let STARTPOINT_TEAMBLUE:CGPoint = CGPoint(x:350,y:0)
    static let STARTPOINT_TEAMRED:CGPoint = CGPoint(x:-350,y:0)
    static let STARTPOINT_CENTRE:CGPoint = CGPoint(x:0,y:260)
    static let STARTPOINT_OFFSCREEN:CGPoint = CGPoint(x:12000,y:12000)
    
    //Ball settings
    
    
    //Player and foot settings
    static let FOOT_SIZE:CGSize = CGSize(width: 25, height: 50)
    static let FOOT_MASS:CGFloat = CGFloat(50)
    static let FOOT_HEAD_HEIGHT:CGFloat = CGFloat(50)
    //Player var settings
    static var PLAYER_SENSITIVITY:CGFloat = CGFloat(80)
    
    
    //ScreenShake Constants
    static let SCREENSHAKE_DIV:CGFloat = CGFloat(1000)
    
}
