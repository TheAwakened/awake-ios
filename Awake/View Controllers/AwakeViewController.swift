//
//  AwakeViewController.swift
//  Awake
//
//  Created by admin on 13/11/2017.
//  Copyright © 2017 Dreamer. All rights reserved.
//

import UIKit

class AwakeViewController: UIViewController {
    var awakeAPI = Constants.apiUrl + "/api/awakenings"
    var settings = UserDefaults.standard
    
    @IBAction func awake(_ sender: Any) {
        ApiController.sharedController.awake(sender: self)
    }
    func finishedAwake(result: String){
        switch result {
        case "Success":
            DispatchQueue.main.async{ [weak self] in
                self?.showAlert(
                    with: "Sucess",
                    detail: "You are awaken!",
                    style: .alert
                )
            }
        case "Error":
            DispatchQueue.main.async{ [weak self] in
                self?.showAlert(
                    with: "Error",
                    detail: "Cannot awake more than once",
                    style: .alert
                )
            }
        default:
            break
        }
    }
    @IBAction func signOut(_ sender: Any) {
        settings.removeObject(forKey: "token")
        let vc = storyboard?.instantiateViewController(withIdentifier: "Home")
        self.present(vc!, animated: true, completion: nil)
    }
}

