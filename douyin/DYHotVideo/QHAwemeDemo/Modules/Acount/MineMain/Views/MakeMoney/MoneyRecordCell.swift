//
//  MoneyRecordCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/6/1.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class MoneyRecordCell: UITableViewCell {
    
    static let cellId = "MoneyRecordCell"
    
    @IBOutlet weak var titlelab: UILabel!
    
    @IBOutlet weak var countlab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
