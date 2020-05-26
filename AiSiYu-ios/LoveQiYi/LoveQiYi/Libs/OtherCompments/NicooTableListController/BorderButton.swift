

import UIKit

public enum ButtonBoderEdge: Int {
    case all = 0
    case left
    case top
    case right
    case bottom
}

open class BorderButton: UIButton {
    
    public var borderColor: UIColor = UIColor.lightGray {
        didSet {
            setNeedsDisplay()
        }
    }
    public var bordersWidth: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    public var corners: UIRectCorner? {
        didSet {
            setNeedsDisplay()
        }
    }
    public var cornerRadii: CGSize? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Public funcs
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setStrokeColor(borderColor.cgColor)
        context.setLineWidth(bordersWidth)
        
        let rectCorners = corners ?? UIRectCorner.allCorners
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: rectCorners, cornerRadii: cornerRadii ?? CGSize.zero)
        context.addPath(path.cgPath)
        context.strokePath()
    }
    
}

