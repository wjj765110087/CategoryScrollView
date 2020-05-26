//
//  UIViewControllerAssistant.swift
//  NicooExtension
//
//  Created by 小星星 on 2018/11/15.
//

import Foundation
import UIKit

public extension UIViewController {
    
    /// 显示对话框
    func showDialog(title: String?, message: String, okTitle: String?, cancelTitle: String?, okHandler: (() -> Void)?, cancelHandler: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelTitle ?? "" , style: .cancel, handler: { alertAction in
            if let cancelHandler = cancelHandler {
                cancelHandler()
            }
        })
        let OkAction = UIAlertAction(title: okTitle ?? "" , style: .default, handler: { alertAction in
            if let okHandler = okHandler {
                okHandler()
            }
        })
        if cancelTitle != nil {
            alert.addAction(cancelAction)
        }
        if okTitle != nil {
            alert.addAction(OkAction)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorMessage(_ message: String, cancelHandler: (() -> Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            cancelHandler?()
        })
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    class func currentViewController(_ baseVC: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = baseVC as? UINavigationController {
            return currentViewController(nav.visibleViewController)
        }
        if let tab = baseVC as? UITabBarController {
            return currentViewController(tab.selectedViewController)
        }
        if let presented = baseVC?.presentedViewController {
            return currentViewController(presented)
        }
        return baseVC
    }
    
    func isVisible() -> Bool {
        return self.isViewLoaded && self.view.window != nil
    }
    
    func getStringWithNumber(_ number: Int) -> String {
        if number >= 10000 {
            return String(format: "%.2f%@", Float(number)/10000.0, "W")
        } else {
            return String(format: "%d", number)
        }
    }
    
}


// MARK: - 分享
extension UIViewController {
    /// 分享
    func share() {
        
        let imageToShare = UIImage(named: "shareIcon")
        
        var downString = ConstValue.kAppDownLoadLoadUrl
        if let downloadString = AppInfo.share().appInfo?.share_url {
            if downloadString.hasSuffix("/") {
                downString = downloadString
            } else {
                downString = String(format: "%@%@", downloadString, "/")
            }
        }
        
        if let userInviteCode = UserModel.share().userInfo?.invite_code {
            downString = String(format: "%@%@",downString, userInviteCode)
        } else {
            if let codeSave = UserDefaults.standard.object(forKey: UserDefaults.kUserInviteCode) as? String {
                downString = String(format: "%@%@", downString, codeSave)
            } else {
                downString = String(format: "%@", downString)
            }
        }
        var textShare = "爱私欲"
        if let textToShare = AppInfo.share().appInfo?.share_text {
            if textToShare.contains("{{share_url}}") {
                textShare = textToShare.replacingOccurrences(of: "{{share_url}}", with: downString)
            }
        }
        let urlToShare = NSURL(string: downString)
        let items = [textShare, imageToShare ?? "爱私欲",urlToShare ?? "爱私欲"] as [Any]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.completionWithItemsHandler =  { activity, success, items, error in }
        self.present(activityVC, animated: true, completion: { () -> Void in  })
    }
    
    func shareWith(_ text: String, _ linkUrl: String) {
        let textToShare = text
        let imageToShare = UIImage(named: "shareIcon")
        let linkString = linkUrl
        
        let urlToShare = NSURL(string: linkString)
        let items = [textToShare, imageToShare ?? "爱私欲" ,urlToShare ?? "爱私欲"] as [Any]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.completionWithItemsHandler =  { activity, success, items, error in }
        self.present(activityVC, animated: true, completion: { () -> Void in  })
    }
}


// MARK: - 国际化
extension UIViewController {
    
    class func localStr(_ key: String) -> String {
        let title = NSLocalizedString(key,comment:"default")
        return title
    }
    
    func localStr(_ key: String) -> String {
        let title = NSLocalizedString(key,comment:"default")
        return title
    }
  
    private struct AssociatedKey {
        static var isPush = "isPush"
        static var navBarAnimatedBlock = "navBarAnimatedBlock"
    }
    
    /// 是不是动画隐藏导航栏
    var isNavAnimated: Bool {
        get {
            guard let number: NSNumber = objc_getAssociatedObject(self, &AssociatedKey.isPush) as? NSNumber else {
                return false
            }
            return number.boolValue
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedKey.isPush, NSNumber(value: value as Bool), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
   
}


