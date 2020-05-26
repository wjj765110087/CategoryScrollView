//
//  VipCardUpAlert.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

/// VIP 卡升级后弹框
class VipCardUpAlert: UIView {

   
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var cardBgImage: UIImageView!    
    @IBOutlet weak var cardValueInfo: UILabel!
    @IBOutlet weak var cardLogolImage: UIImageView!
    @IBOutlet weak var cardNameImage: UIImageView!
    @IBOutlet weak var commitBtn: UIButton!
    
    
    var closeActionHandler:(() ->Void)?
    var commitActionHandler:(() ->Void)?
    
    
    @IBAction func commitAction(_ sender: UIButton) {
        closeActionHandler?()
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        commitActionHandler?()
    }
}
