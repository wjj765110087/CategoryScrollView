//
//  HotHeaerView.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/18.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit
import MarqueeLabel

class HotHeaerView: UICollectionReusableView {
    
    static let reuseId = "HotHeaerView"
    
    @IBOutlet weak var logoImgView: UIImageView!
    
    @IBOutlet weak var tipLab: MarqueeLabel!
    
    @IBOutlet weak var bgButton: UIButton!
    
    var bgButtonClickHandler: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tipLab.speed = .duration(15)
    }
    
    @IBAction func bgButton(_ sender: UIButton) {
        bgButtonClickHandler?()
    }
    
    func setNotice() {
        if let msgs = SystemMsg.share().systemMsgs, msgs.count > 0 {
            tipLab.text = msgs[0].msg ?? "欢迎来到爱私欲，新用户登录即送免费3天无限看片。"
            tipLab.type = .continuous
            tipLab.animationCurve = .easeInOut
        }
    }
    
}
