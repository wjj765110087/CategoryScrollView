//
//  CommentCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    static let cellId = "CommentCell"
    static let cellHeight: CGFloat = 50
    
    private lazy var avatarButton: UIButton = {
        let button = UIButton()
        button.setImage(ConstValue.kDefaultHeader, for: .normal)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        button.layer.cornerRadius = 10.5
        button.layer.masksToBounds = true
        button.tag = 100
        return button
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "哈麻批"
        label.textColor = UIColor.init(r: 157, g: 158, b: 158)
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    private lazy var userTagLab: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 9)
        label.layer.cornerRadius = 2.0
        label.layer.masksToBounds = true
        label.isHidden = true
        label.backgroundColor = UIColor.init(r: 0, g: 123, b: 255)
        return label
    }()
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "这个女的也太好看了吧"
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "10分钟"
        label.textColor = UIColor.init(r: 153, g: 153, b: 153)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var buttonClickHandler:((Int)->())?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(avatarButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(userTagLab)
        contentView.addSubview(commentLabel)
        contentView.addSubview(timeLabel)
        layoutPageSubViews()
    }
    
    func setModel(model: CommentAnswerModel) {
        let userDefaultHeader = UserModel.share().getUserHeader(model.user?.id)
        if model.user != nil {
            avatarButton.kfSetHeaderImageWithUrl(model.user?.cover_path, placeHolder: userDefaultHeader)
            nameLabel.text = model.user?.nikename ?? "老湿"
            userTagLab.isHidden = !(model.isZZ ?? false)
            userTagLab.text = (model.isZZ ?? false) ? "作者" : ""
        } else {
            avatarButton.kfSetHeaderImageWithUrl(model.cover_path, placeHolder: userDefaultHeader)
            nameLabel.text = model.nikename ?? "老湿"
            userTagLab.isHidden = !(model.isZZ ?? false)
            userTagLab.text = (model.isZZ ?? false) ? "作者" : ""
        }
        commentLabel.text = "\(model.content ?? "")"
        timeLabel.text = model.time ?? ""
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: -ClickEvent
private extension CommentCell {
    
    @objc func buttonClick(_ sender: UIButton) {
        DLog("=============\(sender.tag)")
        buttonClickHandler?(sender.tag)
    }
}

// MARK: Layout
private extension CommentCell {
    
    func layoutPageSubViews() {
        layoutAvatarButton()
        layoutNameLabel()
        layoutUserTagLabel()
        layoutCommentLabel()
        layoutTimeLabel()
    }
    
    func layoutAvatarButton() {
        avatarButton.snp.makeConstraints { (make) in
            make.leading.equalTo(60)
            make.top.equalTo(10)
            make.size.equalTo(CGSize(width: 21, height: 21))
        }
    }
    
    func layoutNameLabel() {
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarButton.snp.top)
            make.leading.equalTo(avatarButton.snp.trailing).offset(8.5)
            make.height.equalTo(15)
        }
    }
    
    func layoutUserTagLabel() {
        userTagLab.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel.snp.trailing).offset(5)
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.height.equalTo(12.5)
        }
    }
    
    func layoutCommentLabel() {
        commentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.equalTo(-45)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.bottom.equalTo(-10)
        }
    }
    
    func layoutTimeLabel() {
        timeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(userTagLab.snp.trailing).offset(9.5)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
    }
}
