//
//  CustomNavigationController.swift
//  VKClient
//
//  Created by Сергей Черных on 19.09.2021.
//

import UIKit

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
           return CustomPushAnimator()
        case .pop:
            return CustomPopAnimator()
        default:
            return nil
        }
    }
}
