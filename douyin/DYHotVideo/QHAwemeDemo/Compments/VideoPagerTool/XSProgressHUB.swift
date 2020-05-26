//
//  XSProgressHUB.swift
//  XSVideo
//
//  Created by pro5 on 2019/1/16.
//  Copyright © 2019年 pro5. All rights reserved.
//

import Foundation
import MBProgressHUD

/// 对MBProgressHUD 的二次封装，便于替换
class XSProgressHUD: NSObject {
    
    static private let instance: XSProgressHUD = XSProgressHUD()
    class func shareHub() -> XSProgressHUD {
        return instance
    }
    
    var hud: MBProgressHUD?
    
    enum HUBType {
        case SingleLoading   // 菊花加载
        case TextOnlyType    // 纯文字
        case SuccessType     // 成功
        case CycleLoading    // 环形加载
        case CustomAnimation // 自定义帧动画
        case CustomerImage   // 自定义图片
    }
    
    private class func showAdded(to view: UIView, type: HUBType, _ msg: String? = nil, _ customImage: UIImageView? = nil , _ bgColor: UIColor? = nil, animated: Bool) {
        //已存在，先移除
        if XSProgressHUD.shareHub().hud != nil {
            XSProgressHUD.shareHub().hud!.hide(animated: animated)
            XSProgressHUD.shareHub().hud = nil
        }
        view.endEditing(true)  // 防止键盘遮挡
        XSProgressHUD.shareHub().hud = MBProgressHUD.showAdded(to: view, animated: animated)
       // XSProgressHUD.shareHub().hud?.dimBackground = true // 是否显示半透明 背景
        XSProgressHUD.shareHub().hud?.margin = 10
        XSProgressHUD.shareHub().hud?.removeFromSuperViewOnHide = true
        XSProgressHUD.shareHub().hud?.detailsLabel.text = msg ?? ""
        XSProgressHUD.shareHub().hud?.detailsLabel.font = UIFont.systemFont(ofSize: 14)
        switch type {
        case .TextOnlyType:
            XSProgressHUD.shareHub().hud?.mode = .text
            break
        case .SingleLoading:
            XSProgressHUD.shareHub().hud?.mode = .indeterminate
            break
        case .SuccessType:
            XSProgressHUD.shareHub().hud?.mode = .customView
            XSProgressHUD.shareHub().hud?.customView = UIImageView(image: UIImage(named: "success"))
            break
        case .CycleLoading:
            XSProgressHUD.shareHub().hud?.mode = .customView
            XSProgressHUD.shareHub().hud?.bezelView.style = .solidColor // (1.+ 版本这样赋值)
            XSProgressHUD.shareHub().hud?.offset = CGPoint(x: 0, y: 100)
            XSProgressHUD.shareHub().hud?.bezelView.backgroundColor = UIColor(white: 1, alpha: 0.5)
            let imgView = UIImageView(image: UIImage(named: "Alert_nono"))
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.toValue = Double.pi * 2
            animation.duration = 1.0
            animation.repeatCount = 1000000
            imgView.layer.add(animation, forKey: nil)
            XSProgressHUD.shareHub().hud?.customView = imgView
            break
        case .CustomAnimation:
            XSProgressHUD.shareHub().hud?.mode = .customView
            XSProgressHUD.shareHub().hud?.bezelView.style = .solidColor // (1.+ 版本这样赋值)
            XSProgressHUD.shareHub().hud?.bezelView.backgroundColor = UIColor.clear
            XSProgressHUD.shareHub().hud?.backgroundColor = bgColor
            XSProgressHUD.shareHub().hud?.customView = customImage
            break
        case .CustomerImage:
            XSProgressHUD.shareHub().hud?.mode = .customView
            if customImage != nil {
                XSProgressHUD.shareHub().hud?.customView = customImage
            }
            break
        }
    }
    /// 文字，1.5秒自动消失
    class func showMsg(to view: UIView, msg: String?, animated: Bool) {
        showAdded(to: view, type: .TextOnlyType, msg, nil, nil, animated: animated)
        XSProgressHUD.shareHub().hud?.hide(animated: animated, afterDelay: 1.5)
    }
    /// 文字加图片，1.5秒自动消失
    class func showMsgWith(customImage: UIImageView, msg: String, onView: UIView, animated: Bool) {
        showAdded(to: onView, type: .CustomerImage, msg, customImage, nil, animated: animated)
        XSProgressHUD.shareHub().hud?.hide(animated: animated, afterDelay: 1.5)
    }
    /// 显示成功
    class func showSuccess(msg: String?, onView: UIView, animated: Bool) {
        showAdded(to: onView, type: .SuccessType, msg, nil, nil, animated: animated)
        XSProgressHUD.shareHub().hud?.hide(animated: animated, afterDelay: 1.5)
    }
    /// Single Loading
    class func showProgress(msg: String?, onView: UIView, animated: Bool) {
        showAdded(to: onView, type: .SingleLoading, msg, nil, nil, animated: animated)
    }
    /// Cycle Loading
    class func showCycleProgress(msg: String?, onView: UIView, animated: Bool) {
        showAdded(to: onView, type: .CycleLoading, msg, nil, nil, animated: animated)
    }
    /// Custom Animation
    class func showCustomAnimation(msg: String?, onView: UIView, imageNames: [String]?, bgColor: UIColor? = UIColor.clear, animated: Bool) {
        var images = [UIImage]()
        if imageNames == nil {
            let imageNameArray = ConstValue.refreshImageNames
            for name in imageNameArray {
                if let image = UIImage(named: name) {
                    images.append(image)
                }
            }
        } else {
            for name in imageNames! {
                if let image = UIImage(named: name) {
                    images.append(image)
                }
            }
        }
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.animationImages = images
        imageView.animationRepeatCount = 100000
        imageView.animationDuration = 0.075 * Double(images.count + 1)
        imageView.startAnimating()
        showAdded(to: onView, type: .CustomAnimation, msg, imageView, bgColor, animated: animated)
    }
    /// 消失
    class func hide(for: UIView, animated: Bool) {
        if XSProgressHUD.shareHub().hud != nil {
            XSProgressHUD.shareHub().hud?.hide(animated: animated)
        }
    }
    
}
