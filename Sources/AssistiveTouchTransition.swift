//
//  AssistiveTouchTransition.swift
//  AssistiveTouch
//
//  Created by Jack on 2018/8/24.
//  Copyright © 2018 XWJACK. All rights reserved.
//

import UIKit

/// Using https://github.com/loopeer/AlertTransition for given more transition
open class AssistiveTouchTransition: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    //MARK: - UIViewControllerAnimatedTransitioning
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        if toController.isBeingPresented {
            containerView.addSubview(toController.view)
            
            let offset: CGFloat = 20
            let size = min(UIScreen.main.bounds.size.width - offset * 2, UIScreen.main.bounds.size.height - offset * 2)
            toController.view.frame = CGRect(x: offset, y: (UIScreen.main.bounds.height - size) / 2, width: size, height: size)
            toController.view.alpha = 0.5
            toController.view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toController.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                toController.view.alpha = 1
                
                fromController.view.alpha = 0
            }) {
                transitionContext.completeTransition($0)
            }
        } else {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromController.view.alpha = 0
                toController.view.alpha = 1
            }) {
                transitionContext.completeTransition($0)
            }
        }
    }
}
