//
//  ChartMeCell.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/6/7.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class ChartMeCell: UITableViewCell {
    
    static let cellId = "ChartMeCell"
    
    @IBOutlet weak var timelab: UILabel!
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var contentlab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //container.addShadow(radius: 2, opacity: 0.5)
        container.addShadow(radius: 2, opacity: 1.0, UIColor.white)
    }

    func setModel(_ model: MsgModel) {
        timelab.text = "我 \(model.created_at ?? "")"
        contentlab.text = "\(model.content ?? "")"
    }
    
}
