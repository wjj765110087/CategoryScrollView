//
//  MsgListCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/15.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class MsgListCell: UITableViewCell {
    
    static let cellId = "MsgListCell"

    @IBOutlet weak var msgContent: UIView!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var msgTitle: UILabel!
    @IBOutlet weak var msgInfo: UILabel!
    @IBOutlet weak var seeDetalBtn: UIButton!
    @IBOutlet weak var detailBtnHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        msgContent.layer.cornerRadius = 10
        msgContent.layer.masksToBounds = true
        msgContent.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        detailBtnHeight.constant = 0
        seeDetalBtn.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
