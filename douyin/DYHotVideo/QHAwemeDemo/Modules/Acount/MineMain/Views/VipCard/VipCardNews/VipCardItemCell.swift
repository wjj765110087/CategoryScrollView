//
//  VipCardItemCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/13.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class VipCardItemCell: UICollectionViewCell {

    static let cellId = "VipCardItemCell"
    static let itemSize = CGSize(width: 110, height: 150)
    
    @IBOutlet weak var cardTagView: UIView!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardTime: UILabel!
    @IBOutlet weak var cardPrise: UILabel!
    @IBOutlet weak var cardIntro: UILabel!
    
    @IBOutlet weak var dayTopMargin: NSLayoutConstraint!
    @IBOutlet weak var daysLabelHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor =  ConstValue.kViewLightColor
        let corners: UIRectCorner = [UIRectCorner.bottomLeft, UIRectCorner.bottomRight]
        cardTagView.corner(byRoundingCorners: corners, radii: 5)
    }
}
