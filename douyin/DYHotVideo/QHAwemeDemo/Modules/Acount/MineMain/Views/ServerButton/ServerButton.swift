//
//  ServerButton.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/25.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

// 声明协议
protocol FloatDelegate {
    func singleClick()
    
    func repeatClick()
}

class ServerButton: UIButton {
    
    // 是否可拖拽
    var isDragEnable: Bool = true
    
    // 拖拽后是否自动移到边缘
    var isAbsortEnable: Bool = true
    
    // 背景颜色
    var bgColor: UIColor? = UIColor.clear
    
    // 正常情况下 透明度
    var alphaOfNormol: CGFloat = 0.75
    
    // 拖拽时的透明度
    var alphaOfDrag: CGFloat = 0.95
    
    // 圆角大小
    var radiuOfButton: CGFloat = 12 {
        didSet {
           self.layer.cornerRadius = radiuOfButton
        }
    }
    
    // 拖拽结束后的等待时间
    var timeOfWait: CGFloat = 1.5
    
    // 拖拽结束后的过渡动画时间
    var timeOfAnimation: CGFloat = 0.3
    
    // 按钮距离边缘的内边距
    var paddingOfbutton: CGFloat = 2
    
    // 代理
    var delegate: FloatDelegate? = nil
    
    // 计时器
    fileprivate var timer: Timer? = nil
    
    // 内部使用 起到数据传递的作用
    fileprivate var allPoint: CGPoint? = nil
    
    // 内部使用
    fileprivate var isHasMove: Bool = false
    
    fileprivate var isFirstClick: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = self.bgColor
        self.alpha =  self.alphaOfNormol
        self.layer.cornerRadius = self.radiuOfButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = self.alphaOfDrag
        // 计时器取消
        self.timer?.invalidate()
        // 不可拖拽则退出执行
        if !isDragEnable {
            return
        }
        self.allPoint = touches.first?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isHasMove = true
        if self.isFirstClick {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(singleClick), object: nil)
            self.isFirstClick = false
        }
        if !isDragEnable {
            return
        }
        let temp = touches.first?.location(in: self)
        // 计算偏移量
        let offsetx = (temp?.x)! - (self.allPoint?.x)!
        let offsety = (temp?.y)! - (self.allPoint?.y)!
        self.center = CGPoint.init(x: self.center.x + offsetx, y: self.center.y + offsety)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isFirstClick = true
        if #available(iOS 10.0, *) {
            self.timer = Timer.init(timeInterval: TimeInterval(self.timeOfWait), repeats: false, block: { (Timer) in
                // 过渡
                UIView.animate(withDuration: TimeInterval(self.timeOfAnimation), animations: {
                    self.alpha = self.alphaOfNormol
                })
            })
        } else {
            // Fallback on earlier versions
        }
        // 这段代码只有在按钮移动后才需要执行
        if self.isHasMove && isAbsortEnable && self.superview != nil {
            // 移到父view边缘
            let marginL = self.frame.origin.x
            let marginT = self.frame.origin.y
            let superFrame = self.superview?.frame
            let tempy = (superFrame?.height)! - 2 * self.frame.height - self.paddingOfbutton
            let tempx = (superFrame?.width)! - self.frame.width - self.paddingOfbutton
            let xOfR = (superFrame?.width)! - self.frame.width - self.paddingOfbutton
            UIView.animate(withDuration: 0.2, animations: {
                var x = self.frame.origin.x
                if marginT < self.frame.height + self.paddingOfbutton {
                    // 靠顶部
                    if x > tempx {
                        x = tempx
                    }
                    if x < self.paddingOfbutton {
                        x = self.paddingOfbutton
                    }
                    self.frame = CGRect.init(x: x, y: self.paddingOfbutton + 44 + ConstValue.kStatusBarHeight , width: self.frame.width, height: self.frame.height)
                } else if marginT > tempy {
                    // 靠底部
                    if x > tempx {
                        x = tempx
                    }
                    if x < self.paddingOfbutton {
                        x = self.paddingOfbutton
                    }
                    let y = tempy + self.frame.height - 80
                    self.frame = CGRect.init(x: x, y: y, width: self.frame.width, height: self.frame.height)
                } else if marginL > ((superFrame?.width)! / 2) {
                    // 靠右移动
                    self.frame = CGRect.init(x: xOfR, y: marginT, width: self.frame.width, height: self.frame.height)
                } else {
                    // 靠左移动
                    self.frame = CGRect.init(x: self.paddingOfbutton, y: marginT, width: self.frame.width, height: self.frame.height)
                }
            })
        }
        self.isHasMove = false
        // 将计时器加入runloop
        if let temptime = self.timer {
            RunLoop.current.add(temptime, forMode: .common)
        }
        if touches.first?.tapCount == 1  {
            self.singleClick()
        } else if touches.first?.tapCount == 2 {
            self.perform(#selector(repeatClick))
        }
    }
    
    @objc func singleClick() {
        self.delegate?.singleClick()
    }
    
    @objc func repeatClick() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(singleClick), object: nil)
        self.delegate?.repeatClick()
    }
}
