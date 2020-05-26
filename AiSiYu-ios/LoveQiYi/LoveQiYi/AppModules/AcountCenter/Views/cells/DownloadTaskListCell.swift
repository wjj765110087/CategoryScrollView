//
//  DownloadTaskListCell.swift
//  XSVideo
//
//  Created by pro5 on 2019/2/18.
//  Copyright © 2019年 pro5. All rights reserved.
//

import UIKit

class DownloadTaskListCell: UITableViewCell {
    
    static let cellId = "DownloadTaskListCell"
    
    lazy var imagePic: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    var videoNameLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.boldSystemFont(ofSize: 13)
        lable.numberOfLines = 2
        return lable
    }()
    var progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.progressViewStyle = .default
        progress.progressTintColor = kAppDefaultTitleColor
        progress.trackTintColor = UIColor.groupTableViewBackground
        progress.progress = 0.0
        return progress
    }()
    var percentageLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = UIColor.darkGray
        return lable
    }()
    lazy var statuButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("等待下载", for: .normal)
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(statuButtonClick(_:)), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    var downLoadStatuButtonClick:((_ sender: UIButton) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imagePic)
        contentView.addSubview(videoNameLable)
        contentView.addSubview(statuButton)
        contentView.addSubview(progressView)
        contentView.addSubview(percentageLable)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func statuButtonClick(_ sender: UIButton) {
        downLoadStatuButtonClick?(sender)
    }
    
    func setLocalVideoModel(_ model: VideoDownLoad) {
        if let videoModel = decoderVideoModel(model.videoModelString) {
            imagePic.kfSetHorizontalImageWithUrl(videoModel.cover_url)
            videoNameLable.text = videoModel.title ?? ""
        }
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


// MARK: - Layout
private extension DownloadTaskListCell {
    
    func layoutPageSubviews() {
        layoutImageView()
        layoutNameLable()
        layoutStatuButton()
        layoutProgressView()
        layoutPercentageLable()
    }
    
    func layoutImageView() {
        let width: CGFloat = 170.0
        imagePic.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(width)
            make.height.equalTo(width * 9/16)
        }
    }
    
    func layoutNameLable() {
        videoNameLable.snp.makeConstraints { (make) in
            make.leading.equalTo(imagePic.snp.trailing).offset(10)
            make.top.equalTo(imagePic.snp.top)
            make.height.equalTo(35)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    func layoutStatuButton() {
        statuButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-15)
            make.top.equalTo(progressView.snp.bottom).offset(15)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
    }
    
    func layoutProgressView() {
        progressView.snp.makeConstraints { (make) in
            make.leading.equalTo(videoNameLable)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(2)
            make.top.equalTo(videoNameLable.snp.bottom).offset(10)
        }
    }
    
    func layoutPercentageLable() {
        percentageLable.snp.makeConstraints { (make) in
            make.leading.equalTo(progressView)
            make.top.equalTo(progressView.snp.bottom).offset(15)
            make.height.equalTo(30)
            make.trailing.equalTo(statuButton.snp.leading).offset(-10)
        }
    }
}
