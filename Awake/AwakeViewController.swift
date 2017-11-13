//
//  AwakeViewController.swift
//  Awake
//
//  Created by admin on 13/11/2017.
//  Copyright © 2017 Dreamer. All rights reserved.
//

import UIKit

class AwakeViewController: UIViewController {
    var awakeAPI = ""
    @IBAction func awake(_ sender: Any) {
        let url = URL(string: awakeAPI)
        var urlRequest = URLRequest(url: url!)
        let session = URLSession.shared
        urlRequest.httpMethod = "POST"
        
        let data: [String:Any] = ["":""]
        
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: data)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue(UserDefaults.standard.object(forKey: "token") as! String,forHTTPHeaderField:"Authorization")
        
        let task = session.dataTask(with: urlRequest){[weak self] data, response, error in
            // make sure we got data
            guard data != nil else {
                self?.showAlert(
                    with: "Error",
                    detail: "Unable to receive data from server",
                    style: .alert
                )
                return
            }
            do{
                guard let responseData = try JSONSerialization.jsonObject(with: data!) as? [String:Any] else {
                    return
                }
                if error != nil {
                    self?.showAlert(
                        with: "Error",
                        detail: responseData["message"] as? String ?? "Unknown error",
                        style: .alert
                    )
                }else{
                    self?.showAlert(
                        with: "Sucess",
                        detail: "You are awake!",
                        style: .alert
                    )
                }
                
            }catch{
                self?.showAlert(
                    with: "Error",
                    detail: "Error in processing data, please enter the data again.",
                    style: .alert
                )
            }
            // parse the result as JSON, since that's what the API provides
            
        }
        task.resume()
    }
}

