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
        priceLable.attributedText = TextSpaceManager.configColorString(allString: "应付: 0.00元", attribStr: "0.00", kAppDefaultTitleColor, UIFont.boldSystemFont(ofSize: 20))
    }
    
    @IBAction func payAction(_ sender: UIButton) {
        payAction?()
    }
    
    func setMuneModel(_ model: ChargeModel) {
        if model.price != nil && !model.price!.isEmpty {
            payBtn.isEnabled = true
            priceLable.attributedText = TextSpaceManager.configColorString(allString: "应付: \(model.price ?? "0.00") 元", attribStr: "\(model.price ?? "0.00")", kAppDefaultTitleColor, UIFont.boldSystemFont(ofSize: 20))
        } else {
            payBtn.isEnabled = false
        }
        
    }
    
}
