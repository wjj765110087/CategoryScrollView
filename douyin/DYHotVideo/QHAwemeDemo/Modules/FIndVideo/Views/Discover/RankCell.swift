//
//  RankCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/5.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class RankCell: UITableViewCell {
    
    static let cellId = "RankCell"
    static let cellHeight: CGFloat = 145.0
    
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nickNamelabel: UILabel!
    @IBOutlet weak var speakLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var zanImage: UIImageView!
    @IBOutlet weak var zanImageWidth: NSLayoutConstraint!
    @IBOutlet weak var countLeftMargin: NSLayoutConstraint!
    
    @IBOutlet weak var coinsLabel: UILabel!
    
    @IBOutlet weak var earnCoinsLabel: UILabel!
    
    var rankType: RankType = .week
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setModel(model: FindRankModel) {
        zanImage.isHidden = true
        playButton.isHidden = true
        coinsLabel.isHidden = true
        earnCoinsLabel.isHidden = true
        playCountLabel.isHidden = false
        zanImageWidth.constant = 0
        countLeftMargin.constant = 0
        let userDefaultHeader = UserModel.share().getUserHeader(model.video_model?.user?.id)
        coverImageView.kfSetVerticalImageWithUrl(model.cover_path ?? model.video_model?.cover_path)
        if let top = model.top {
            rankLabel.text = String(format: "TOP.%d", top)
        }
        avatarButton.kfSetHeaderImageWithUrl(model.video_model?.user?.cover_path, placeHolder: userDefaultHeader)
        nickNamelabel.text = model.video_model?.user?.nikename
        speakLabel.text = model.title ?? ""
        if let play_count = model.count {
            if rankType == .week {
                playCountLabel.text = String(format: "本周播放: %d", play_count)
            } else if rankType == .month {
                playCountLabel.text = String(format: "本月播放: %d", play_count)
            } else if rankType == .lastMonth {
                playCountLabel.text = String(format: "上月播放: %d", play_count)
            }
        } else {
            if rankType == .week {
                playCountLabel.text = String(format: "本周播放: %d", model.play_count ?? 0)
            } else if rankType == .month {
                playCountLabel.text = String(format: "本月播放: %d", model.play_count ?? 0)
            } else if rankType == .lastMonth {
                playCountLabel.text = String(format: "上月播放: %d", model.play_count ?? 0)
            }
        }
    }
    
    func setActivityModel(model: FindRankModel) {
        zanImage.isHidden = false
        playButton.isHidden = true
        coinsLabel.isHidden = true
        earnCoinsLabel.isHidden = true
        playCountLabel.isHidden = false
        zanImageWidth.constant = 12.0
        countLeftMargin.constant = 10.0
        let userDefaultHeader = UserModel.share().getUserHeader(model.video_model?.user?.id)
        coverImageView.kfSetVerticalImageWithUrl(model.cover_path ?? model.video_model?.cover_path)
        if let top = model.top {
            rankLabel.text = String(format: "TOP.%d", top)
        }
        avatarButton.kfSetHeaderImageWithUrl(model.video_model?.user?.cover_path, placeHolder: userDefaultHeader)
        nickNamelabel.text = model.video_model?.user?.nikename
        speakLabel.text = model.title ?? ""
        if let play_count = model.count {
            playCountLabel.text = getStringWithNumber(play_count)
        }
    }
    
    func setTopicRankModel(model: TopicRankModel) {
        coinsLabel.isHidden = true
        earnCoinsLabel.isHidden = true
        zanImage.isHidden = false
        playCountLabel.isHidden = false
        playButton.isHidden = (model.type != .video)
        zanImageWidth.constant = 12.0
        countLeftMargin.constant = 10.0
        let userDefaultHeader = UserModel.share().getUserHeader(model.user?.id)
        coverImageView.kfSetVerticalImageWithUrl(model.cover_path ?? model.video_model?.cover_path)
        
        if let top = model.top {
            rankLabel.text = String(format: "TOP.%d", top)
        }
        avatarButton.kfSetHeaderImageWithUrl(model.user?.avatar, placeHolder: userDefaultHeader)
        nickNamelabel.text = model.user?.nikename
        speakLabel.text = model.content ?? ""
        if let count = model.count {
            playCountLabel.text = getStringWithNumber(count)
        }
    }
    func setCoinsRankModel(model: TopicRankModel) {
        coinsLabel.isHidden = false
        earnCoinsLabel.isHidden = false
        zanImage.isHidden = true
        playCountLabel.isHidden = true
        playButton.isHidden = false
        zanImageWidth.constant = 12.0
        countLeftMargin.constant = 10.0
        let userDefaultHeader = UserModel.share().getUserHeader(model.user?.id)
        coverImageView.kfSetVerticalImageWithUrl(model.cover_path ?? model.video_model?.cover_path)
        
        if let top = model.top {
            rankLabel.text = String(format: "TOP.%d", top)
        }
        avatarButton.kfSetHeaderImageWithUrl(model.user?.avatar, placeHolder: userDefaultHeader)
        nickNamelabel.text = model.user?.nikename
        speakLabel.text = "\(model.video_model?.title ?? "")"
        if let coins = model.video_model?.coins {
            coinsLabel.text = "\(getStringWithNumber(coins))金币"
        }
        if let earnCoins = model.gain_conis_count {
            earnCoinsLabel.text = "已赚取\(getStringWithNumber(earnCoins.int))金币"
        }
    }
}
