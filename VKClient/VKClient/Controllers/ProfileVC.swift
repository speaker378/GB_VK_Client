//
//  ProfileVC.swift
//  VKClient
//
//  Created by Сергей Черных on 25.10.2021.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    @IBOutlet weak var vkIdLabel: UILabel!
    @IBOutlet weak var exitFirebaseButton: UIButton!
    
    @IBAction func exitFirebasePressed(_ sender: Any) {
        try? Auth.auth().signOut()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vkIdLabel.text = String(Session.shared.userId)
        exitFirebaseButton.layer.cornerRadius = 6
        exitFirebaseButton.clipsToBounds = true
    }
    
}
