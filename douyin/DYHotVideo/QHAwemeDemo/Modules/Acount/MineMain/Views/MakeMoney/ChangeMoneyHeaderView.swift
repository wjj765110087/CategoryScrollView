//
//  ChangeMoneyHeaderView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/20.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class ChangeMoneyHeaderView: UIView {

    @IBOutlet weak var textFeild: UITextField!
    
    @IBOutlet weak var tipLab: UILabel!
    
    @IBOutlet weak var coinLab: UILabel!
    
    var model = WalletInfo()
    
    var textFieldHandler:((_ coin: Int)->())?
    
    @IBAction func changeAll(_ sender: UIButton) {
        textFeild.resignFirstResponder()
        textFeild.text = "\(model.coins ?? 0)"
        if let coins = model.coins, coins > 0 {
            tipLab.text = "可兑换\(Float(coins) / 10.0)元"
            tipLab.textColor = UIColor.init(r: 0, g: 123, b: 255)
            textFieldHandler?(model.coins ?? 0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.init(r: 30, g: 31, b: 50)
        textFeild.setPlaceholderTextColor(placeholderText: "0", color: UIColor(white: 1.0, alpha: 1.0))
        textFeild.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        if let text = textField.text, !text.isEmpty {
            if let coins = model.coins, coins < Int(text) ?? 0 {
                self.tipLab.text = "已超出可兑换金币额度"
                self.tipLab.textColor = UIColor.init(r: 231, g: 35, b: 29)
            } else {
                if let coin = Int(text), coin > 0 {
                    self.tipLab.text = "(可兑换\(Float(coin) / 10.0)元)"
                    self.tipLab.textColor = UIColor.init(r: 0, g: 123, b: 255)
                }
            }
            textFieldHandler?(Int(text) ?? 0)
        }
        
        if let text = textField.text, text.isEmpty {
            self.tipLab.text = ""
        }
    }
    
    func setModel(model: WalletInfo) {
        self.model = model
        if let coins = model.coins {
            self.coinLab.text = "拥有金币：\(coins)个"
        }
    }
}

extension ChangeMoneyHeaderView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.placeholder = ""
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFeild.resignFirstResponder()
        if let text = textField.text, !text.isEmpty {
            if let coins = model.coins, coins < Int(text) ?? 0 {
                self.tipLab.text = "已超出可兑换金币额度"
                self.tipLab.textColor = UIColor.init(r: 231, g: 35, b: 29)
            } else {
                if let coin = Int(text), coin > 0 {
                    self.tipLab.text = "(可兑换\(Float(coin) / 10.0)元)"
                    textFieldHandler?(Int(text) ?? 0)
                }
            }
        }
        
        if let text = textField.text, text.isEmpty {
            self.tipLab.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return true}
        let textLength = text.count + string.count - range.length
        return textLength<=10
    }
}
