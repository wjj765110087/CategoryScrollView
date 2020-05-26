//
//  WalletMainCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/19.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class WalletMainCell: UITableViewCell {
    
    static let cellId = "WalletMainCell"
    static let cellHeight: CGFloat = 70.0

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var subLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        selectionStyle = .none
        
    }
}
