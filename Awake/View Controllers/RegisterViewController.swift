//
//  RegisterViewController.swift
//  Awake
//
//  Created by admin on 03/01/2018.
//  Copyright © 2018 Dreamer. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        usernameField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
    }
    
    @IBAction func submit(_ sender: Any) {
        guard usernameField.text! != "" else {
            self.showAlert(with: "Error", detail: "Username cannot be empty", style: .alert)
            return
        }
        guard passwordField.text! != "" else {
            self.showAlert(with: "Error", detail: "Password cannot be empty", style: .alert)
            return
        }
        guard confirmPasswordField.text! != "" else {
            self.showAlert(with: "Error", detail: "Confirm password cannot be empty", style: .alert)
            return
        }
        guard passwordField.text! == confirmPasswordField.text! else {
            self.showAlert(with: "Error", detail: "Password and confirm password are different", style: .alert)
            return
        }
        ApiController.sharedController.register(username: usernameField.text!, password: passwordField.text!){ result in
            guard result else {
                self.showAlert(
                    with: "Error",
                    detail: "Username has already been taken",
                    style: .alert
                )
                return
            }
            
            let action = UIAlertAction(title: "OK", style: .default){ action in
                self.dismiss(animated: true, completion: nil)
            }
            self.showAlert(with: "Success", detail: "Successfully Registered", actions: [action], style: .alert)
            let alert = UIAlertController(
                title: "Success",
                message: "Successfully Registered",
                preferredStyle: .alert
            )
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension RegisterViewController: UIGestureRecognizerDelegate {
    @IBAction func tappingBackground(_ sender: Any) {
        self.view.endEditing(true)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        submit(textField)
        return true
    }
}
