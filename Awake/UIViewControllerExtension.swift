//
//  UIViewControllerExtension.swift
//  Awake
//
//  Created by admin on 04/01/2018.
//  Copyright © 2018 Dreamer. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(with title: String, detail message: String, actions: [UIAlertAction]? = [], style preferredStyle: UIAlertControllerStyle) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: preferredStyle
        )
        if let alertActions = actions, alertActions.count > 0 {
            for action in alertActions {
                alert.addAction(action)
            }
        }else{
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
}
