//
//  NewUserRewardAlert.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/15.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class NewUserRewardAlert: UIView {

    @IBOutlet weak var alterBgImage: UIImageView!
    @IBOutlet weak var rewardInfo: UILabel!
    @IBOutlet weak var getItButton: UIButton!
    @IBOutlet weak var availTime: UILabel!
    
    @IBOutlet weak var closebtn: UIButton!
    var verbRewardActionHandler:(() ->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        getItButton.layer.cornerRadius = 21
        getItButton.layer.masksToBounds = true
        rewardInfo.textColor = UIColor(r: 255, g: 42, b: 49)
    }
    
    @IBAction func verbRewardAction(_ sender: UIButton) {
        verbRewardActionHandler?()
    }
    
}
