//
//  ViewController.swift
//  Awake
//
//  Created by admin on 13/11/2017.
//  Copyright © 2017 Dreamer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var settings = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
        if settings.object(forKey:"token") != nil
        {
            self.performSegue(withIdentifier: "goToAwake", sender: self)
        }
    }
    
    @IBAction func login(_ sender: Any) {
        hideErrors()
        guard usernameField.text! != "" else {
//            self.showAlert(with: "Error", detail: "Username cannot be empty", style: .alert)
            usernameErrorLabel.text? = "Username cannot be empty"
            usernameErrorLabel.isHidden = false
            return
        }
        
        guard passwordField.text! != "" else {
//            self.showAlert(with: "Error", detail: "Password cannot be empty", style: .alert)
            passwordErrorLabel.text? = "Password cannot be empty"
            passwordErrorLabel.isHidden = false
            return
        }
        
        showLoading()
        ApiController.sharedController.login(username: usernameField.text!, password: passwordField.text!){ (result, message) in
            self.hideLoading()
            guard result else {
//                self.showAlert(
//                    with: "Error",
//                    detail: "Invalid username or password",
//                    style: .alert
//                )
                self.passwordErrorLabel.text? = "Invalid username or password"
                self.passwordErrorLabel.isHidden = false
                return
            }
            self.settings.set(message, forKey: "token")
            self.performSegue(withIdentifier: "goToAwake", sender: self)
        }
    }

    func showLoading() {
        activityIndicator.startAnimating()
        loginButton.alpha = 0
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        loginButton.alpha = 1
    }
    
    func hideErrors(){
        usernameErrorLabel.text? = ""
        usernameErrorLabel.isHidden = true
        passwordErrorLabel.text? = ""
        passwordErrorLabel.isHidden = true
    }
}

extension LoginViewController: UIGestureRecognizerDelegate {
    @IBAction func tappingBackground(_ sender: Any) {
        self.view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        login(textField)
        return true
    }
}

