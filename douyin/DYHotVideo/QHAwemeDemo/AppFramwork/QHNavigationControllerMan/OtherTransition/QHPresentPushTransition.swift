

import UIKit

class QHPresentPushTransition: QHBaseTransition {
    
    let offSetHeight: CGFloat = 0
    
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        let containerView = transitionContext.containerView
        
        containerView.addSubview(fromVC!.view)
        
        let toViewFrame = CGRect(x: 0, y: fromVC!.view.frame.size.height - offSetHeight, width: fromVC!.view.frame.size.width, height: fromVC!.view.frame.size.height + offSetHeight)
        toVC?.view.frame = toViewFrame
        containerView.addSubview((toVC?.view)!)
        
        UIView.animate(withDuration: transitionDuration, delay: 0, options: .curveEaseOut, animations: {
            let fromViewFrame = fromVC?.view.frame
            toVC?.view.frame = fromViewFrame!
        }) { (bFinish) in
            toVC?.view.frame = (fromVC?.view.frame)!
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

}
