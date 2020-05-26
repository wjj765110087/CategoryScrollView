
import UIKit

enum  CWTransitionType{
    
    case presenting
    case dismissing
}

enum CWTransitionGestureDeriction {
    case left
    case right
    case up
    case dowm
}

class TransitionHelper: NSObject, UIViewControllerAnimatedTransitioning{
    
    private let transitionType: CWTransitionType
    let animationDuration: TimeInterval
    
    init(transitionType: CWTransitionType) {
        self.transitionType = transitionType
        self.animationDuration = 0.5
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if self.transitionType == .presenting
        {
            self.presenting(with: transitionContext)
        }
        else if self.transitionType == .dismissing
        {
            self.dismissingWith(transitionContext)
        }
        
    }
    
    /// present动画
    ///
    /// - Parameter transitionContext: transitionContext description
    private func presenting(with transitionContext: UIViewControllerContextTransitioning) {
        
        ///被跳转的controller 和 view
//        let fromViewController = transitionContext.viewController(forKey: .from)
        let fromView = transitionContext.view(forKey: .from)
        
        ///要跳转到的controller 和 view
//        let toViewController = transitionContext.viewController(forKey: .to)
        let toView = transitionContext.view(forKey: .to)
        
        ///动画发生的场景view
        let containerView = transitionContext.containerView
        
        DLog("presenting:\(containerView.subviews.count)")
        
        /*
            注意:无论是present还是dismiss模式, 此时containerView的subviews中已经含有了fromView
            所以只用将toView添加到containerView中就可以了.
            当然如果你是使用截图动画,那么,可以将截图view添加到containerView中,这个在以后再讲,此处不做讨论
         */
        containerView.addSubview(toView!)
        
        ///该篇主要是学习自定义动画的流程,所以动画的实现就不做过多讨论,这里就给一个简单的弹簧动画
        ///先设置将要跳转的界面的初始状态
        let height: CGFloat = fromView!.frame.size.height
        let width: CGFloat = fromView!.frame.size.width
        
        toView?.frame = CGRect(x: 0, y: height, width: width, height: height)
        
        UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.0 / 0.65, options: .allowAnimatedContent, animations:  {

            toView?.frame = fromView!.bounds

        }, completion:  { isFinished in
            
            ///如果动画被中断
            if transitionContext.transitionWasCancelled
            {
                
            }
            else
            {
                ///千万不要忘记在动画调用结束后，执行completeTransition方法。
                let isComplete = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(isComplete && isFinished)
            }
            
        })
        
    }
    
    
    /// dismiss动画
    ///
    /// - Parameter transitionContext: transitionContext description
    private func dismissingWith(_ transitionContext: UIViewControllerContextTransitioning) {
        
        ///被跳转的controller 和 view
//        let fromViewController = transitionContext.viewController(forKey: .from)
        let fromView = transitionContext.view(forKey: .from)
        
        ///要跳转到的controller 和 view
//        let toViewController = transitionContext.viewController(forKey: .to)
        let toView = transitionContext.view(forKey: .to)
        
        ///动画发生的场景view
        let containerView = transitionContext.containerView
        
        /*
         注意:无论是present还是dismiss模式, 此时containerView的subviews中已经含有了fromView
         所以只用将toView添加到containerView中就可以了.
         当然如果你是使用截图动画,那么,可以将截图view添加到containerView中,这个在以后再讲,此处不做讨论
         */
        containerView.addSubview(toView!)
        let height: CGFloat = fromView!.frame.size.height
        containerView.bringSubviewToFront(fromView!);
        
        UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.0 / 0.65, options: .allowAnimatedContent, animations:  {
            
            fromView?.transform = CGAffineTransform(translationX: 0, y: height)
            
        }, completion:  { isFinish in
            
            ///如果动画被中断
            if transitionContext.transitionWasCancelled
            {
                
            }
            else
            {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
        })
    }
    
    
    /// 截屏
    ///
    /// - Parameter fromView: 需要截屏的view
    /// - Returns: 截出的view
    func screenView(fromView: UIView) -> UIView {
        
        UIGraphicsBeginImageContext(fromView.frame.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        fromView.layer.render(in: context!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(image: image)
        imageView.frame = fromView.bounds
        let view = UIView(frame: fromView.bounds)
        view.addSubview(imageView)
        
        return view
    }
    
}
