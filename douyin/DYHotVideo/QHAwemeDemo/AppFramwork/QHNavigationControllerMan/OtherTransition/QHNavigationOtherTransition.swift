

import UIKit

class QHNavigationOtherTransition: NSObject, UINavigationControllerDelegate {

    let kQHNavigationControllerTransitionBorderlineDelta = 0.3
    
    lazy var push = QHPresentPushTransition()
    
    lazy var pop = QHPresentPopTransition()
    
    //MARK: UINavigationControllerDelegate
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return push
        }
        else if operation == .pop {
            return pop
        }
        return nil
    }
}
