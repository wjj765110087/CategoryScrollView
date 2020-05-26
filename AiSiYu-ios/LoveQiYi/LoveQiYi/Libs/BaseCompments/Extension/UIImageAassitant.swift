//
//  UIImageAassitant.swift
//  NicooExtension
//
//  Created by 小星星 on 2018/11/15.
//

import Foundation
import UIKit
public extension UIImage {
    
    //纯色转图片
    class func imageFromColor(_ color: UIColor, frame: CGRect) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        return image!
    }
    
}


public extension UIImageView {
    
    /// 设置竖屏图片
    ///
    /// - Parameter url: 图片Url
    func kfSetVerticalImageWithUrl(_ url: String?) {
        let url = URL(string: url ?? "")
        self.kf.setImage(with: url, placeholder: ConstValue.kVerticalPHImage, options: [.transition(.fade(0.2))])
    }
    
    /// 设置圆形图片
    func kfSetHeaderImageWithUrl(_ url: String?, placeHolder: UIImage?) {
        let url = URL(string: url ?? "")
        self.kf.setImage(with: url, placeholder: placeHolder, options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: nil)
    }
    
    /// 设置横屏图片
    ///
    /// - Parameter url: 图片Url
    func kfSetHorizontalImageWithUrl(_ url: String?) {
        let url = URL(string: url ?? "")
        self.kf.setImage(with: url, placeholder: ConstValue.kHorizontalPHImage, options: [.transition(.fade(0.2))])
    }
}


public extension UIButton {
    
    /// 设置竖屏图片
    ///
    /// - Parameter url: 图片Url
    func kfSetVerticalImageWithUrl(_ url: String?) {
        let url = URL(string: url ?? "")
        self.kf.setImage(with: url, for: UIControl.State.normal, placeholder: ConstValue.kVerticalPHImage, options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: nil)
    }
    
    /// 设置圆形图片
    func kfSetHeaderImageWithUrl(_ url: String?, placeHolder: UIImage?) {
        let url = URL(string: url ?? "")
        self.kf.setImage(with: url, for: UIControl.State.normal, placeholder: placeHolder, options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: nil)
    }
    
    /// 设置横屏图片
    ///
    /// - Parameter url: 图片Url
    func kfSetHorizontalImageWithUrl(_ url: String?) {
        let url = URL(string: url ?? "")
        self.kf.setImage(with: url, for: UIControl.State.normal, placeholder: ConstValue.kHorizontalPHImage, options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: nil)
        
    }
    /// 设置背景图片
    ///
    /// - Parameter url: 图片Url
    func kfSetBackgroundImageWithUrl(_ url: String?) {
        let url = URL(string: url ?? "")
        self.kf.setBackgroundImage(with: url, for: UIControl.State.normal, placeholder: ConstValue.kVerticalPHImage, options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: nil)
    }
}
