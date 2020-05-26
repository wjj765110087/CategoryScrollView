//
//  DrawCashCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/6/1.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class DrawCashCell: UITableViewCell {
    
    static let cellId = "DrawCashCell"
    @IBOutlet weak var titlelab: UILabel!
    
    @IBOutlet weak var inputTextfile: UITextField!
    
    @IBOutlet weak var bankName: UITextField!
    
    @IBOutlet weak var bankCard: UITextField!
    
    @IBOutlet weak var bankKh: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        bankName.setPlaceholderTextColor(placeholderText: "请输入银行名称", color: UIColor(white: 0.7, alpha: 0.6))
         
        inputTextfile.setPlaceholderTextColor(placeholderText: "请输入姓名", color: UIColor(white: 0.7, alpha: 0.6))
        
        bankCard.setPlaceholderTextColor(placeholderText: "请输入银行卡号", color: UIColor(white: 0.7, alpha: 0.6))
         
        bankKh.setPlaceholderTextColor(placeholderText: "请输入开户行", color: UIColor(white: 0.7, alpha: 0.6))
        
    }

   
    
}

