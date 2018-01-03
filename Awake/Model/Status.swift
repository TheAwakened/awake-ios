//
//  File.swift
//  Awake
//
//  Created by admin on 03/01/2018.
//  Copyright © 2018 Dreamer. All rights reserved.
//

import Foundation

class User {
    var id: Int
    var username: String
    var awakeTime: String
    
    init(id:Int, username:String,awakeTime:String){
        self.id = id
        self.username = username
        self.awakeTime = awakeTime
    }
}
