//
//  DrawCashAlCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/6/1.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class DrawCashAlCell: UITableViewCell {

    static let cellId = "DrawCashAlCell"
    
    @IBOutlet weak var alipayTf: UITextField!
    
    @IBOutlet weak var nameTf: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        alipayTf.setPlaceholderTextColor(placeholderText: "请输入支付宝账号", color: UIColor(white: 0.7, alpha: 0.6))
        nameTf.setPlaceholderTextColor(placeholderText: "请输入姓名", color: UIColor(white: 0.7, alpha: 0.6))
    }

    
}
