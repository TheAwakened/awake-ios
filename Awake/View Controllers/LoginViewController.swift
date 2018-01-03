//
//  ViewController.swift
//  Awake
//
//  Created by admin on 13/11/2017.
//  Copyright © 2017 Dreamer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
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
        ApiController.sharedController.login(username: usernameField.text!, password: passwordField.text!, sender: self)
    }
    
    func finishedLogin(result: String, message: String){
        switch result {
        case "Success":
            DispatchQueue.main.async{[weak self] in
                self?.settings.set(message, forKey: "token")
                self?.performSegue(withIdentifier: "goToAwake", sender: self)
            }
        case "Error":
            hideLoading()
            DispatchQueue.main.async{[weak self] in
                self?.showAlert(
                    with: "Error",
                    detail: "Invalid username or password",
                    style: .alert
                )
            }
        default: break
        }
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

