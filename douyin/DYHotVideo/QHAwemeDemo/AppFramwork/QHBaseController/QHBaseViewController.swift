//


import UIKit
import SnapKit

class QHBaseViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        self.navigationController?.setNavigationBarHidden(true, animated: false);
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}
