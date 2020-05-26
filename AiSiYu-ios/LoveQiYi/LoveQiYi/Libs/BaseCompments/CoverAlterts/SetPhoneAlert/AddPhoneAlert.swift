//
//  AddPhoneAlert.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/15.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

/// 绑定手机号
class AddPhoneAlert: UIView {
   
    @IBOutlet weak var daysLables: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var bgImage: UIImageView!
    
    var closeActionHandler:(() ->Void)?
    var addPhoneActionHandler:(() ->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        addButton.layer.cornerRadius = 20
        addButton.layer.masksToBounds = true
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        addPhoneActionHandler?()
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        closeActionHandler?()
    }
}
