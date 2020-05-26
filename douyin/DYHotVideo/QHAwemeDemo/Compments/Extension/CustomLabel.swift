//
//  CustomLabel.swift
//  QHAwemeDemo
//
//  Created by mac on 11/26/19.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

/// label 的对齐类型
public enum VerticalAlignment {
    case top
    case middle
    case bottom
}


class CustomLabel: UILabel {
    
    var verticalAlignment : VerticalAlignment?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.verticalAlignment = VerticalAlignment.middle
        
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var textRect: CGRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        switch self.verticalAlignment {
        case .top?:
            textRect.origin.y = bounds.origin.y
        case .bottom?:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height
        case .middle?:
            fallthrough
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0
        }
        return textRect
    }
    
    override func draw(_ rect: CGRect) {
        let rect : CGRect = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: rect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
