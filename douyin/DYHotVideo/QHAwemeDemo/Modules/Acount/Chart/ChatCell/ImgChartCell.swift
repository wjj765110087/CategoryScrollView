//
//  ImgChartCell.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/6/7.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class ImgChartCell: UITableViewCell {

    static let cellId = "ImgChartCell"
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var timelab: UILabel!
    @IBOutlet weak var pictureBtn: UIButton!
    
    var pictureClick:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.addShadow(radius: 2, opacity: 0.6)
        pictureBtn.clipsToBounds = true
    }
    
    func setModel(_ model: MsgModel) {
        timelab.text = "我 \(model.created_at ?? "")"
        pictureBtn.kfSetHorizontalImageWithUrl(model.content)
    }

    @IBAction func pictureClick(_ sender: UIButton) {
        pictureClick?()
    }
    
}
