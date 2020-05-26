//
//  ChargeSuccess.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/6/5.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class ChargeSuccess: UIView {
    
    
    @IBOutlet weak var imgRed: UIImageView!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var valuelable: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    var actionHandler:((_ actionId: Int) ->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func actionClick(_ sender: UIButton) {
        actionHandler?(sender.tag)
    }
    
}
