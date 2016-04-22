//
//  AlertPresentationController.swift
//  EzyGraphs
//
//  Created by Khanh Nguyen on 7/16/15.
//  Copyright © 2015 kgiants. All rights reserved.
//

import UIKit

/**
 Supplies the alert style transitioning delegate.
 */
class AlertStyleTransitioningManager: NSObject, UIViewControllerTransitioningDelegate {
    static let defaultInstance = AlertStyleTransitioningManager()
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return AlertStylePresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertStyleTransitionPresentationAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertStyleTransitionDismissalAnimator()
    }
}

class AlertStylePresentationController: UIPresentationController {
    private var dimView: UIView!
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        
        dimView = UIView()
        dimView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dimViewTapped")
        dimView.addGestureRecognizer(tapRecognizer)
    }
    
    func dimViewTapped() {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func presentationTransitionWillBegin() {
        let containerView = self.containerView!
        
        // Dim view
        dimView.frame = containerView.bounds
        dimView.alpha = 0
        containerView.insertSubview(dimView, atIndex: 0)
        
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (coordinatorContext) -> Void in
            self.dimView.alpha = 1
            
        }, completion: nil)
        
        // Slide up
        let presentedView = self.presentedView()!
        presentedView.frame = frameOfPresentedViewInContainerView()
        presentedView.transform = CGAffineTransformMakeTranslation(0, presentedView.frame.height)

        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            presentedView.transform = CGAffineTransformIdentity
            
        }) { (finished) -> Void in
        }
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (coordinatorContext) -> Void in
            self.dimView.alpha = 0
        }, completion: nil)
        
        // Slide down
        let presentedView = self.presentedView()!
        presentedView.frame = frameOfPresentedViewInContainerView()
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            presentedView.transform = CGAffineTransformMakeTranslation(0, presentedView.frame.height + 20) // 20 to accommodate for the gap when horizontal size class is Regular
        }) { (finished) -> Void in
            
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        dimView.frame = containerView!.bounds
        presentedView()?.frame = frameOfPresentedViewInContainerView()
    }

    override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let containerView = self.containerView!
        
        if presentingViewController.traitCollection.horizontalSizeClass == .Compact {
            return CGSize(width: containerView.frame.width, height: presentedViewController.preferredContentSize.height)
            
        } else {
            return CGSize(width: 375, height: presentedViewController.preferredContentSize.height)
        }
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        let bounds = containerView!.bounds
        
        let contentContainer = presentedViewController

        let sz = sizeForChildContentContainer(contentContainer, withParentContainerSize: bounds.size)

        if presentingViewController.traitCollection.horizontalSizeClass == .Compact {
            return CGRect(
                x: 0,
                y: bounds.height - sz.height,
                width: sz.width,
                height: sz.height
            ).integral
            
        } else {
            return CGRect(
                x: bounds.width / 2 - sz.width / 2,
                y: bounds.height - sz.height - 20,
                width: sz.width,
                height: sz.height
            ).integral
        }
    }
}

class AlertStyleTransitionPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()!
        
        let animationDuration = transitionDuration(transitionContext)
        
        containerView.addSubview(toViewController.view)
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            toViewController.view.transform = CGAffineTransformIdentity
            
        }, completion: { (finished) -> Void in
            transitionContext.completeTransition(finished)
        })
    }
}

class AlertStyleTransitionDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let animationDuration = self .transitionDuration(transitionContext)
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            // fromViewController.view.alpha = 0.0
            // fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
            
        }) { (finished) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}