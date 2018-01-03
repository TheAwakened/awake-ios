//
//  RegisterViewController.swift
//  Awake
//
//  Created by admin on 03/01/2018.
//  Copyright © 2018 Dreamer. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    let registerApi = Constants.apiUrl + "/api/users"
    
    override func viewDidLoad() {
        usernameField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
    }
    
    @IBAction func submit(_ sender: Any) {
        if usernameField.text! == "" {
            self.showAlert(with: "Error", detail: "Username cannot be empty", style: .alert)
            return
        }
        if passwordField.text! == "" {
            self.showAlert(with: "Error", detail: "Password cannot be empty", style: .alert)
            return
        }
        if confirmPasswordField.text! == "" {
            self.showAlert(with: "Error", detail: "Confirm password cannot be empty", style: .alert)
            return
        }
        if passwordField.text! != confirmPasswordField.text! {
            self.showAlert(with: "Error", detail: "Password and confirm password are different", style: .alert)
            return
        }
        
        let url = URL(string: registerApi)
        var urlRequest = URLRequest(url: url!)
        let session = URLSession.shared
        urlRequest.httpMethod = "POST"
        
        let data: [String:Any] = [
            "user":[
                "username":usernameField.text!,
                "password":passwordField.text!,
                "password_confirmation":confirmPasswordField.text!
            ]
        ]
        
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: data)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
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
                        detail: "Username already taken",
                        style: .alert
                    )
                }else{
                    if(responseData["user"] != nil){
                        DispatchQueue.main.async {
                            let alert = UIAlertController(
                                title: "Success",
                                message: "Successfully Registered",
                                preferredStyle: .alert
                            )
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default){ action in
                                self?.dismiss(animated: true, completion: nil)
                            })
                            self?.present(alert, animated: true, completion: nil)
                        }
                    }else{
                        self?.showAlert(
                            with: "Error",
                            detail: "Username already taken",
                            style: .alert
                        )
                    }
                }
            }catch{
                self?.showAlert(
                    with: "Error",
                    detail: "Error in processing data, please enter the data again.",
                    style: .alert
                )
            }
            // parse the result as JSON, since that's what the API providess
        }
        task.resume()
    }
    @IBAction func tappingBackground(_ sender: Any) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        submit(textField)
        return true
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
