//
//  MyGiftTableCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019-12-23.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class MyGiftTableCell: UITableViewCell {

    static let cellId = "MyGiftTableCell"
    
    @IBOutlet weak var remarkLabel: UILabel!
    
    @IBOutlet weak var statuImage: UIImageView!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.addShadow(radius: 5, opacity: 0.3)
    }
    
    func setGiftModel(_ model: MyGiftModle) {
        typeLabel.text = "\(model.prize_type_zh ?? "")"
        timelabel.text = "\(model.created_at ?? "")领取"
        if let isSend = model.is_action, isSend == 1 {
            statuImage.image = UIImage(named: "giftSendBg")
        } else {
            statuImage.image = UIImage(named: "giftNotSendBg")
        }
        namelabel.text = "\(model.prize_name ?? "")"
        iconImage.kfSetVerticalImageWithUrl(model.prize_img)
        remarkLabel.text = "\(model.prize_remark ?? "")"
    }
    
}
