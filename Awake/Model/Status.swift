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
        guard
            let userId: Int = status["id"].int,
            let username = status["username"].string
        else {
            return nil
        }
        self.userId = userId
        self.username = username
        self.awakeTime = status["awaken_time"].string ?? "Sleeping"
    }
}
