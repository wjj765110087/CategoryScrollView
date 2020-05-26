//
//  VideoThridItemCell.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/13.
//  Copyright © 2018年 pro5. All rights reserved.
//

import UIKit

/// 一排3个视频 cell
class VideoThridItemCell: UICollectionViewCell {
    
    static let cellId = "VideoThridItemCell"
    
    var videoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 2
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    var videoNameLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.textColor = UIColor.white
        lable.text = ""
        lable.textAlignment = .left
        return lable
    }()
    var collectionBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "zanNormal"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    }()
    var coinLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 10)
        lable.textColor = UIColor.white
        lable.textAlignment = .center
        lable.backgroundColor = UIColor(r: 255, g: 42, b: 49)
        lable.layer.cornerRadius = 3
        lable.layer.masksToBounds = true
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        addSubview(videoImageView)
        addSubview(videoNameLable)
        addSubview(collectionBtn)
        addSubview(coinLable)
        layoutPageSubviews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

private extension VideoThridItemCell {
    
    func layoutPageSubviews() {
        layoutVideoImageView()
        layoutNameLable()
        layoutCollectionBtn()
        layoutCoinLabel()
    }
    func layoutVideoImageView() {
        let itemWith = (ConstValue.kScreenWdith - 20)/3
        videoImageView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.width.equalTo(itemWith)
            make.height.equalTo(itemWith * 1.3)
        }
    }
    func layoutNameLable() {
        videoNameLable.snp.makeConstraints { (make) in
            make.leading.equalTo(5)
            make.trailing.equalTo(-5)
            make.top.equalTo(videoImageView.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
    }

    func layoutCollectionBtn() {
        collectionBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(5)
            make.bottom.equalTo(videoImageView.snp.bottom).offset(-3)
            make.height.equalTo(20)
        }
    }
    func layoutCoinLabel() {
        coinLable.snp.makeConstraints { (make) in
            make.trailing.equalTo(-5)
            make.top.equalTo(5)
            make.height.equalTo(18)
            make.width.equalTo(40)
        }
    }
    
}
