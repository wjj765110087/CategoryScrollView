//
//  UIButton+tap.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/9/7.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import Foundation


// MARK: - 暂时解决不了 UITabBarButton 这种情况的处理办法，此分类暂时不能使用
extension UIButton {
    
    private static var ForbidIntervalKey = "ForbidIntervalKey"
    private static var LastClickTimeKey = "LastClickTimeKey"
    
    public class func startForbidContinuousClick() {
        
        let onceToken = "onceToken"
        
        DispatchQueue.once(token: onceToken) {
            DLog("startForbidContinuousClick")
            if let originalMethod: Method = class_getInstanceMethod(self.classForCoder(), #selector(UIButton.sendAction)),
                let newMethod: Method = class_getInstanceMethod(self.classForCoder(), #selector(UIButton.jf_sendAction(action:to:forEvent:))) {
                
                if class_addMethod(self.classForCoder(), #selector(UIButton.jf_sendAction(action:to:forEvent:)), newMethod, method_getTypeEncoding(newMethod)) {
                    class_replaceMethod(self.classForCoder(), #selector(UIButton.sendAction), originalMethod, method_getTypeEncoding(originalMethod))
                } else {
                    method_exchangeImplementations(originalMethod, newMethod)
                }
            }
        }
    }
    
    /// 按钮不能被重复点击的时间间隔（默认0秒）
    var forbidInterval: TimeInterval {
        get {
            if let interval = objc_getAssociatedObject(self, &UIButton.ForbidIntervalKey) as? TimeInterval {
                return interval
            }
            return 0.15
        }
        
        set {
            objc_setAssociatedObject(self, &UIButton.ForbidIntervalKey, newValue as TimeInterval, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }




/// 存储上次点击的时间(默认是1970年的时间)
private var lastClickDate: Date {
    get {
        if let lastDate = objc_getAssociatedObject(self, &UIButton.LastClickTimeKey) as? Date {
            return lastDate
        }
        return Date.init(timeIntervalSince1970: 0)
    }
    
    set {
        objc_setAssociatedObject(self, &UIButton.LastClickTimeKey, newValue as Date, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

@objc dynamic func jf_sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
    
    if NSStringFromClass(self.classForCoder) == "UITabBarButton" {
        return
    }
    
    if Date().timeIntervalSince(lastClickDate) > forbidInterval {
        self.jf_sendAction(action: action, to: target, forEvent: event)
        lastClickDate = Date()
        
    }
}

}

extension DispatchQueue {
    private static var onceTracker = [String]()
    public class func once(token: String, block: () -> ()) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if onceTracker.contains(token) {
            return
        }
        onceTracker.append(token)
        block()
    }
}
