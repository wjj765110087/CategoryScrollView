//
//  VideoMoreCollectionViewCell.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/22.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

class VideoItemCollectionCell: UICollectionViewCell {
    
    static let cellId = "VideoItemCollectionCell"
    static let itemSize = CGSize(width: (screenWidth-30)/2, height: 140)
    
    private lazy var imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 3
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "PH")
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutPageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(_ model: VideoGuessLikeModel) {
        self.imgView.kfSetHorizontalImageWithUrl(model.cover_url)
        self.titleLab.text = model.title
        if let isVip = model.is_vip {
            self.vipLabel.isHidden = isVip.boolValue
        }
        self.timeLab.text = model.online_time
    }
}

extension VideoItemCollectionCell {
    
    private func layoutPageView() {
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
            make.left.equalTo(10)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(14)
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
