//
//  AttListCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/8/29.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class AttListCell: UITableViewCell {

    static let cellId = "AttListCell"
    
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var nickNamelabe: UILabel!
    @IBOutlet weak var followStatuBtn: UIButton!
    var didClickFollowHandler:(()->())?
    var didClickAvatarHandler:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        followStatuBtn.layer.cornerRadius = 3
        followStatuBtn.layer.masksToBounds = true
    }

    @IBAction func didClickFollowed(_ sender: UIButton) {
        didClickFollowHandler?()
    }
    
    @IBAction func didClickAvatar(_ sender: UITapGestureRecognizer) {
        didClickAvatarHandler?()
    }
    
    func setDiscoverSearchUserModel(_ model: FlowUsers) {
        let userDefaultHeader = UserModel.share().getUserHeader(model.id)
        headerImg.kfSetHeaderImageWithUrl(model.cover_path, placeHolder: userDefaultHeader)
        nickNamelabe.text = model.nikename
        if model.id == UserModel.share().userInfo?.id {
            followStatuBtn.backgroundColor = UIColor(r: 35, g: 38, b: 53)
            followStatuBtn.setTitle("自己", for: .normal)
        } else {
            if let fag = model._realation?.flag {
                switch fag {
                case .notRelate, .follwMe:
                    followStatuBtn.backgroundColor = UIColor(r: 0, g: 123, b: 255)
                    followStatuBtn.setTitle("关注", for: .normal)
                    break
                case .followEachOther:
                    followStatuBtn.backgroundColor = UIColor(r: 35, g: 38, b: 53)
                    followStatuBtn.setTitle("相互关注", for: .normal)
                    break
                case .myFollow:
                    followStatuBtn.backgroundColor = UIColor(r: 35, g: 38, b: 53)
                    followStatuBtn.setTitle("已关注", for: .normal)
                    break
                case .isMySelf:
                    followStatuBtn.backgroundColor = UIColor(r: 35, g: 38, b: 53)
                    followStatuBtn.setTitle("自己", for: .normal)
                    break
                }
            }
        }
    }
    
    func setModel(_ model: FlowUsers) {
        let userDefaultHeader = UserModel.share().getUserHeader(model.id)
        headerImg.kfSetHeaderImageWithUrl(model.cover_path, placeHolder: userDefaultHeader)
        nickNamelabe.text = model.nikename
        if model.id == UserModel.share().userInfo?.id {
            followStatuBtn.backgroundColor = UIColor(r: 35, g: 38, b: 53)
            followStatuBtn.setTitle("自己", for: .normal)
        } else {
            if let fag = model.flag {
                switch fag {
                case .notRelate, .follwMe:
                    followStatuBtn.backgroundColor = UIColor(r: 0, g: 123, b: 255)
                    followStatuBtn.setTitle("关注", for: .normal)
                    break
                case .followEachOther:
                    followStatuBtn.backgroundColor = UIColor(r: 35, g: 38, b: 53)
                    followStatuBtn.setTitle("相互关注", for: .normal)
                    break
                case .myFollow:
                    followStatuBtn.backgroundColor = UIColor(r: 35, g: 38, b: 53)
                    followStatuBtn.setTitle("已关注", for: .normal)
                    break
                case .isMySelf:
                    followStatuBtn.backgroundColor = UIColor(r: 35, g: 38, b: 53)
                    followStatuBtn.setTitle("自己", for: .normal)
                    break
                }
            }
        }
    }
}
