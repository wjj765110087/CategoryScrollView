//
//  UIColorExtension.swift
//  NicooExtension
//
//  Created by 小星星 on 2018/11/15.
//

/*
 Description:
 对UIColor的扩展方法
 
 History:
 */

import UIKit

public enum GradientChangeDirection: Int {
    case level = 0          ///水平方向渐变
    case vertical = 1     //垂直方向渐变
    case upwardDiagonalLine = 2  //主对角线方向渐变
    case downDiagonalLine  //副对角线方向渐变
}

public extension UIColor {
    
    /**
     十六进制字符串初始化UIColor
     hexadecimalString 格式必须为"#123abc"，否者返回黑色
     */
    convenience init(hexadecimalString: String) {
        var tempString = hexadecimalString.trimmingCharacters(in: CharacterSet.whitespaces)
        if tempString.count != 7 {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            if tempString.hasPrefix("#") {
                tempString = String(tempString[tempString.index(tempString.startIndex, offsetBy: 1)...])
                //                tempString = tempString.substring(from: tempString.index(tempString.startIndex, offsetBy: 1))
                var range: NSRange = NSMakeRange(0, 2)
                let redString = (tempString as NSString).substring(with: range)
                range.location = 2
                let greenString = (tempString as NSString).substring(with: range)
                range.location = 4
                let blueString = (tempString as NSString).substring(with: range)
                var red: UInt32 = 0x0
                var green: UInt32 = 0x0
                var blue: UInt32 = 0x0
                Scanner.init(string: redString).scanHexInt32(&red)
                Scanner.init(string: greenString).scanHexInt32(&green)
                Scanner.init(string: blueString).scanHexInt32(&blue)
                self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0 , blue: CGFloat(blue) / 255.0, alpha: 1.0)
            } else {
                self.init(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    }
    
    
    /**
     app文字主色调
     */
    public static var mainColor: UIColor {
        return UIColor(hexadecimalString: "#945f30")
    }
    
    public convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    public convenience init(r : CGFloat, g : CGFloat, b : CGFloat, a: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    /// UIColor转UIImage
    class func creatImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context?.fill(rect)
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return colorImage!
    }
    
    
    class func colorGradientChangeWithSize(size:CGSize, direction: GradientChangeDirection, startColor: UIColor, endColor: UIColor) -> UIColor {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        var startPoint = CGPoint.zero
        if direction == .downDiagonalLine {
            startPoint = CGPoint(x: 0.0, y: 1.0)
        }
        
        gradientLayer.startPoint = startPoint
        
        var endPoint = CGPoint.zero
        switch direction {
        case .level:
            endPoint = CGPoint(x: 1.0, y: 0.0)
        case .vertical:
            endPoint = CGPoint(x: 0.0, y: 1.0)
        case .upwardDiagonalLine:
            endPoint = CGPoint(x: 1.0, y: 1.0)
        case .downDiagonalLine:
            endPoint = CGPoint(x: 1.0, y: 0.0)
        }
        
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        UIGraphicsBeginImageContext(size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor.init(patternImage: image!)
        
    }
}

