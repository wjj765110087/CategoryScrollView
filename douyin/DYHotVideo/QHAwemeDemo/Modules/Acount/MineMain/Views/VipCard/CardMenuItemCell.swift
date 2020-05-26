//
//  NounMenuItemCell.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import UIKit

class CardMenuItemCell: UICollectionViewCell {
    
    static let cellId = "NounMenuItemCell"
    static let itemSize = CGSize(width: 95, height: 130)
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceEach: UILabel!
    @IBOutlet weak var welfareLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
