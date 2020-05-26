//
//  BalanceDetailCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/19.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class BalanceDetailCell: UITableViewCell {
    
    static let cellId = "BalanceDetailCell"
    static let cellHeight: CGFloat = 77.0
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var timeLab: UILabel!
    
    @IBOutlet weak var moneyLab: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    
    func setModel(model: MoneyDetailModel) {
        titleLab.text = model.title ?? ""
        timeLab.text = model.created_at ?? ""
        statusLabel.text = model.status_name ?? ""
        if let status = model.status {
            switch status {
            case .drawCenter:
                statusLabel.textColor = UIColor.init(r: 153, g: 153, b: 153)
            case .drawFailure:
                statusLabel.textColor = UIColor.init(r: 231, g: 35, b: 29)
            case .drawSuccess:
                statusLabel.textColor = UIColor.init(r: 0, g: 123, b: 255)
            }
        }
        
        if let balance = model.balance {
            if balance.hasPrefix("+") {
                moneyLab.textColor = UIColor.init(r: 0, g: 123, b: 255)
            } else {
                moneyLab.textColor = UIColor.init(r: 231, g: 35, b: 29)
            }
            moneyLab.text = balance
        }
    }

    func setCoinDetailModel(model: CoinDetailModel) {
        titleLab.text = model.title ?? ""
        timeLab.text = model.created_at ?? ""
        
        if let coins = model.coins {
            if coins.hasPrefix("+") {
                moneyLab.textColor = UIColor.init(r: 11, g: 190, b: 6)
            } else {
                moneyLab.textColor = UIColor.init(r: 238, g: 73, b: 48)
            }
            moneyLab.text = coins
        }
    }
}
