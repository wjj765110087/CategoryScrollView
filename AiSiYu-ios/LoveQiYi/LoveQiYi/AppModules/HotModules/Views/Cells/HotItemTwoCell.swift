//
//  HotItemTwoCell.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/18.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

///热点视频cell
class HotItemTwoCell: UICollectionViewCell {
    static let cellId = "HotItemTwoCell"
    static let imageWidth: CGFloat = screenWidth - 20
    static let imageHeight: CGFloat = 147.0/355.0 * HotItemTwoCell.imageWidth
    static let itemSize = CGSize(width: screenWidth-20, height: HotItemTwoCell.imageHeight + 30)
    
    
    private lazy var imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PH")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLab: UILabel = {
       let label = UILabel()
       label.text = "有她们俩在就无敌 高桥圣子"
       label.textColor = UIColor(r: 71, g: 71, b: 71)
       label.font = UIFont.systemFont(ofSize: 13)
       label.textAlignment = .left
       return label
    }()
    
    private lazy var playCountLab: UILabel = {
        let label = UILabel()
        label.text = "播放量:0"
        label.textColor = UIColor(r: 162, g: 162, b: 162)
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var vipLabel: UILabel = {
       let label = UILabel()
       label.backgroundColor = UIColor(r: 255, g: 42, b: 49)
       label.textColor = .white
       label.text = "VIP"
       label.textAlignment = .center
       label.font = UIFont.systemFont(ofSize: 11)
       return label
    }()
    
    lazy var timeLab: UILabel = {
        let label = UILabel()
        label.text = "03:26:22"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutPageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didClick() {
        
    }
    
    func setModel(_ model: VideoModel) {
        self.imgView.kfSetHorizontalImageWithUrl(model.cover_url)
        self.titleLab.text = model.title
        self.timeLab.text = formatTimDuration(model.duration ?? 0)
        if let playCount = model.play_count {
            self.playCountLab.text =  playCount >= 10000 ? String(format: "播放量:%.2f万", Float(playCount)/Float(10000.0)) : "播放量:\(playCount)"
        }
        
        if let isVip =  model.is_vip {
            self.vipLabel.isHidden = !isVip.boolValue
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
}

private extension HotItemTwoCell {
    
    private func layoutPageView() {
        layoutPlayCountView()
        layoutTitleLabel()
        layoutImageView()
        layoutVipLabel()
        layoutTimeLabel()
    }
    
    private func layoutImageView() {
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(titleLab.snp.top).offset(-11)
        }
    }
    
    private func layoutTitleLabel() {
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(14)
            make.trailing.equalTo(playCountLab.snp.leading).offset(-5)
        }
    }
    
    private func layoutPlayCountView() {
        contentView.addSubview(playCountLab)
        playCountLab.snp.makeConstraints { (make) in
            make.trailing.equalTo(-11.5)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(11.5)
            make.width.lessThanOrEqualTo(150)
        }
    }
    
    private func layoutVipLabel() {
        imgView.addSubview(vipLabel)
        vipLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-17)
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 27.5, height: 15.5))
        }
    }
    
    private func layoutTimeLabel() {
        imgView.addSubview(timeLab)
        timeLab.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10.5)
            make.bottom.equalTo(-11)
        }
    }
}

