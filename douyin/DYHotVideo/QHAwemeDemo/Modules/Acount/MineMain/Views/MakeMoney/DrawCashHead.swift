//
//  DrawCashHead.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/6/1.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class DrawCashHead: UIView {

    @IBOutlet weak var titlelab: UILabel!
    @IBOutlet weak var moneyValue: UITextField!
    
    @IBOutlet weak var moneyUtis: UILabel!
    
    @IBOutlet weak var sxfLab: UILabel!
    
    @IBOutlet weak var allDrawBtn: UIButton!
    
    var minMoney: Float = 0.00
    
    var actionHandler:(() -> Void)?
    var allMoney: Float = 0.00
    override func awakeFromNib() {
        moneyValue.delegate = self
        moneyValue.setPlaceholderTextColor(placeholderText: "0.00", color: UIColor(white: 0.7, alpha: 0.6))
        if let fee = AppInfo.share().app_rule?.fee, !fee.isEmpty {
             titlelab.text = "提取金额（收取\(fee)%手续费）"
        }
        
        if let money = AppInfo.share().app_rule?.money, !money.isEmpty {
            minMoney = Float(money) ?? 0.00
        }
    }
    
    @IBAction func allDrawAction(_ sender: UIButton) {
        actionHandler?()
    }
}

// MARK: - UITextFieldDelegate
extension DrawCashHead: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let num = textField.text, !num.isEmpty {
            if let value = Float(num) {
                if value < minMoney {
                    XSAlert.show(type: .error, text: "最小提现金额\(minMoney)元")
                    return
                } else if value > allMoney {
                    moneyValue.text = String(format: "%.2f", allMoney)
                    if allMoney >= minMoney {
                        let fee: Float = Float(AppInfo.share().app_rule?.fee ?? "0") ?? 0
                        let ps = fee/100.0
                         sxfLab.attributedText =  TextSpaceManager.configColorString(allString: "服务费: ￥\(String(format: "%.2f", Float(value*ps)))", attribStr: "￥\(String(format: "%.2f", Float(value*ps)))")
                    }
                    return
                } else {
                    moneyValue.text = String(format: "%.2f", value)
                    let fee: Float = Float(AppInfo.share().app_rule?.fee ?? "0") ?? 0
                    let ps = fee/100.0
                    sxfLab.attributedText =  TextSpaceManager.configColorString(allString: "服务费: ￥\(String(format: "%.2f", Float(value*ps)))", attribStr: "￥\(String(format: "%.2f", Float(value*ps)))")
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return true}

        let textLength = text.count + string.count - range.length
        return textLength<=10
    }
}
