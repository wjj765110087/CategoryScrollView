//
//  PayRecordCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

/// 支付记录
class PayRecordCell: UITableViewCell {
    
    static let cellId = "PayRecordCell"
    
    @IBOutlet weak var cardNameLab: UILabel!
    @IBOutlet weak var payStatuImg: UIImageView!
    
    @IBOutlet weak var daysLable: UILabel!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var payTimeLab: UILabel!
    @IBOutlet weak var availTimeLab: UILabel!
    @IBOutlet weak var priceLab: UILabel!
    @IBOutlet weak var lineView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
