//
//  HomeTopSegView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/8/30.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class HomeTopSegView: UIView {

    @IBOutlet weak var reconmentBtn: UIButton!
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var attentionBtn: UIButton!
    
    var fakeBtn: UIButton?
    
    var actionHandler:((_ segTag: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reconmentBtn.isSelected = true
        fakeBtn = reconmentBtn
    }
    
    @IBAction func segBtnClick(_ sender: UIButton) {
        if sender != fakeBtn {
            sender.isSelected = true
            fakeBtn?.isSelected = false
            fakeBtn = sender
            actionHandler?(sender.tag)
        }
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        actionHandler?(sender.tag)
    }
}
