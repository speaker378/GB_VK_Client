//
//  CustomInteractiveTransition.swift
//  VKClient
//
//  Created by Сергей Черных on 19.09.2021.
//

import UIKit

class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgeGesture(_:)))
            recognizer.edges = .left
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    
    var hasStarted = false
    var shouldFinish = false
    
    @objc func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            self.hasStarted = true
            self.viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = abs(translation.x) / 100
            let progress = max(0, min(1, relativeTranslation))
            self.shouldFinish = progress > 0.25
            self.update(progress)
        case . ended:
            self.hasStarted = false
            shouldFinish ? finish() : cancel()
        default:
            return
        }
    }
}
