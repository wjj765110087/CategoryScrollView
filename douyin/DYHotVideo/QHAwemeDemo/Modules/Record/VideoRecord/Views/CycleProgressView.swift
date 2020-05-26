//
//  CycleProgressView.swift
//  GPUImageDemo
//
//  Created by mac on 2019/4/7.
//  Copyright © 2019年 唐三彩. All rights reserved.

import UIKit

class CycleProgressView: UIView {
    var progess: CGFloat = 0.0 // 环形进度
    var label: UILabel? // 中心文本显示
    // 环形的宽
    var lineWidth: CGFloat = 0.0 
    private var foreLayer: CAShapeLayer? // 进度条的layer层（可做私有属性）
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    // 覆写父类构造器后这个方法是必须实现的
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 遍历构造器传入frame，以及进度条宽度
    convenience init(frame: CGRect, lineWidth: CGFloat) {
        self.init(frame: frame)
        self.lineWidth = lineWidth
        seup(rect: frame) // 绘制自定义视图的函数
    }
    
    func seup(rect: CGRect) -> Void {
        // 背景圆环（灰色背景）
        let shapeLayer: CAShapeLayer = CAShapeLayer.init()
        // 设置frame
        shapeLayer.frame = CGRect.init(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        shapeLayer.lineWidth = self.lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.init(red: 251/255, green: 211/255, blue: 16/255, alpha: 0.2).cgColor
        
        let center: CGPoint = CGPoint(x: rect.size.width/2, y: rect.size.height/2)
        // 画出曲线（贝塞尔曲线）
        let bezierPath: UIBezierPath = UIBezierPath.init(arcCenter: center, radius: (rect.size.width - self.lineWidth)/2, startAngle: CGFloat(-0.5 * Double.pi), endAngle: CGFloat(1.5 * Double.pi), clockwise: true)
        shapeLayer.path = bezierPath.cgPath // 将曲线添加到layer层
        
        self.layer.addSublayer(shapeLayer) // 添加蒙版
        
        // 渐变色 加蒙版 显示蒙版区域
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = NSArray.init(array: [UIColor(hexString: "#FFA500").cgColor, UIColor(hexString: "#FF8C00").cgColor, UIColor(hexString: "#FF4500").cgColor]) as? [Any]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        self.layer.addSublayer(gradientLayer) // 将渐变色添加带layer的子视图
        
        self.foreLayer = CAShapeLayer()
        self.foreLayer?.frame = self.bounds
        self.foreLayer?.fillColor = UIColor.clear.cgColor
        self.foreLayer?.lineWidth = self.lineWidth
        
        self.foreLayer?.strokeColor = UIColor.red.cgColor
        self.foreLayer?.strokeEnd = 0
        /* The cap style used when stroking the path. Options are `butt', `round'
         * and `square'. Defaults to `butt'. */
        self.foreLayer?.lineCap = CAShapeLayerLineCap.round // 设置画笔
        self.foreLayer?.path = bezierPath.cgPath
        // 修改渐变layer层的遮罩, 关键代码
        gradientLayer.mask = self.foreLayer
        
        self.label = UILabel.init(frame: self.bounds)
        self.label?.text = ""
        self .addSubview(self.label!)
        self.label?.font = UIFont.boldSystemFont(ofSize: 12)
        self.label?.textColor = UIColor.white
        self.label?.textAlignment = NSTextAlignment.center
    }
    
    func setProgress(value: CGFloat) -> Void {
        progess = value // 设置当前属性的值
        //self.label?.text = String.init(format: "%.f", 100 - progess * 100) // 设置内部Label显示的值(注意字符的格式化)
        self.foreLayer?.strokeEnd = progess // 视图改变的关键代码
    }
}

extension UIColor {
    convenience init(hexString: String) {
        var tempString = hexString.trimmingCharacters(in: CharacterSet.whitespaces)
        if tempString.count != 7 {
             self.init(red: 255, green:42, blue: 49, alpha: 1)
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
                self.init(red: 255, green:42, blue: 49, alpha: 1)
            }
        }
    }
}


