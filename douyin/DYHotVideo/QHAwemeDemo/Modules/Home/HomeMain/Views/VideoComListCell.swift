//
//  VideoComListCell.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/14.
//  Copyright © 2018年 pro5. All rights reserved.
//

import UIKit

/// 评论列表Cell
class VideoComListCell: UITableViewCell {

    static let cellId = "VideoComListCell"
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var contentLable: UILabel!
    
    @IBOutlet weak var headerNameLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        headerImage.layer.cornerRadius = 17.5
        headerImage.layer.masksToBounds = true
        headerNameLab.layer.cornerRadius = 17.5
        headerNameLab.layer.masksToBounds = true
    }
    
}
