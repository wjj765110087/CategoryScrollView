//
//  SeriesDetailCollectionCell.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/19.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

class SeriesDetailItemCell: UICollectionViewCell {
    
    static let cellId = "SeriesDetailItemCell"
    static let itemSize = CGSize(width: (screenWidth-30)/2, height: (screenWidth-30)/2 * 9/16 + 29)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutPageSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PH")
        imageView.isUserInteractionEnabled = true
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
    
    private lazy var vipLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(r: 255, g: 42, b: 49)
        label.textColor = .white
        label.text = "VIP"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    private lazy var timeLab: UILabel = {
        let label = UILabel()
        label.text = "03:26:22"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    func setModel(_ model: VideoModel?) {
         self.imgView.kfSetHorizontalImageWithUrl(model?.cover_url)
         self.titleLab.text = model?.title
         self.timeLab.text = model?.online_time
         self.vipLabel.isHidden = !(model?.is_vip?.boolValue ?? false)
         self.timeLab.text = formatTimDuration(model?.duration ?? 0)
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

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension SeriesDetailItemCell {
    private func layoutPageSubViews() {
        
        contentView.addSubview(titleLab)
        contentView.addSubview(imgView)
        imgView.addSubview(vipLabel)
        imgView.addSubview(timeLab)

        titleLab.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-4)
            make.height.equalTo(20)
        }
        
        imgView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(titleLab.snp.top).offset(-5)
        }
 
        vipLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-17)
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 27.5, height: 15.5))
        }
        
        timeLab.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10.5)
            make.bottom.equalTo(-11)
        }
    }
}


