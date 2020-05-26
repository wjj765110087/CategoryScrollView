//
//  CoinItemCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/18.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class CoinItemCell: UICollectionViewCell {
    
    static let cellId = "VipCardItemCell"
    static let itemSize = CGSize(width: 110, height: 150)
    
    @IBOutlet weak var coinLabel: UILabel!
    
    @IBOutlet weak var moneyLabel: UILabel!
    
    @IBOutlet weak var discountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor =  ConstValue.kViewLightColor
    }
}
