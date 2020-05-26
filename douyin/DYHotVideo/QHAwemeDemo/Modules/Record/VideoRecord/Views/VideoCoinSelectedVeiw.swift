//
//  VideoCoinSelectedVeiw.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/19.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class VideoCoinSelectedVeiw: UIView {

    @IBOutlet weak var coinsRangeLabel: UILabel!
    @IBOutlet weak var sliderView: UISlider!
    @IBOutlet weak var leftPadding: NSLayoutConstraint!
    
    @IBOutlet weak var coinsCountlabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var cancleButton: UIButton!
    
    @IBOutlet weak var commitButton: UIButton!
    
    var buttonClickHandler:((_ price: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let minCoins = Float(AppInfo.share().app_rule?.min_coins ?? "0") ?? 0
        let maxCoins = Float(AppInfo.share().app_rule?.max_coins ?? "0") ?? 0
        sliderView.maximumValue = maxCoins
        sliderView.minimumValue = minCoins
        coinsCountlabel.text = "\(Int(minCoins))"
        coinsRangeLabel.attributedText = TextSpaceManager.configColorString(allString: "金币（\(AppInfo.share().app_rule?.min_coins ?? "0")-\(AppInfo.share().app_rule?.max_coins ?? "0")）", attribStr: "\(AppInfo.share().app_rule?.min_coins ?? "0")-\(AppInfo.share().app_rule?.max_coins ?? "0")", ConstValue.kTitleYelloColor, UIFont.systemFont(ofSize: 15))
    }
    
    @IBAction func sliderValueChange(_ sender: CoinSlider) {
        leftPadding.constant = 15.0 + sender.thmbRect.origin.x
        coinsCountlabel.text = "\(Int(sender.value))"
        DLog("slider,ThumbRect = \(sender.thmbRect)")
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        if sender == commitButton {
            let price = Int(sliderView.value)
            buttonClickHandler?(price)
        } else {
            buttonClickHandler?(0)
        }
    }
}


class CoinSlider: UISlider {
    
    var thmbRect: CGRect = CGRect.zero
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let rectTh = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        self.thmbRect = rectTh
        return rectTh
    }
}
