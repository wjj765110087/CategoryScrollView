//
//  DailyTaskCell.swift
//  QHAwemeDemo
//
//  Created by mac on 20/12/2019.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class DailyTaskCell: UITableViewCell {

    static let cellId = "DailyTaskCell"
    static let cellHeight: CGFloat = 70.0
    
    @IBOutlet weak var button: CustomButton!
    @IBOutlet weak var subTitleLab: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    var buttonClickHandler: (()->())?
    func setModel(model: GameTaskModel) {
        if let group = model.group {
            if group == .coins {
                button.setTitle("\(model.coins ?? 0)金币", for: .normal)
                if let number = model.number {
                    if number == 0 {
                        titleLabel.text = "\(model.title ?? "")"
                    } else {
                        titleLabel.text = "\(model.title ?? "") (\(number)个)"
                    }
                }
                
                 let wallet = UserModel.share().wallet
                 let coinsBalance =  wallet?.coins ?? 0
                 
                 let coins = model.coins ?? 0
                 if coinsBalance < coins {  ///金币余额小于领取金币。     按钮为灰色
                     button.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.init(r: 227, g: 227, b: 227), size: CGSize(width: 1, height: 1)), for: .normal)
                 } else {
                     button.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.init(r: 0, g: 123, b: 255), size: CGSize(width: 1, height: 1)), for: .normal)
                 }
                
                if let sign = model.sign {
                    if sign == .hasFinish || sign == .doTask {
                        button.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.init(r: 227, g: 227, b: 227), size: CGSize(width: 1, height: 1)), for: .normal)
                    } else if sign == .waitGet {
                        button.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.init(r: 0, g: 123, b: 255), size: CGSize(width: 1, height: 1)), for: .normal)
                    }
                }

            } else {
                if let key = model.key, let sign = model.sign {
                    if key == "LOGIN" {
                        if sign == .hasFinish || sign == .doTask {
                            button.setTitle("明日再来", for: .normal)
                           button.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.init(r: 227, g: 227, b: 227), size: CGSize(width: 1, height: 1)), for: .normal)
                        } else if sign == .waitGet {
                            button.setTitle("领取", for: .normal)
                             button.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.init(r: 0, g: 123, b: 255), size: CGSize(width: 1, height: 1)), for: .normal)
                        }
                    } else if key == "INVITE" || key == "INVITE_RECHARGE" {
                        if sign == .hasFinish {
                            button.setTitle("明日再来", for: .normal)
                            button.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.init(r: 227, g: 227, b: 227), size: CGSize(width: 1, height: 1)), for: .normal)
                        } else if sign == .doTask  {
                            button.setTitle("去邀请", for: .normal)
                            button.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.init(r: 0, g: 123, b: 255), size: CGSize(width: 1, height: 1)), for: .normal)
                        } else if sign == .waitGet {
                            button.setTitle("领取", for: .normal)
                            button.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.init(r: 0, g: 123, b: 255), size: CGSize(width: 1, height: 1)), for: .normal)
                        }
                    } else if key == "RECHARGE" {
                        if sign == .hasFinish {
                            button.setTitle("明日再来", for: .normal)
                            button.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.init(r: 227, g: 227, b: 227), size: CGSize(width: 1, height: 1)), for: .normal)
                        } else if sign == .doTask  {
                            button.setTitle("去充值", for: .normal)
                            button.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.init(r: 0, g: 123, b: 255), size: CGSize(width: 1, height: 1)), for: .normal)
                        } else if sign == .waitGet {
                            button.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.init(r: 0, g: 123, b: 255), size: CGSize(width: 1, height: 1)), for: .normal)
                            button.setTitle("领取", for: .normal)
                        }
                    }
                }
                
                if let number = model.number, let has = model.has {
                      if number == 0 {
                          titleLabel.text = "\(model.title ?? "")"
                      } else {
                          titleLabel.attributedText = TextSpaceManager.configColorString(allString: "\(model.title ?? "") (\(has)/\(number)元)", attribStr: "\(has)", UIColor.init(r: 255, g: 72, b: 57), UIFont.boldSystemFont(ofSize: 15), 0)
                          
                          if model.key == "INVITE" {
                              titleLabel.attributedText = TextSpaceManager.configColorString(allString: "\(model.title ?? "") (\(has)/\(number))", attribStr: "\(has)", UIColor.init(r: 255, g: 72, b: 57), UIFont.boldSystemFont(ofSize: 15), 0)
                          }
                      }
                  }
            }
            iconImage.kfSetHorizontalImageWithUrl(model.icon)
            subTitleLab.text = model.remark ?? ""
        }
    }
    
    @IBAction func didClickButton(_ sender: UIButton) {
        buttonClickHandler?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.adjustsImageWhenHighlighted = false
    }
}

class CustomButton: UIButton {
    override var isHighlighted: Bool {
        set{
            
        }
        get {
            return false
        }
    }
}


