//
//  CustomPopAnimator.swift
//  VKClient
//
//  Created by Сергей Черных on 19.09.2021.
//

import UIKit

class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
              let destination = transitionContext.viewController(forKey: .to)
              else { return }
        
        transitionContext.containerView.addSubview(destination.view)

        source.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
        destination.view.frame = source.view.frame
        destination.view.layer.opacity = 0.5
        
        UIView.animate(
            withDuration: duration,
            animations: {
                source.view.transform = CGAffineTransform(rotationAngle: -.pi/2)
                destination.view.layer.opacity = 1
            }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition( finished && !transitionContext.transitionWasCancelled)
        }
    }
}
