

import Foundation

class ScalePresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to) as! PresentPlayController
        let fromVC = transitionContext.viewController(forKey: .from) as! UINavigationController
        let seriesVideoVC = fromVC.viewControllers.last as! SeriesVideosController
        let selectCell = seriesVideoVC.collectionView.cellForItem(at: IndexPath.init(item: seriesVideoVC.selectIndex, section: 0))
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        let initialFrame = seriesVideoVC.collectionView.convert(selectCell?.frame ?? CGRect(x: ConstValue.kScreenWdith/2, y: seriesVideoVC.view.center.y, width: 0, height: 0), to: seriesVideoVC.collectionView.superview)
        let finalFrame = transitionContext.finalFrame(for: toVC)
        let duration:TimeInterval = self.transitionDuration(using: transitionContext)
        toVC.view.center = CGPoint.init(x: initialFrame.origin.x + initialFrame.size.width/2, y: initialFrame.origin.y + initialFrame.size.height/2)
        toVC.view.transform = CGAffineTransform.init(scaleX: initialFrame.size.width/finalFrame.size.width, y: initialFrame.size.height/finalFrame.size.height)
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.2, initialSpringVelocity: 1.0, options: .layoutSubviews, animations: {
            toVC.view.center = CGPoint.init(x: finalFrame.origin.x + finalFrame.size.width/2, y: finalFrame.origin.y + finalFrame.size.height/2)
            toVC.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }) { finished in
            transitionContext.completeTransition(true)
        }
    }
}



