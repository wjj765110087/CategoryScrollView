//
//  VideoDoubleCollectionCell.swift
//  XSVideo
//
//  Created by pro5 on 2018/11/30.
//  Copyright © 2018年 pro5. All rights reserved.
//

import UIKit

/// 一排2个视频的 布局cell
class VideoDoubleCollectionCell: UICollectionViewCell {
    static let cellId = "VideoDoubleCollectionCell"
    static let width = (screenWidth-30)/2
    static let itemSize = CGSize(width: width, height: width*9/16 + 30)

    @IBOutlet weak var VideoImage: UIImageView!
    @IBOutlet weak var VideoDes: UILabel!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var pointLable: UILabel!
    @IBOutlet weak var vipLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.white
    }
    
    func setModel(_ model: VideoModel) {
        videoName.text = "\(model.title ?? "老湿")"
        VideoImage.kfSetHorizontalImageWithUrl(model.cover_url)
        vipLabel.isHidden = !(model.is_vip?.boolValue ?? false)
        pointLable.text = formatTimDuration(model.duration ?? 0)
    }
    
    private func formatTimDuration(_ duration:Int) -> String {
        guard  duration != 0 else{
            return "00:00"
        }
        let durationHours = (duration / 3600) % 60
        let durationMinutes = (duration / 60) % 60
        let durationSeconds = duration % 60
        if (durationHours == 0)  {
            return String(format: "%02d:%02d",durationMinutes,durationSeconds)
        }
        return String(format: "%02d:%02d:%02d",durationHours,durationMinutes,durationSeconds)
    }

}
