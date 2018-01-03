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
    private init(){
    }
    var token: String? = nil
    
    func login(username: String, password: String, sender: UIViewController){
        let signInApiUrl = Constants.apiUrl + "/api/authenticate"
        let parameters: Parameters = [
            "auth":[
                "username":username,
                "password":password
            ]
        ]
        Alamofire.request(signInApiUrl, method: .post, parameters: parameters).responseJSON{ response in
            if let responseData = response.result.value {
                let json = JSON(responseData)
                if json["jwt"] != JSON.null {
                    let message = json["jwt"]
                    if let vc = sender as? LoginViewController {
                        vc.finishedLogin(result: "Success",message: message.string!)
                        self.token = message.string!
                    }
                }else if json["error"] != JSON.null {
                    let message = json["error"]
                    if let vc = sender as? LoginViewController {
                        vc.finishedLogin(result: "Error",message: message.string!)
                    }
                }
            }
        }
        
        
        
    }
    func register(username: String, password: String, sender: UIViewController){
        let registerApiUrl = Constants.apiUrl + "/api/users"
        let parameters: Parameters = [
            "user":[
                "username":username,
                "password":password,
                "password_confirmation":password
            ]
        ]
        Alamofire.request(registerApiUrl, method: .post, parameters: parameters).responseJSON{ response in
            if let responseData = response.result.value {
                let json = JSON(responseData)
                if json["user"] != JSON.null {
                    if let vc = sender as? RegisterViewController {
                        vc.finishedRegister(result: "Success")
                    }
                }else if json["errors"] != JSON.null {
                    if let vc = sender as? RegisterViewController {
                        vc.finishedRegister(result: "Error")
                    }
                }
            }
        }
        
    }
    func awake(sender: UIViewController){
        let awakeAPI = Constants.apiUrl + "/api/awakenings"
        let parameters: Parameters = [:]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer "+token!
        ]
        
        Alamofire.request(awakeAPI, method: .post, parameters: parameters, headers: headers).responseJSON{ response in
            if let responseData = response.result.value {
                let json = JSON(responseData)
                if json["awakening"] != JSON.null {
                    if let vc = sender as? AwakeViewController {
                        vc.finishedAwake(result: "Success")
                    }
                }else if json["errors"] != JSON.null {
                    if let vc = sender as? AwakeViewController {
                        vc.finishedAwake(result: "Error")
                    }
                }
            }
        }
        
    }
    func getAwakeStatuses(sender: UIViewController){
        let statusApiUrl = Constants.apiUrl + "/api/today"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer "+token!
        ]
        Alamofire.request(statusApiUrl, headers: headers).responseJSON{ response in
            if let responseData = response.result.value {
                let json = JSON(responseData)
                if json["users"] != JSON.null {
                    if let vc = sender as? StatusesTableViewController {
                        var statuses: [Status] = []
                        for (_,status) in json["users"] {
                            if let awakeTime = status["awaken_time"].string {
                                let newStatus = Status(
                                    userId: status["id"].int!,
                                    username: status["username"].string!,
                                    awakeTime: awakeTime
                                )
                                 statuses.append(newStatus)
                            }else{
                                let newStatus = Status(
                                    userId: status["id"].int!,
                                    username: status["username"].string!,
                                    awakeTime: "Sleeping"
                                )
                                 statuses.append(newStatus)
                            }
        
                        }
                        vc.finishedLoadingData(result: "Success", data: statuses)
                    }
                }else if json["errors"] != JSON.null {
                    if let vc = sender as? StatusesTableViewController {
                        
                    }
                }
            }
        }
        
    }
}
