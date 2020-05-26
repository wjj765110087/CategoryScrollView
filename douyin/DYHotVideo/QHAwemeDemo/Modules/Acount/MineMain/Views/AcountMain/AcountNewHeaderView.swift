//
//  AcountNewHeaderView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/4.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class AcountNewHeaderView: UIView {

    @IBOutlet weak var headerImage: UIImageView!
    
    @IBOutlet weak var sexButton: UIButton!
    @IBOutlet weak var namelable: UILabel!
    @IBOutlet weak var changeAcountBtn: UIButton!
    @IBOutlet weak var descripLabel: UILabel!
    @IBOutlet weak var viewCountButton: UIButton!
    @IBOutlet weak var followCount: UILabel!
    @IBOutlet weak var fansCount: UILabel!
    @IBOutlet weak var inviteCount: UILabel!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var sexBtnBgView: UIView!
    var actionHandler:((_ actionId: Int) ->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerImage.layer.cornerRadius = 33.0
        headerImage.layer.masksToBounds = true
//        headerImage.layer.borderWidth = 8
//        headerImage.layer.borderColor =  ConstValue.kViewLightColor.cgColor
    }
    
    @IBAction func acountNewViewActions(_ sender: UIButton) {
        print("sender.tag = \(sender.tag)")
        actionHandler?(sender.tag)
    }
    
    func setUser(_ user: UserInfoModel) {
        headerImage.kfSetHeaderImageWithUrl(user.cover_path, placeHolder: UserModel.share().getUserHeader())
        if let inviCount = user.invite_count {
            inviteCount.text = "\(inviCount)"
        }
        if let endTime = user.vip_expire, !endTime.isEmpty {
            viewCountButton.setTitle("无限观看天数还剩：\(UserModel.share().userInfo?.vip_remain_day ?? "0")天", for: .normal)
        } else {
            viewCountButton.setTitle("今日观看次数还剩：\(user.remain_count ?? "0")", for: .normal)
        }
        if let birth = user.birth, let sex = user.sex {
            sexButton.isHidden = false
            sexBtnBgView.isHidden = false
            tipLabel.isHidden = true
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
            tipLabel.isHidden = false
        }
        if let intro = user.intro, !intro.isEmpty {
             descripLabel.attributedText = TextSpaceManager.getAttributeStringWithString(user.intro!, lineSpace: 3)
        } else {
              descripLabel.attributedText = TextSpaceManager.getAttributeStringWithString("您还没有添加个人简介，点击添加...", lineSpace: 3)
        }
        namelable.text = user.nikename ?? "老湿"
       
        if let follows = user.flow {
            followCount.text =  getStringWithNumber(follows)
        }
        if let fans = user.fans {
            fansCount.text = getStringWithNumber(fans)
        }
        if let invites = user.invite_count {
            inviteCount.text = getStringWithNumber(invites) 
        }
        if let type = UserModel.share().userInfo?.type, type == 0 {
            loginView.isHidden = true
        } else {
            loginView.isHidden = false
        }
    }
}


