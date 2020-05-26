//
//  PayBottomView.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/18.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import UIKit

class PayBottomView: UIView {

    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var payBtn: UIButton!
    
    var payAction:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceLable.attributedText = TextSpaceManager.configColorString(allString: "应付: 0.00元", attribStr: "0.00", UIColor(r: 215, g: 58, b: 45), UIFont.boldSystemFont(ofSize: 22))
    }
    
    @IBAction func payAction(_ sender: UIButton) {
        payAction?()
    }
    
    func setMuneModel(_ model: VipCardModel) {
        if model.price_current != nil && !model.price_current!.isEmpty {
            payBtn.isEnabled = true
            priceLable.attributedText = TextSpaceManager.configColorString(allString: "应付: \(model.price_current ?? "0.00") 元", attribStr: "\(model.price_current ?? "0.00")", UIColor(r: 215, g: 58, b: 45), UIFont.boldSystemFont(ofSize: 20))
        } else {
            payBtn.isEnabled = false
        }
    }
    
    func setBottomWithCoinModel(_ model: CoinModel) {
        if model.price != nil && !model.price!.isEmpty {
            payBtn.isEnabled = true
            priceLable.attributedText = TextSpaceManager.configColorString(allString: "应付: \(model.price ?? "0.00") 元", attribStr: "\(model.price ?? "0.00")", UIColor(r: 215, g: 58, b: 45), UIFont.boldSystemFont(ofSize: 20))
        } else {
            payBtn.isEnabled = false
        }
    }
    func setBottomWithServerModel(_ model: UpDoorServerModel) {
        if model.price_current != nil && !model.price_current!.isEmpty {
            payBtn.isEnabled = true
            priceLable.attributedText = TextSpaceManager.configColorString(allString: "应付: \(model.price_current ?? "0.00") 元", attribStr: "\(model.price_current ?? "0.00")", UIColor(r: 215, g: 58, b: 45), UIFont.boldSystemFont(ofSize: 20))
        } else {
            payBtn.isEnabled = false
        }
    }
}
