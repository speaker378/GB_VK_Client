//
//  CustomPushAnimator.swift
//  VKClient
//
//  Created by Сергей Черных on 19.09.2021.
//

import UIKit

class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
              let destination = transitionContext.viewController(forKey: .to)
              else { return }
        
        transitionContext.containerView.addSubview(destination.view)

        destination.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
        destination.view.frame = source.view.frame
        destination.view.transform = CGAffineTransform(rotationAngle: -.pi/2)
        
        UIView.animate(
            withDuration: duration,
            animations: {
                destination.view.transform = .identity
                source.view.layer.opacity = 0.5
            }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.layer.opacity = 1
            }
            transitionContext.completeTransition( finished && !transitionContext.transitionWasCancelled)
        }
    }
}
