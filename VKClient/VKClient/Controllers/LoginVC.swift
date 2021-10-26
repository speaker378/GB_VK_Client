//
//  LoginVC.swift
//  VKClient
//
//  Created by Сергей Черных on 13.08.2021.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    let patternUsername = #"^\S+@\S+\.\S+$"#
    let patternPassword = #"^(?=.*[0-9])(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*]{8,}"#
    /*
     ^ - учет с начала строки
     (?=.*[0-9]) - строка содержит хотя бы одно число;
     (?=.*[!@#$%^&*]) - строка содержит хотя бы один спецсимвол;
     (?=.*[a-z]) - строка содержит хотя бы одну латинскую букву в нижнем регистре;
     (?=.*[A-Z]) - строка содержит хотя бы одну латинскую букву в верхнем регистре;
     [0-9a-zA-Z!@#$%^&*]{8,} - строка состоит не менее, чем из 8 вышеупомянутых
     */
    private var handler: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var anonButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackButtons: UIStackView!
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        if isValid() {
            guard let email = loginTextField.text,
                  let password = passwordTextField.text else { return }
            Auth.auth().signIn(withEmail: email, password: password)
            performSegue(withIdentifier: "authorizationSegue", sender: nil)
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {        
        if isValid() {
            guard let email = loginTextField.text,
                  let password = passwordTextField.text else { return }
            
            Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                Auth.auth().signIn(withEmail: email, password: password)
            }
            performSegue(withIdentifier: "authorizationSegue", sender: nil)
        }
    }
    
    @IBAction func anonButtonPressed(_ sender: Any) {
        Auth.auth().signInAnonymously { [weak self] auth, error in
            if error == nil {
                self?.performSegue(withIdentifier: "authorizationSegue", sender: nil)
            } else {
                self?.showAlert(error!.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        handler = Auth.auth().addIDTokenDidChangeListener{ [weak self] auth, user in
            if user != nil {
                self?.performSegue(withIdentifier: "authorizationSegue", sender: nil)
            }
        }
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
    
    func setupViews() {
        
        for view in stackButtons.subviews {
            view.layer.cornerRadius = 6
            view.clipsToBounds = true
        }
        loginTextField.attributedPlaceholder = NSAttributedString(
            string: "E-mail",
            attributes:[NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes:[NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    func isValid() -> Bool {
        if ((loginTextField.text?.range(of: patternUsername, options: .regularExpression)) == nil) {
            showAlert("Не верный адрес электронной почты")
            return false
        }
        if ((passwordTextField.text?.range(of: patternPassword, options: .regularExpression)) == nil) {
            showAlert("Не верный пароль")
            return false
        }
        return true
    }
        
    
    private func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Ой ой",
                                                message: message,
                                                preferredStyle: .alert)
        let alertItem = UIAlertAction(title: "Исправлюсь",
                                      style: .cancel,
                                      handler: { _ in
//                                        self.loginTextField.text = ""
                                        self.passwordTextField.text = "" })
        alertController.addAction(alertItem)
        present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: keyboard
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

