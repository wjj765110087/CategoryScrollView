//
//  CollectedVideoCell.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/25.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import UIKit

class CollectedVideoCell: UITableViewCell {
    
    static let cellId = "CollectedVideoCell"
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var lastTimeLabel: UILabel!
    @IBOutlet weak var addtime: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var viplabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setModdel(_ model: VideoModel) {
        videoImage.kfSetHorizontalImageWithUrl(model.cover_url)
        videoName.text = "\(model.title ?? "")"
        lastTimeLabel.text =  "上次观看到 \(formatTimDuration(model.view_time ?? 0))"
        durationLabel.text = formatTimDuration(model.duration ?? 0)
        viplabel.isHidden = !(model.is_vip?.boolValue ?? false)
        addtime.text = "\(model.online_time ?? "")"
    }
    
    func setLocalVideoModel(_ model: VideoDownLoad) {
        if let videoModel = decoderVideoModel(model.videoModelString) {
            setModdel(videoModel)
        }
    }
    
    func formatTimDuration(_ duration:Int) -> String {
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
    
    func decoderVideoModel(_ string: String?) -> VideoModel? {
        if string == nil || string!.isEmpty { return nil }
        
        if let data = string!.data(using: .utf8, allowLossyConversion: false) {
            let videoModel = try? JSONDecoder().decode(VideoModel.self, from: data)
            return videoModel
        }
        return nil
    }
    
}
