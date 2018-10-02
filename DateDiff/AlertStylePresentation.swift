import UIKit

/**
 Supplies the alert style transitioning delegate.
 */
class AlertStyleTransitioningManager: NSObject, UIViewControllerTransitioningDelegate {
    static let defaultInstance = AlertStyleTransitioningManager()
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return AlertStylePresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertStyleTransitionPresentationAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertStyleTransitionDismissalAnimator()
    }
}

class AlertStylePresentationController: UIPresentationController {
    private var dimView: UIView!
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        dimView = UIView()
        dimView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimViewTapped))
        dimView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dimViewTapped() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    override func presentationTransitionWillBegin() {
        let containerView = self.containerView!
        
        // Dim view
        dimView.frame = containerView.bounds
        dimView.alpha = 0
        containerView.insertSubview(dimView, at: 0)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (coordinatorContext) -> Void in
            self.dimView.alpha = 1
            
        }, completion: nil)
        
        // Slide up
        let presentedView = self.presentedView!
        presentedView.frame = self.frameOfPresentedViewInContainerView
        presentedView.transform = CGAffineTransform(translationX: 0, y: presentedView.frame.height)

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { () -> Void in
            presentedView.transform = .identity
            
        }) { (finished) -> Void in
        }
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (coordinatorContext) -> Void in
            self.dimView.alpha = 0
        }, completion: nil)
        
        // Slide down
        let presentedView = self.presentedView!
        presentedView.frame = self.frameOfPresentedViewInContainerView
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { () -> Void in
            presentedView.transform = CGAffineTransform(translationX: 0, y: presentedView.frame.height + 20) // 20 to accommodate for the gap when horizontal size class is Regular
        }) { (finished) -> Void in
            
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        dimView.frame = containerView!.bounds
        presentedView?.frame = self.frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let containerView = self.containerView!
        
        if presentingViewController.traitCollection.horizontalSizeClass == .compact {
            return CGSize(width: containerView.frame.width, height: presentedViewController.preferredContentSize.height)
            
        } else {
            return CGSize(width: 375, height: presentedViewController.preferredContentSize.height)
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = containerView!.bounds
        
        let contentContainer = presentedViewController
        
        let sz = size(forChildContentContainer: contentContainer, withParentContainerSize: bounds.size)
        
        if presentingViewController.traitCollection.horizontalSizeClass == .compact {
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
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            toViewController.view.transform = .identity
            
        }, completion: { (finished) -> Void in
            transitionContext.completeTransition(finished)
        })
    }
}

class AlertStyleTransitionDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let animationDuration = self .transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            // fromViewController.view.alpha = 0.0
            // fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
            
        }) { (finished) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
