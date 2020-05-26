//
//  MessageSystemNoticeCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/9.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class MessageSystemNoticeCell: UITableViewCell {
    
    static let cellId = "MessageNoticeCell"
    static let cellHeight: CGFloat = 93.0
    
    private lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.image = ConstValue.kDefaultHeader
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 25
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var titleLab: UILabel = {
        let label = UILabel()
        label.text = "-----------"
        label.textColor  = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var subLab: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor  = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var timeLab: UILabel = {
        let label = UILabel()
        label.text = "-------"
        label.textColor  = UIColor.init(r: 153, g: 153, b: 153)
        label.font = UIFont.systemFont(ofSize: 11)
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
        layoutPageViews()
    }
    
    func setModel(model: NoticeMessageModel) {
        if let title = model.alter?.title {
            subLab.text = title
        }
        timeLab.text = model.created_at ?? ""

        if let type = model.type, let dynamic_type = model.dynamic_type   {
            if type == .follow {
                if dynamic_type == .imageText {
                    let text = String(format: "你关注的%@发布动态", model.user?.nikename ?? "")
                    titleLab.attributedText = TextSpaceManager.configColorString(allString: text, attribStr: (model.user?.nikename ?? "") , UIColor.init(r: 0, g: 123, b: 255), UIFont.systemFont(ofSize: 14))
                } else if dynamic_type == .video {
                    let text = String(format: "你关注的%@发布视频", model.user?.nikename ?? "")
                    titleLab.attributedText = TextSpaceManager.configColorString(allString: text, attribStr:(model.user?.nikename ?? "") , UIColor.init(r: 0, g: 123, b: 255), UIFont.systemFont(ofSize: 14))
                }
                iconImage.kfSetHeaderImageWithUrl(model.user?.cover_path, placeHolder: UserModel.share().getUserHeader(model.user?.id))
            } else if type == .topic {
                if dynamic_type == .imageText {
                    let text = String(format: "你收藏的%@发布动态", model.topic?.title ?? "")
                    titleLab.attributedText = TextSpaceManager.configColorString(allString: text, attribStr: (model.topic?.title ?? "") , UIColor.init(r: 0, g: 123, b: 255), UIFont.systemFont(ofSize: 14))
                } else if dynamic_type == .video {
                    let text = String(format: "你收藏的%@发布动态", model.topic?.title ?? "")
                    titleLab.attributedText = TextSpaceManager.configColorString(allString: text, attribStr: (model.topic?.title ?? "") , UIColor.init(r: 0, g: 123, b: 255), UIFont.systemFont(ofSize: 14))
                }
                iconImage.kfSetHeaderImageWithUrl(model.topic?.cover_url, placeHolder: UserModel.share().getUserHeader(model.user?.id))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - layout
extension MessageSystemNoticeCell {
    
    private func layoutPageViews() {
        layoutIconImageView()
        layoutTitleLabel()
        layoutSubLab()
        layoutTimeLab()
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
            make.trailing.equalTo(-10)
        }
    }
    
    private func layoutTimeLab() {
        timeLab.snp.makeConstraints { (make) in
            make.leading.equalTo(subLab.snp.leading)
            make.top.equalTo(subLab.snp.bottom).offset(5)
        }
    }
}
