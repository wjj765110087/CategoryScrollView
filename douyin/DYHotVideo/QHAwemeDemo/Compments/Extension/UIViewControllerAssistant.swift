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
        alert.modalPresentationStyle = .fullScreen
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorMessage(_ message: String, cancelHandler: (() -> Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            cancelHandler?()
        })
        alert.addAction(cancelAction)
        alert.modalPresentationStyle = .fullScreen
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
}

extension NSObject {
    
    func getStringWithNumber(_ number: Int) -> String {
        if number >= 10000 {
            return String(format: "%.2f%@", Float(number)/10000.0, "w")
        } else {
            return String(format: "%d", number)
        }
    }
    func getShareText(_ topicTitle: String?, _ comtentSting: String?) -> String? {
        if comtentSting != nil {
            let shareText = "@抖阴短视频  #\(topicTitle ?? "") \(comtentSting!) \n 下载地址：\(AppInfo.share().share_url ?? ConstValue.kAppDownLoadLoadUrl)/\(UserModel.share().userInfo?.code ?? "")"
            return shareText
        } else {
            return ShareContentItemCell.getDefaultContentString()
        }
    }
}


// MARK: - 分享
extension UIViewController {
    /// 分享
    func share() {
        let imageToShare = UIImage(named: "iconShare")
        var downString = ConstValue.kAppDownLoadLoadUrl
        if let downloadString = AppInfo.share().share_url {
            if downloadString.hasSuffix("/") {
                downString = downloadString
            } else {
                downString = String(format: "%@%@", downloadString, "/")
            }
        }
        if let userInviteCode = UserModel.share().userInfo?.code {
            downString = String(format: "%@%@",downString, userInviteCode)
        } else {
            if let codeSave = UserDefaults.standard.object(forKey: UserDefaults.kUserInviteCode) as? String {
                downString = String(format: "%@%@", downString, codeSave)
            } else {
                downString = String(format: "%@", downString)
            }
        }
        var textShare = "抖阴小视频"
        if let textToShare = AppInfo.share().share_text {
            if textToShare.contains("{{share_url}}") {
                textShare = textToShare.replacingOccurrences(of: "{{share_url}}", with: downString)
            }
        }
        let urlToShare = NSURL(string: downString)
        let items = [textShare, imageToShare ?? "DouYin",urlToShare ?? "DouYin"] as [Any]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.copyToPasteboard,.assignToContact, .airDrop, .mail,.message, .openInIBooks, .copyToPasteboard, .print,.saveToCameraRoll, .addToReadingList]
        activityVC.completionWithItemsHandler =  { activity, success, items, error in
            NotificationCenter.default.post(name: Notification.Name.kShareActivityDownNotification, object: nil)
        }
        activityVC.modalPresentationStyle = .fullScreen
        self.present(activityVC, animated: true, completion: { () -> Void in  })
    }
    
    func share(_ image: UIImage) {
        let imageToShare = image
        let items = [imageToShare] as [Any]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.copyToPasteboard,.assignToContact, .airDrop, .mail,.message, .openInIBooks, .copyToPasteboard, .print,.saveToCameraRoll, .addToReadingList]
        activityVC.completionWithItemsHandler =  { activity, success, items, error in
            NotificationCenter.default.post(name: Notification.Name.kShareActivityDownNotification, object: nil)
        }
        activityVC.modalPresentationStyle = .fullScreen
        self.present(activityVC, animated: true, completion: { () -> Void in  })
    }
    
    func shareText(_ text: String) {
        let imageToShare = UIImage(named: "iconShare")
        var downString = ConstValue.kAppDownLoadLoadUrl
        if let downloadString = AppInfo.share().share_url {
            if downloadString.hasSuffix("/") {
                downString = downloadString
            } else {
                downString = String(format: "%@%@", downloadString, "/")
            }
        }
        if let userInviteCode = UserModel.share().userInfo?.code {
            downString = String(format: "%@%@",downString, userInviteCode)
        } else {
            if let codeSave = UserDefaults.standard.object(forKey: UserDefaults.kUserInviteCode) as? String {
                downString = String(format: "%@%@", downString, codeSave)
            } else {
                downString = String(format: "%@", downString)
            }
        }
        let urlToShare = NSURL(string: downString)
        let items = [text, imageToShare ?? "DouYin",urlToShare ?? "http://5dy.me"] as [Any]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.copyToPasteboard,.assignToContact, .airDrop, .mail,.message, .openInIBooks, .copyToPasteboard, .print,.saveToCameraRoll, .addToReadingList]
        activityVC.completionWithItemsHandler =  { activity, success, items, error in
            NotificationCenter.default.post(name: Notification.Name.kShareActivityDownNotification, object: nil)
        }
        activityVC.modalPresentationStyle = .fullScreen
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


