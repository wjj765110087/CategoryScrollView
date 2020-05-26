//
//  UILableExtension.swift
//  NicooExtension
//
//  Created by 小星星 on 2018/11/15.
//

import Foundation
import UIKit
public extension UILabel {
    
    /**
     获得一个label的宽度
     
     - parameter maxWidth:label的最大宽度
     - parameter maxHeight:label的最大高度
     
     - returns:  CGFloat: 获得label的宽度
     */
    func getStatisticsWidth(_ maxWidth: CGFloat, maxHeight: CGFloat) -> CGFloat {
        if let text = self.text, text.count > 0 {
            var attributes: [NSAttributedString.Key: Any]!
            let rangePointer = NSRangePointer.allocate(capacity: MemoryLayout<NSRange>.size)
            rangePointer.initialize(to: NSMakeRange(0, self.text!.count))
            if let aAttributes = self.attributedText?.attributes(at: 0, effectiveRange: rangePointer) {
                attributes = aAttributes
            } else {
                //attributes = [NSAttributedStringKey.font: self.font]
                attributes[NSAttributedString.Key.font] = self.font
            }
            let string: NSString = NSString(cString: text.cString(using: String.Encoding.utf8)!, encoding: String.Encoding.utf8.rawValue)!
            let size = string.boundingRect(with: CGSize(width: maxWidth, height: maxHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
            return size.width + 1
        }
        return 0
    }
    
    /*
     //NSMutableParagraphStyle:段落样式类
     
     //lineHeightMultiple: attributedString 显示的是否偏上、偏下、调节这个值可以使得attributeString居中，之前大家用boundingRectWithSize这个方法得出的高度可能会不太准确，如今加入NSMutableParagraphStyle这个类以后，可以再试试
     ————————————————
    */
    
    func getLabelSize(attr: NSAttributedString, paragraphStyle: NSTextAlignment, lineHeightMultiole: CGFloat, font: CGFloat, maxWidth: CGFloat) -> CGFloat {
        let paragraphStyle =  NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineHeightMultiple = lineHeightMultiole
        let str = NSMutableAttributedString(attributedString: attr)
        str.setAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: font), NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: str.length))
        let size = str.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
        return size.height
    }
    
    func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil).size
    }
}

extension UITextField {
    
    func setPlaceholderTextColor(placeholderText: String, color: UIColor) {
        if #available(iOS 13.0, *) {
            self.attributedPlaceholder = NSAttributedString.init(string: placeholderText, attributes:  [NSAttributedString.Key.foregroundColor: color])
        } else {
            self.setValue(UIColor.lightGray, forKeyPath: "_placeholderLabel.textColor")
        }
    }
}
