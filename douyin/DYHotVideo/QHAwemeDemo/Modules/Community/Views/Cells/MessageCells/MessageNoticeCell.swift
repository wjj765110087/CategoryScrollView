//
//  MessageNoticeCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class MessageNoticeCell: UITableViewCell {

    static let cellId = "MessageNoticeCell"
    static let cellHeight: CGFloat = 93.0
    
    private lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "app")
        image.layer.cornerRadius = 25
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        return image
    }()
    private lazy var titleLab: UILabel = {
        let label = UILabel()
        label.textColor  = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    private lazy var subLab: UILabel = {
        let label = UILabel()
        label.textColor  = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    private lazy var timeLab: UILabel = {
        let label = UILabel()
        label.textColor  = UIColor.init(r: 153, g: 153, b: 153)
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    private lazy var checkStatusLab: UILabel = {
        let label = UILabel()
        label.textColor  = UIColor.init(r: 0, g: 123, b: 255)
        label.font = UIFont.systemFont(ofSize: 11)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor  = ConstValue.kVcViewColor
        contentView.addSubview(iconImage)
        contentView.addSubview(titleLab)
        contentView.addSubview(subLab)
        contentView.addSubview(timeLab)
        contentView.addSubview(checkStatusLab)
        layoutPageViews()
    }
    
    func setModel(model: SystemMessageModel) {

        if let type = model.type {
            if type == .imageText {
                subLab.text = model.alter?.title ?? ""
            } else if type == .video {
                if let videoModel = model.alter?.video_model {
                    subLab.text = videoModel.title ?? ""
                }
            }
        }
        timeLab.text = model.created_at ?? ""
        if let status = model.alter?.status {
            switch status {
            case .checkSuccess:
                checkStatusLab.text = "审核通过"
                checkStatusLab.textColor = UIColor.init(r: 0, g: 123, b: 255)
            case .checkFailure:
                checkStatusLab.text = String(format: "审核不通过 %@", model.alter?.remark ?? "")
                checkStatusLab.textColor = UIColor.init(r: 215, g: 58, b: 45)
            }
        }
        if let type = model.type {
            switch type {
            case .imageText:
                titleLab.text = "发布动态审核通知"
               
            case .video:
                titleLab.text = "发布视频审核通知"
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - layout
extension MessageNoticeCell {
    
    private func layoutPageViews() {
        layoutIconImageView()
        layoutTitleLabel()
        layoutSubLab()
        layoutTimeLab()
        layoutCheckStatusLab()
    }
    private func layoutIconImageView() {
        iconImage.snp.makeConstraints { (make) in
            make.leading.equalTo(18)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(50)
        }
    }
    private func layoutTitleLabel() {
        titleLab.snp.makeConstraints { (make) in
            make.leading.equalTo(iconImage.snp.trailing).offset(19)
            make.top.equalTo(28)
        }
    }
    private func layoutSubLab() {
        subLab.snp.makeConstraints { (make) in
            make.leading.equalTo(iconImage.snp.trailing).offset(19)
            make.top.equalTo(titleLab.snp.bottom).offset(11.5)
            make.trailing.equalTo(-19)
            make.height.equalTo(20)
        }
    }
    private func layoutTimeLab() {
        timeLab.snp.makeConstraints { (make) in
            make.trailing.equalTo(-19.5)
            make.centerY.equalTo(titleLab.snp.centerY)
        }
    }
    private func layoutCheckStatusLab() {
        checkStatusLab.snp.makeConstraints { (make) in
            make.leading.equalTo(subLab)
            make.trailing.equalTo(-19)
            make.top.equalTo(subLab.snp.bottom).offset(5)
            make.bottom.equalTo(-10)
        }
    }
}
