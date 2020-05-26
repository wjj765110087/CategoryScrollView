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
    
    
}

public extension UIColor {
    
    class func colorWithRGB(r: CGFloat, g: CGFloat, b: CGFloat, alpha:CGFloat) -> UIColor
    {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    /**
     生成随机颜色
     
     - returns: 返回随机色
     */
    class func randomColor() -> UIColor
    {
        let r = CGFloat(arc4random_uniform(256))
        let g = CGFloat(arc4random_uniform(256))
        let b = CGFloat(arc4random_uniform(256))
        return UIColor.colorWithRGB(r: r, g: g, b: b, alpha: 1)
    }
    
    /**
     16进制转UIColor
     
     - parameter hex: 16进制
     
     - returns: UIColor
     */
    class func colorWithHexString(_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    class func colorWithHexString(_ hex: String, alpha: CGFloat) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
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
}
