//
//  SettingCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
    
    static let cellId = "SettingCell"

    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var swichBtn: UISwitch!
    @IBOutlet weak var msglab: UILabel!
    var switchValueChangeHandler:(() ->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 70))
        view.backgroundColor = UIColor.darkGray
        selectedBackgroundView = view
    }

    @IBAction func switchValueChange(_ sender: UISwitch) {
        switchValueChangeHandler?()
    }
    
}
