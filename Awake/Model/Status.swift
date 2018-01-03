//
//  File.swift
//  Awake
//
//  Created by admin on 03/01/2018.
//  Copyright © 2018 Dreamer. All rights reserved.
//

import Foundation

class Status {
    var userId: Int
    var username: String
    var awakeTime: String
    
    init(userId:Int, username:String,awakeTime:String){
        self.userId = userId
        self.username = username
        self.awakeTime = awakeTime
    }
}
