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
    

}

