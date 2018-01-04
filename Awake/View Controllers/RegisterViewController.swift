//
//  RegisterViewController.swift
//  Awake
//
//  Created by admin on 03/01/2018.
//  Copyright © 2018 Dreamer. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
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
            switch result {
            case "Success":
                DispatchQueue.main.async { [weak self] in
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
            case "Error":
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(
                        with: "Error",
                        detail: "Username has already been taken",
                        style: .alert
                    )
                }
            default:
                break
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
