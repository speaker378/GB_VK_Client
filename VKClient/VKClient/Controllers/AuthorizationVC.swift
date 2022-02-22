//
//  AuthorizationVC.swift
//  VKClient
//
//  Created by Сергей Черных on 30.09.2021.
//

import UIKit
import WebKit
import Firebase

class AuthorizationVC: UIViewController {
    
    @IBOutlet weak var webview: WKWebView! {
        didSet {
            webview.navigationDelegate = self
        }
    }
    
    let request = NetworkServiceProxy(networkService: NetworkService()).getAuthorizeRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.load(request)
    }

}


extension AuthorizationVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
              url.path == "/blank.html",
              let fragment = url.fragment
        else { return decisionHandler(.allow) }
        
        let parameters = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, params in
            var dict = result
            let key = params[0]
            let value = params[1]
            dict[key] = value
            return dict
        }
        
        guard let token = parameters["access_token"],
              let userIdString = parameters["user_id"],
              let userId = Int(userIdString)
        else { return decisionHandler(.allow) }
        
            Session.shared.token = token
            Session.shared.userId = userId
            saveCurrentUserIdToFirebase()
            performSegue(withIdentifier: "loginSegue", sender: nil)
        
        decisionHandler(.cancel)
    }
    
    private func saveCurrentUserIdToFirebase() {
        let storageRef = Database.database().reference(withPath: "users")
        storageRef.child(String(Session.shared.userId)).child("id").setValue(Session.shared.userId)
    }
}
