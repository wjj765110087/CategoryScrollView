//
//  MessageZanCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class MessageZanCell: UITableViewCell {

    static let cellId = "MessageZanCell"
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
        label.text = "--"
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
        label.numberOfLines = 1
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
        backgroundColor = ConstValue.kVcViewColor
        selectionStyle = .none
        contentView.addSubview(iconImage)
        contentView.addSubview(titleLab)
        contentView.addSubview(desLab)
        contentView.addSubview(subLab)
        contentView.addSubview(timeLab)
        layoutPageViews()
    }
    
    func setModel(model: PraiseModel) {
        let defaltHeader = UserModel.share().getUserHeader(model.user?.id)
        iconImage.kfSetHeaderImageWithUrl(model.user?.cover_path, placeHolder: defaltHeader)
        if let type = model.type, let alter = model.alter {
            if type == "DYNAMIC" {
                if let type = alter.type {
                    if type == "IMG_TEXT" {
                        desLab.text = "赞了你的动态"
                    } else if type == "VIDEO" {
                        desLab.text = "赞了你的视频"
                    }
                }
            } else if type == "DY-COMMENT" {
                if let type = alter.type {
                    if type == "IMG_TEXT" {
                        desLab.text = "赞了你的动态"
                    } else if type == "VIDEO" {
                        let text = String(format: "%@ 赞了你的视频", model.user?.nikename ?? "")
                        titleLab.text = text
                        desLab.text = "赞了你的视频"
                    }
                }
            } else if type == "VIDEO-COMMENT" {
                if let type = alter.type {
                    if type == "IMG_TEXT" {
                        desLab.text = "赞了你的评论"
                    } else if type == "VIDEO" {
                        desLab.text = "赞了你的视频"
                    }
                }
            }
        }
        
        let text = String(format: "%@", model.user?.nikename ?? "")
        titleLab.text = text
        if let title = model.alter?.title {
            subLab.text = title
        }
        timeLab.text = model.created_at ?? ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - layout
extension MessageZanCell {
    
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
