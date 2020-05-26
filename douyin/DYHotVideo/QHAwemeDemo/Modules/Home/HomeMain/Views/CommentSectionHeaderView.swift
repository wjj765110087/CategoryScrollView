//
//  CommentSectionHeaderView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  评论组头

import UIKit

class CommentSectionHeaderView: UITableViewHeaderFooterView {

    static let reuseId = "CommentSectionHeaderView"
    static let headerHeight: CGFloat = 50.0
    
    private lazy var avatarButton: UIButton = {
        let button = UIButton()
        button.setImage(ConstValue.kDefaultHeader, for: .normal)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        button.layer.cornerRadius = 15.0
        button.layer.masksToBounds = true
        button.tag = 102
       return button
    }()
    private lazy var nameLabel: UILabel = {
       let label = UILabel()
       label.text = "哈麻批"
       label.textColor = UIColor.init(r: 157, g: 158, b: 158)
       label.font = UIFont.systemFont(ofSize: 11)
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
    private lazy var commentEventButton: UIButton = {
        let button = UIButton()
        button.tag = 103
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "10分钟"
        label.textColor = UIColor.init(r: 153, g: 153, b: 153)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var zanButton: UIButton = {
       let button = UIButton()
       button.setImage(UIImage(named: "zanNormal"), for: .normal)
       button.setImage(UIImage(named: "zanSelected"), for: .selected)
       return button
    }()
    
    private lazy var zanCount: UILabel = {
       let label = UILabel()
       label.text = "0"
       label.textColor = UIColor.init(r: 153, g: 153, b: 153)
       label.font = UIFont.systemFont(ofSize: 10)
       return label
    }()
    
    private lazy var zanEventButton: UIButton = {
       let button = UIButton()
       button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
       button.tag = 101
       return button
    }()
    
    
    var buttonClickHandler:((Int)->())?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(avatarButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(commentEventButton)
        contentView.addSubview(timeLabel)
        contentView.addSubview(zanButton)
        contentView.addSubview(zanCount)
        contentView.addSubview(zanEventButton)
        layoutPageSubViews()
    }
    
    func setModel(model: VideoCommentModel) {
        if model.user != nil {
            avatarButton.kfSetHeaderImageWithUrl(model.user?.cover_path, placeHolder: UserModel.share().getUserHeader(model.user!.id))
            nameLabel.text = model.user?.nikename ?? ""
        } else {
            avatarButton.kfSetHeaderImageWithUrl(model.cover_path, placeHolder: UserModel.share().getUserHeader(model.user!.id))
            nameLabel.text = model.nikename ?? ""
        }
        commentLabel.text = model.content ?? ""
        timeLabel.text = model.time ?? ""
        zanCount.text = "\(model.like ?? 0)"
        zanButton.isSelected = model.is_like == 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: -ClickEvent
private extension CommentSectionHeaderView {
    
    @objc func buttonClick(_ sender: UIButton) {
        DLog("=============\(sender.tag)")
        buttonClickHandler?(sender.tag)
    }
}

// MARK: Layout
private extension CommentSectionHeaderView {
    
    func layoutPageSubViews() {
        layoutAvatarButton()
        layoutNameLabel()
        layoutCommentLabel()
        layoutEventCommentButton()
        layoutTimeLabel()
        layoutZanButton()
        layoutZanCount()
        layoutZanEventButton()
    }
    
    func layoutAvatarButton() {
        avatarButton.snp.makeConstraints { (make) in
            make.leading.equalTo(24)
            make.top.equalTo(5)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
    
    func layoutNameLabel() {
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarButton.snp.top)
            make.leading.equalTo(avatarButton.snp.trailing).offset(8.5)
            make.height.equalTo(15)
        }
    }

    func layoutCommentLabel() {
        commentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.trailing.equalTo(-50)
            make.bottom.equalToSuperview().offset(-3)
        }
    }
    
    func layoutEventCommentButton() {
        commentEventButton.snp.makeConstraints { (make) in
            make.leading.equalTo(commentLabel)
            make.trailing.equalTo(zanButton.snp.leading).offset(-10)
            make.top.bottom.equalToSuperview()
        }
    }
    
    func layoutTimeLabel() {
        timeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel.snp.trailing).offset(9.5)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
    }
    
    func layoutZanButton() {
        zanButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-24.5)
            make.top.equalTo(nameLabel.snp.top).offset(2)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
    }
    
    func layoutZanCount() {
        zanCount.snp.makeConstraints { (make) in
            make.top.equalTo(zanButton.snp.bottom).offset(5.5)
            make.centerX.equalTo(zanButton.snp.centerX)
        }
    }
    
    func layoutZanEventButton() {
        zanEventButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(zanButton.snp.centerX)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
}
