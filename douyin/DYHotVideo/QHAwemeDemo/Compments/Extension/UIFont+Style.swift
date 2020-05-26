//
//  UIFont+Style.swift
//  QHAwemeDemo
//
//  Created by mac on 20/12/2019.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

extension UIFont {
    // 可以通过let names = UIFont.fontNames(forFamilyName: "PingFang SC") 来遍历所有PingFang 的字体名字 iOS9.0 以后支持
    /*
     PingFangSC-Medium
     PingFangSC-Semibold
     PingFangSC-Light
     PingFangSC-Ultralight
     PingFangSC-Regular
     PingFangSC-Thin
     */

    public static func pingFangRegular(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "PingFangSC-Regular", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }

    public static func pingFangMedium(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "PingFangSC-Medium", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }

    public static func pingFangSemibold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "PingFangSC-Semibold", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
    
    public static func pingFangHeavy(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "PingFangSC-Heavy", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
    
}
