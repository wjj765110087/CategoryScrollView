

import Foundation

/// 发现2的视频观看消失时动画， 系列标签详情 动画
class ScaleDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    let centerFrame = CGRect.init(x: (screenWidth - 5)/2, y: (screenHeight - 5)/2, width: 5, height: 5)
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from) as! PresentPlayController
        let toVC = transitionContext.viewController(forKey: .to) as! UINavigationController
        let seriesVideosVC = toVC.viewControllers.last as! SeriesVideosController
        var snapshotView:UIView?
        var scaleRatio:CGFloat = 1.0
        var finalFrame:CGRect = centerFrame
        if let selectCell = seriesVideosVC.collectionView.cellForItem(at: IndexPath(item: fromVC.currentIndex, section: 0)) {
            snapshotView = selectCell.snapshotView(afterScreenUpdates: false)
            scaleRatio = fromVC.view.frame.width/selectCell.frame.width
            snapshotView?.layer.zPosition = 20
            finalFrame = seriesVideosVC.collectionView.convert(selectCell.frame, to: seriesVideosVC.collectionView.superview)
        } else {
            snapshotView = fromVC.view.snapshotView(afterScreenUpdates: false)
            scaleRatio = fromVC.view.frame.width/screenWidth
            finalFrame = centerFrame
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(snapshotView!)
        let duration = self.transitionDuration(using: transitionContext)
        fromVC.view.alpha = 0.0
        snapshotView?.center = fromVC.view.center
        snapshotView?.transform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.2, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            snapshotView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            snapshotView?.frame = finalFrame
        }) { finished in
            transitionContext.finishInteractiveTransition()
            transitionContext.completeTransition(true)
            snapshotView?.removeFromSuperview()
        }
    }
    
}



/// 喜欢的视频观看消失时动画
class ScaleDismissAnimationForFavor: NSObject, UIViewControllerAnimatedTransitioning {
    
    let centerFrame = CGRect.init(x: (screenWidth - 5)/2, y: (screenHeight - 5)/2, width: 5, height: 5)
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from) as! AcountVideoPlayController
        let toVC = transitionContext.viewController(forKey: .to) as! QHTabBarViewController
        let controlVC = toVC.viewControllers!.last as! QHNavigationController
        let favorVideosVC = controlVC.viewControllers.first as! FavorVideosController
        var snapshotView:UIView?
        var scaleRatio:CGFloat = 1.0
        var finalFrame:CGRect = centerFrame
        if let selectCell = favorVideosVC.collectionView.cellForItem(at: IndexPath(item: fromVC.currentIndex, section: 0)) {
            snapshotView = selectCell.snapshotView(afterScreenUpdates: true)
            if snapshotView == nil {
                snapshotView = fromVC.view.snapshotView(afterScreenUpdates: false)
            }
            scaleRatio = fromVC.view.frame.width/selectCell.frame.width
            snapshotView?.layer.zPosition = 20
            finalFrame = favorVideosVC.collectionView.convert(selectCell.frame, to: favorVideosVC.collectionView.superview)
        } else {
            snapshotView = fromVC.view.snapshotView(afterScreenUpdates: false)
            scaleRatio = fromVC.view.frame.width/screenWidth
            finalFrame = centerFrame
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(snapshotView!)
        let duration = self.transitionDuration(using: transitionContext)
        fromVC.view.alpha = 0.0
        snapshotView?.center = fromVC.view.center
        snapshotView?.transform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.2, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
            snapshotView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            snapshotView?.frame = finalFrame
        }) { finished in
            transitionContext.finishInteractiveTransition()
            transitionContext.completeTransition(true)
            snapshotView?.removeFromSuperview()
        }
    }
    
}

