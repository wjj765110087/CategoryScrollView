//
//  MessagePinglunCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class MessagePinglunCell: UITableViewCell {
    
    static let cellId = "MessagePinglunCell"
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
        label.text = "--:--"
        label.textColor  = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var desLab: UILabel = {
        let label = UILabel()
        label.text = "----"
        label.textColor  = UIColor.init(r: 153, g: 153, b: 153)
        label.backgroundColor = ConstValue.kViewLightColor
        label.layer.cornerRadius = 3.0
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    private lazy var subLab: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor  = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var timeLab: UILabel = {
        let label = UILabel()
        label.text = "--:--"
        label.textColor  = UIColor.init(r: 153, g: 153, b: 153)
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = ConstValue.kVcViewColor
        contentView.addSubview(iconImage)
        contentView.addSubview(titleLab)
        contentView.addSubview(desLab)
        contentView.addSubview(subLab)
        contentView.addSubview(timeLab)
        layoutPageViews()
    }
    
    func setModel(model: CommentMessageModel) {
        let defaltHeader = UserModel.share().getUserHeader(model.user?.id)
        iconImage.kfSetHeaderImageWithUrl(model.user?.cover_path, placeHolder: defaltHeader)
        titleLab.text = model.user?.nikename ?? ""
        timeLab.text = model.created_at ?? ""
        subLab.text = model.alter?.title ?? ""
        if let type = model.type{
            if type == CommentDynamicType.DY_COMMENT_REPLY.rawValue {
                desLab.text = "回复了你的评论"
            } else if type == CommentDynamicType.DY_COMMENT.rawValue {
                desLab.text = "评论了你的动态"
            } else if type == CommentDynamicType.VIDEO.rawValue {
                desLab.text = "评论了你的视频"
            } else if type == CommentDynamicType.VIDEO_COMMENT.rawValue {
                desLab.text = "评论了你的视频"
            } else if type == CommentDynamicType.VIDEO_COMMENT_REPLY.rawValue {
                desLab.text = "回复了你的评论"
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - layout
extension MessagePinglunCell {
    
    private func layoutPageViews() {
        layoutIconImageView()
        layoutTitleLabel()
        layoutDesLab()
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
    
    private func layoutDesLab() {
        desLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLab)
            make.leading.equalTo(titleLab.snp.trailing).offset(10)
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
