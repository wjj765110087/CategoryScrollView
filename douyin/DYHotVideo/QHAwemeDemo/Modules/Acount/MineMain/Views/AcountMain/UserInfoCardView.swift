//
//  UserInfoCardView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class UserInfoCardView: UIView {

    
    @IBOutlet weak var cardTypeName: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    
    @IBOutlet weak var tipsLab: UILabel!
    @IBOutlet weak var nickNameLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardTypeName.textColor =  UIColor(red: 255/255.0 , green: 42/255.0 , blue:49/255.0, alpha: 1)
        cardTypeName.backgroundColor = UIColor(red: 50/255.0 , green: 52/255.0 , blue: 64/255.0, alpha: 1)
        cardTypeName.layer.cornerRadius = 10
        cardTypeName.layer.masksToBounds = true
        headerImage.layer.cornerRadius = 25
        headerImage.layer.masksToBounds = true
    }
}
