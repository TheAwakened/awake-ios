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
        guard usernameField.text! != "" else {
            self.showAlert(with: "Error", detail: "Username cannot be empty", style: .alert)
            return
        }
        
        guard passwordField.text! != "" else {
            self.showAlert(with: "Error", detail: "Password cannot be empty", style: .alert)
            return
        }
        
        showLoading()
        ApiController.sharedController.login(username: usernameField.text!, password: passwordField.text!){ (result, message) in
            guard result else {
                self.hideLoading()
                self.showAlert(
                    with: "Error",
                    detail: "Invalid username or password",
                    style: .alert
                )
                return
            }
            self.hideLoading()
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

