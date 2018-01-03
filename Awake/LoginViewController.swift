//
//  ViewController.swift
//  Awake
//
//  Created by admin on 13/11/2017.
//  Copyright © 2017 Dreamer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loginButton: UIButton!
    var signInApi = Constants.apiUrl + "/api/authenticate"
    var settings = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
        if settings.object(forKey:"token") != nil
        {
            self.performSegue(withIdentifier: "goToAwake", sender: self)
        }
            // Do any additional setup after loading the view, typically from a nib.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        login(textField)
        return true
    }
    @IBAction func login(_ sender: Any) {
        if usernameField.text! == "" {
            self.showAlert(with: "Error", detail: "Username cannot be empty", style: .alert)
            return
        }
        if passwordField.text! == "" {
            self.showAlert(with: "Error", detail: "Password cannot be empty", style: .alert)
            return
        }
        showLoading()
        let url = URL(string: signInApi)
        var urlRequest = URLRequest(url: url!)
        let session = URLSession.shared
        urlRequest.httpMethod = "POST"
        
        let data: [String:Any] = ["auth":["username":usernameField.text!,"password":passwordField.text!]]
        
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: data)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: urlRequest){[weak self] data, response, error in
            // make sure we got data
            DispatchQueue.main.async {
                self?.hideLoading()
            }
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
                        detail: "Invalid username or password",
                        style: .alert
                    )
                }else{
                    if(responseData["jwt"] != nil){
                        self?.settings.set(responseData["jwt"], forKey: "token")
                        DispatchQueue.main.async{[weak self] in
                            self?.performSegue(withIdentifier: "goToAwake", sender: self)
                        }
                        
                    }else{
                        self?.showAlert(
                            with: "Error",
                            detail: "Invalid username or password",
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
    func showLoading(){
        activityIndicator.startAnimating()
        loginButton.alpha = 0
    }
    func hideLoading(){
        activityIndicator.stopAnimating()
        loginButton.alpha = 1
    }
    @IBAction func tappingBackground(_ sender: Any) {
        self.view.endEditing(true)
    }
}


extension UIViewController {
    func showAlert(with title: String, detail message: String, style preferredStyle: UIAlertControllerStyle){
        DispatchQueue.main.async {[weak self] in
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: preferredStyle
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

