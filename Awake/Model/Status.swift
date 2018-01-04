//
//  File.swift
//  Awake
//
//  Created by admin on 03/01/2018.
//  Copyright © 2018 Dreamer. All rights reserved.
//

import Foundation
import SwiftyJSON

class Status {
    var userId: Int
    var username: String
    var awakeTime: String
    
    init?(status: JSON){
        if let userId = status["id"].int {
            self.userId = userId
        } else {
            return nil
        }
        if let username = status["username"].string {
            self.username = username
        }else{
            return nil
        }
        
        if let awakeTime = status["awaken_time"].string {
            self.awakeTime = awakeTime
        }else{
            self.awakeTime = "Sleeping"
        }
    }
}
