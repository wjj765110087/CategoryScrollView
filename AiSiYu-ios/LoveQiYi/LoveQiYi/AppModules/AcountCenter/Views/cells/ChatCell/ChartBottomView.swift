//
//  ChartBottomView.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/6/7.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class ChartBottomView: UIView {

    
    @IBOutlet weak var pictureBtn: UIButton!
    @IBOutlet weak var contentTf: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    var actionHandler:((_ id: Int) -> Void)?
    
    @IBAction func pictureAdd(_ sender: UIButton) {
        actionHandler?(1)
    }
    
    @IBAction func sendMsg(_ sender: UIButton) {
        actionHandler?(2)
    }
    
    
}
