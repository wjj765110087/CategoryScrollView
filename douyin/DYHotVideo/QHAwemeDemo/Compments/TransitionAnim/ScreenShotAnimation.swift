

import UIKit

class ScreenShotAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    let transtionType: CWTransitionType
    
    init(presentingStyle: CWTransitionType) {
        self.transtionType  = presentingStyle
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        let duration = TimeInterval(exactly: 0.5)
        
        return duration!
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if self.transtionType == .presenting
        {
            self.presentingAnimation(using: transitionContext)
        }
        else if self.transtionType == .dismissing
        {
            self.dismissingAnimation(using: transitionContext)
        }
        
    }
    
    private func presentingAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        
        ///
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to);
        let containerView = transitionContext.containerView
        
        if let fromView = fromView,
            let toView = toView
        {
            
            let  fromViewScreenImage = self.imageScreenShot(fromView: fromView)
            fromView.isHidden = true
            
            let leftImage = self.imageCutSize(fromImage: fromViewScreenImage, cutRect: CGRect(x: 0, y: 0, width: fromViewScreenImage.size.width * 0.5, height: fromViewScreenImage.size.height))
            
            let rightImage = self.imageCutSize(fromImage: fromViewScreenImage, cutRect: CGRect(x: fromViewScreenImage.size.width * 0.5, y: 0, width: fromViewScreenImage.size.width * 0.5, height: fromViewScreenImage.size.height))
            
            let leftImageView = UIImageView(image: leftImage)
            let rightImageView = UIImageView(image: rightImage)
            
            leftImageView.frame = CGRect(x: 0, y: 0, width: leftImage!.size.width, height: leftImage!.size.height)
            leftImageView.tag = 10000;
            
            rightImageView.frame = CGRect(x: leftImage!.size.width, y: 0, width: leftImage!.size.width, height: leftImage!.size.height)
            rightImageView.tag = 20000;
            containerView.addSubview(toView)
            containerView.addSubview(leftImageView)
            containerView.addSubview(rightImageView)
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext) , animations: {
                
                let width = leftImageView.frame.size.width
                leftImageView.transform = CGAffineTransform(translationX: -width, y: 0)
                rightImageView.transform = CGAffineTransform(translationX: width, y: 0)
                
            }, completion: { (isFinished) in
                
                if isFinished && !transitionContext.transitionWasCancelled
                {
                    transitionContext.completeTransition(true)
                }
                else
                {
                    DLog("动画被取消......")
                    toView.removeFromSuperview()
                    leftImageView.removeFromSuperview()
                    rightImageView.removeFromSuperview()
                    fromView.isHidden = false
                    transitionContext.completeTransition(false)
                }
            })
            
        }
        
    }
    
    private func dismissingAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to);
        let containerView = transitionContext.containerView
        
        if let _ = fromView,
            let toView = toView
        {
            
            let leftView = containerView.viewWithTag(10000)
            let rightView = containerView.viewWithTag(20000);
            
            containerView.addSubview(toView)
            containerView.bringSubviewToFront(leftView!)
            containerView.bringSubviewToFront(rightView!)

            
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext) , animations: {
                
                leftView?.transform = CGAffineTransform(translationX: 0, y: 0)
                rightView?.transform = CGAffineTransform(translationX: 0, y: 0)
                
            }, completion: { (isFinished) in
                
                if isFinished && !transitionContext.transitionWasCancelled
                {
                    transitionContext.completeTransition(true)
                    toView.isHidden = false;
                }
                else
                {
                    toView.removeFromSuperview()
                    transitionContext.completeTransition(false)
                }
               
                
            })
            
        }
    }
    
    /// 截屏
    ///
    /// - Parameter fromView: 需要截屏的view
    /// - Returns: 截出的Image
    private func imageScreenShot(fromView: UIView) -> UIImage {
        
        var image: UIImage? = nil
        
        UIGraphicsBeginImageContext(fromView.frame.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        fromView.layer.render(in: context!)
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    private func imageCutSize(fromImage: UIImage, cutRect: CGRect) -> UIImage? {
        
        let cgImageRef = fromImage.cgImage!.cropping(to: cutRect)
        
        let smallRect = CGRect(x: 0, y: 0, width: cutRect.size.width, height: cutRect.size.height)
        
        UIGraphicsBeginImageContext(smallRect.size)
        
        let context = UIGraphicsGetCurrentContext()

//        context?.draw(cgImageRef!, in: smallRect)
        
        context?.draw(cgImageRef!, in: smallRect, byTiling: false)
        
        let image = UIImage(cgImage: cgImageRef!)
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
 }
