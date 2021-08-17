//
//  LoginViewController.swift
//  VKClient
//
//  Created by Сергей Черных on 13.08.2021.
//

import UIKit

class LoginViewController: UIViewController {
    let patternUsername = #"^[A-z\d.-]{3,19}$"#
    /*
     ^ - учет с начала строки
     [A-z\d.-] - строка может содержать латинские буквы без учета регистра, числа, а также "-" и "."
     {3,19} - строка длинной от 3 до 19 символов
     $ - учет с до конца строки
     */
    let patternPassword = #"^(?=.*[0-9])(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*]{8,}"#
    /*
     ^ - учет с начала строки
     (?=.*[0-9]) - строка содержит хотя бы одно число;
     (?=.*[!@#$%^&*]) - строка содержит хотя бы один спецсимвол;
     (?=.*[a-z]) - строка содержит хотя бы одну латинскую букву в нижнем регистре;
     (?=.*[A-Z]) - строка содержит хотя бы одну латинскую букву в верхнем регистре;
     [0-9a-zA-Z!@#$%^&*]{8,} - строка состоит не менее, чем из 8 вышеупомянутых
     */
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWasShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillBeHidden(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc func keyboardWasShow(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        UIView.animate(withDuration: 1) {
            self.scrollView.constraints.first(where: {$0.identifier == "keyboardShow"})?.priority = .required
            self.scrollView.constraints.first(where: {$0.identifier == "keyboardHide"})?.priority = .defaultHigh
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        UIView.animate(withDuration: 1) {
            self.scrollView.constraints.first(where: {$0.identifier == "keyboardShow"})?.priority = .defaultHigh
            self.scrollView.constraints.first(where: {$0.identifier == "keyboardHide"})?.priority = .required
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
}

