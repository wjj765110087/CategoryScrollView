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
    
    ///图片压缩方法
    
    class func resetImgSize(sourceImage : UIImage,maxImageLenght : CGFloat,maxSizeKB : CGFloat) -> Data {
        
        var maxSize = maxSizeKB
        
        var maxImageSize = maxImageLenght
        if (maxSize <= 0.0) {
            maxSize = 1024.0
            
        }
        if (maxImageSize <= 0.0)  {

            maxImageSize = 1024.0
        }
        
        //先调整分辨率
        
        var newSize = CGSize.init(width: sourceImage.size.width, height: sourceImage.size.height)
        
        let tempHeight = newSize.height / maxImageSize;
        
        let tempWidth = newSize.width / maxImageSize;
        
        if (tempWidth > 1.0 && tempWidth > tempHeight) {
            
            newSize = CGSize.init(width: sourceImage.size.width / tempWidth, height: sourceImage.size.height / tempWidth)
            
        }
            
        else if (tempHeight > 1.0 && tempWidth < tempHeight){
            
            newSize = CGSize.init(width: sourceImage.size.width / tempHeight, height: sourceImage.size.height / tempHeight)
            
        }
        
        UIGraphicsBeginImageContext(newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.nativeScale)
        
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        var imageData =  UIImage.jpegData(newImage!)(compressionQuality: 0.7)!
       
        var sizeOriginKB : CGFloat = CGFloat(imageData.count) / 1024.0;
        
        //调整大小
        
        var resizeRate: CGFloat = 0.9
        
        while (sizeOriginKB > maxSize && resizeRate > 0.1) {
            
            imageData =  UIImage.jpegData(newImage!)(compressionQuality: resizeRate)!
            
            sizeOriginKB = CGFloat(imageData.count) / 1024.0;
            
            resizeRate -= 0.1;
            
        }
        
        return imageData
        
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
    
    /// 设置竖屏背景图片
    ///
    /// - Parameter url: 图片Url
    func kfSetVerticalVBackgroundImageWithUrl(_ url: String?) {
        let url = URL(string: url ?? "")
        self.kf.setBackgroundImage(with: url, for: UIControl.State.normal, placeholder: ConstValue.kVerticalPHImage, options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: nil)
    }
    
    /// 设置圆形背景图片
    func kfSetHeaderBackgroundImageWithUrl(_ url: String?, placeHolder: UIImage?) {
        let url = URL(string: url ?? "")
        self.kf.setBackgroundImage(with: url, for: UIControl.State.normal, placeholder: placeHolder, options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: nil)
    }
    /// 设置横屏背景图片
    ///
    /// - Parameter url: 图片Url
    func kfSetHorizontalBackgroundImageWithUrl(_ url: String?) {
        let url = URL(string: url ?? "")
        self.kf.setBackgroundImage(with: url, for: UIControl.State.normal, placeholder: ConstValue.kHorizontalPHImage, options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: nil)
        
    }
}
