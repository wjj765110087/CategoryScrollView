//
//  ExchangeView.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/6/24.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class ExchangeView: UIView {

    @IBOutlet weak var topContaner: UIView!
    @IBOutlet weak var exCodeTf: UITextField!
    @IBOutlet weak var statuContainer: UIView!
    @IBOutlet weak var codeLable: UILabel!
    @IBOutlet weak var coinsLab: UILabel!
    @IBOutlet weak var exStatuLab: UILabel!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    var commitActionHandler:((_ actionId: Int) -> ())?
    var actionId: Int = 0
    
    override func awakeFromNib() {
        commitBtn.setTitle("兑换", for: .normal)
        containerHeight.constant = 100
        statuContainer.isHidden = true
    }
    
    @IBAction func commitAction(_ sender: UIButton) {
        if exCodeTf.text == nil || exCodeTf.text!.isEmpty {
            XSAlert.show(type: .error, text: "请填写兑换码。")
        } else {
            commitActionHandler?(actionId)
        }
        
    }
    
}
