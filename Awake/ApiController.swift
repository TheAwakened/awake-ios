//
//  Request.swift
//  Awake
//
//  Created by admin on 03/01/2018.
//  Copyright © 2018 Dreamer. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ApiController {
    static let sharedController = ApiController()
    let hostUrl = "https://agile-spire-43204.herokuapp.com"
    var token: String? = nil
    
    private init(){
    }
    
    func login(username: String, password: String, completion: ((_ result: Bool, _ message: String) -> Void)?) {
        let signInApiUrl = hostUrl + "/api/authenticate"
        let parameters: Parameters = [
            "auth": [
                "username":username,
                "password":password
            ]
        ]
        
        Alamofire.request(signInApiUrl, method: .post, parameters: parameters).responseJSON{ response in
            guard let responseData = response.result.value else {
                return
            }
            let json = JSON(responseData)
            
            if json["jwt"] != JSON.null {
                let message = json["jwt"]
                completion?(true,message.string!)
                self.token = message.string!
                
            } else if json["error"] != JSON.null {
                let message = json["error"]
                completion?(false, message.string!)
            }
        }
    }
    
    func register(username: String, password: String, completion: ((_ result: Bool) -> Void)?) {
        let registerApiUrl = hostUrl + "/api/users"
        let parameters: Parameters = [
            "user":[
                "username": username,
                "password": password,
                "password_confirmation": password
            ]
        ]
        Alamofire.request(registerApiUrl, method: .post, parameters: parameters).responseJSON{ response in
            guard let responseData = response.result.value else {
                return
            }
            let json = JSON(responseData)
            if json["user"] != JSON.null {
                completion?(true)
            }else if json["errors"] != JSON.null {
                completion?(false)
            }
        }
    }
    
    func awake(completion: ((_ result: Bool) -> Void)?) {
        let awakeAPI = hostUrl + "/api/awakenings"
        let parameters: Parameters = [:]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token!
        ]
        
        Alamofire.request(awakeAPI, method: .post, parameters: parameters, headers: headers).responseJSON{ response in
            guard let responseData = response.result.value else {
                return
            }
            let json = JSON(responseData)
            if json["awakening"] != JSON.null {
                completion?(true)
            }else if json["errors"] != JSON.null {
                completion?(false)
            }
        }
        
    }
    func getAwakeStatuses(completion: ((_ result: Bool, _ statuses: [Status]?) -> Void)?) {
        let statusApiUrl = hostUrl + "/api/today"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token!
        ]
        Alamofire.request(statusApiUrl, headers: headers).responseJSON{ response in
            guard let responseData = response.result.value else {
                return
            }
            let json = JSON(responseData)
            if json["users"] != JSON.null {
                var statuses: [Status] = []
                for (_,status) in json["users"] {
                    if let newStatus = Status(status: status) {
                        statuses.append(newStatus)
                    }else{
                        completion?(false, nil)
                    }
                }
                completion?(true, statuses)
            }else if json["errors"] != JSON.null {
                completion?(false, nil)
            }
            
        }
        
    }
}
