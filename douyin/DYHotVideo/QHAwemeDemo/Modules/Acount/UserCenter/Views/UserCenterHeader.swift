//
//  UserCenterHeader.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/8/26.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class UserCenterHeader: UIView {

    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tipLab: UILabel!
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var attentionBtn: UIButton!
    @IBOutlet weak var userNamelabel: UILabel!
    @IBOutlet weak var attentionCount: UILabel!
    @IBOutlet weak var fansCount: UILabel!
    @IBOutlet weak var birthdayLab: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var sexButton: UIButton!
    @IBOutlet weak var sexBtnBgView: UIView!
    
    var actionClickHandler:((_ tag: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerImg.layer.cornerRadius = 33.0
        headerImg.layer.masksToBounds = true
        headerImg.layer.borderColor = UIColor.init(white: 0.9, alpha: 1.0).cgColor
        headerImg.layer.borderWidth = 2
        headerImg.layer.minificationFilter = .trilinear
        headerImg.layer.magnificationFilter = .trilinear
    }
    
    func setUserType(_ isMe: Bool) {
        attentionBtn.setTitle(isMe ? "编辑资料" : "+关注" , for: .normal)
    }
    
    func setModel(user: UserInfoModel) {
        if let birth = user.birth, let sex = user.sex {
            sexButton.isHidden = false
            sexBtnBgView.isHidden = false
            tipLab.isHidden = true
            if !birth.isEmpty {
                let age = Date.getAgeForDateStr(birth: birth)
                sexButton.setTitle(" \(age)岁", for: .normal)
            } else {
                sexButton.setTitle("暂无年龄", for: .normal)
            }
            if sex == 1 { // 男
                sexButton.setImage(UIImage(named: "boySex"), for: .normal)
            } else if sex == 2 { // 女
                sexButton.setImage(UIImage(named: "girlSex"), for: .normal)
            } else if sex == 0 { // 未设置
                sexButton.setImage(nil, for: .normal)
            }
        } else {
            sexButton.isHidden = true
            sexBtnBgView.isHidden = true
            tipLab.isHidden = false
        }
    }
    
    @IBAction func actionClick(_ sender: UIButton) {
        actionClickHandler?(sender.tag)
    }
    
}
