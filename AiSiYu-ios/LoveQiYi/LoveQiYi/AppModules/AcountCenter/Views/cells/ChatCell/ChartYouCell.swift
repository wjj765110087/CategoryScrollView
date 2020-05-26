//
//  ChartYouCell.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/6/7.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class ChartYouCell: UITableViewCell {

    static let cellId = "ChartYouCell"
    
    @IBOutlet weak var timelab: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var contentlab: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        container.addShadow(radius: 2, opacity: 0.5)
       
    }

    func setModel(_ model: MsgModel) {
        timelab.text = "小黄君 \(model.created_at ?? "")"
        contentlab.text = "\(model.content ?? "")"
    }
    
}
