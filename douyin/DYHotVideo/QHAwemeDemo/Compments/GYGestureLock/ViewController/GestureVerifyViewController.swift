

import UIKit

/// 手势密码验证 （删除前先验证）
class GestureVerifyViewController: UIViewController {
    
    
    /// 默认为验证手势
    var isToSetNewGesture:Bool = false
    
    fileprivate var msgLabel: GYLockLabel?
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "关闭手势密码"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    /// 是否隐藏导航栏
    var navBarHiden: Bool = false {
        didSet {
            navBar.isHidden = navBarHiden
        }
    }
    
    var verifySuccess:(() ->Void)?
    var verifyCancleOrFailed:(() ->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(navBar)
        layoutNavBar()
        
        let lockView = GYCircleView()
        lockView.delegate = self
        lockView.type = CircleViewType.circleViewTypeVerify
        view.addSubview(lockView)
        
        let msgLabel = GYLockLabel()
        msgLabel.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 14)
        msgLabel.center = CGPoint(x: kScreenW/2, y: lockView.frame.minY - 30)
        msgLabel.showNormalMag(gestureTextOldGesture as NSString)
        self.msgLabel = msgLabel
        view.addSubview(msgLabel)
    
    }
}

// MARK: - GYCircleViewDelegate
extension GestureVerifyViewController: GYCircleViewDelegate {
    
    func circleViewdidCompleteLoginGesture(_ view: GYCircleView, type: CircleViewType, gesture: String, result: Bool) {
        
        if type == CircleViewType.circleViewTypeVerify {
            if result {
                DLog("验证成功")
                if isToSetNewGesture {
                    let gesture = GestureViewController()
                    gesture.type = GestureViewControllerType.setting
                    navigationController?.pushViewController(gesture, animated: true)
                    
                } else {
                    verifySuccess?()
                    navigationController?.popViewController(animated: true)
                }
                
            } else {
                DLog("密码错误!")
                self.msgLabel?.showWarnMsg(gestureTextGestureVerifyError)
            }
        }
        
    }
    
    func circleViewdidCompleteSetFirstGesture(_ view: GYCircleView, type: CircleViewType, gesture: String) {
        
    }
    
    func circleViewConnectCirclesLessThanNeedWithGesture(_ view: GYCircleView, type: CircleViewType, gesture: String) {
        
    }
    
    func circleViewdidCompleteSetSecondGesture(_ view: GYCircleView, type: CircleViewType, gesture: String, result: Bool) {
        
    }
    
}

// MARK: - QHNavigationBarDelegate
extension GestureVerifyViewController:  QHNavigationBarDelegate  {
    
    func backAction() {
        verifyCancleOrFailed?()
        navigationController?.popViewController(animated: true)
       
    }
}

extension GestureVerifyViewController {
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    
}
