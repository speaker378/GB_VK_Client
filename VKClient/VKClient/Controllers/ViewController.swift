//
//  ViewController.swift
//  VKClient
//
//  Created by Сергей Черных on 13.08.2021.
//

import UIKit

class ViewController: UIViewController {
    let patternUsername = #"^[A-Za-z][A-Za-z\d.-]{3,19}$"#
    let patternPassword = #"^.*(?=.{8,})(?=.*[a-zA-Z])(?=.*\d)(?=.*[!#$%&?.,_ "]).*$"#
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        if isValid() {
            print("ok")
        } else {
            print("not ok")
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
    }
    
    func isValid() -> Bool {
        return ((loginTextField.text?.range(of: patternUsername, options: .regularExpression)) != nil) &&
            ((passwordTextField.text?.range(of: patternPassword, options: .regularExpression)) != nil)
    }
    // скрывает клавиатуру после ввода текста (нашел в интернете)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil { view.endEditing(true) }
        super.touchesBegan(touches, with: event)
    }
}

