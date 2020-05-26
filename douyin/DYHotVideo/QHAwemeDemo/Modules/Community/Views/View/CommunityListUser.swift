//
//  CommunityListUser.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/9/30.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class CommunityListUser: UIView {
    
    static let height: CGFloat = 75.0
    
    let headerImage: UIImageView = {
        let header = UIImageView()
        header.layer.cornerRadius = 24.0
        header.contentMode = .scaleAspectFill
        header.layer.masksToBounds = true
        header.image = ConstValue.kDefaultHeader
        header.isUserInteractionEnabled = true
        return header
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "风吹屁屁凉"
        return label
    }()
    let isTopLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkText
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = "置顶"
        label.textAlignment = .center
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor(r: 255, g: 241, b: 18)
        return label
    }()
    let isGoodLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = "精"
        label.textAlignment = .center
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor(r: 255, g: 42, b: 49)
        return label
    }()
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 153, g: 153, b: 153)
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 153, g: 153, b: 153)
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = "35分钟前"
        return label
    }()
    lazy var checkStatuButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(UIColor(r: 0, g: 123, b: 255), for: .normal)
        button.setImage(UIImage(named: "shenhezhong"), for: .normal)
        button.addTarget(self, action: #selector(checkButtonClick), for: .touchUpInside)
        return button
    }()
    lazy var addFollowButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("+关注", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(addFollowButtonClick(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 13.5
        button.layer.masksToBounds = true
        return button
    }()
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(deleteButtonClick(_:)), for: .touchUpInside)
        button.setImage(UIImage(named: "deleteSelfTopic"), for: .normal)
        return button
    }()
    lazy var fakeUserClickButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(userClick), for: .touchUpInside)
        return button
    }()
    /// actionId: 1. 用户点击 2.删除动态 3.对用户添加关注
    var userItemClickHandler:((_ actionId: Int)->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(headerImage)
        addSubview(nameLabel)
        addSubview(isTopLabel)
        addSubview(isGoodLabel)
        addSubview(locationLabel)
        addSubview(timeLabel)
        addSubview(addFollowButton)
        addSubview(deleteButton)
        addSubview(fakeUserClickButton)
        addSubview(checkStatuButton)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addFollowButtonClick(_ sender: UIButton) {
        userItemClickHandler?(3)
    }
    @objc func deleteButtonClick(_ sender: UIButton) {
        userItemClickHandler?(2)
    }
    @objc func userClick() {
        userItemClickHandler?(1)
    }
    @objc func checkButtonClick() {
        userItemClickHandler?(4)
    }
    
    func setUserModel(_ user: UserInfoModel, _ part: TopicListPart, _ isTop: Bool, _ isGood: Bool) {
        if part == .userCenter || part == .acountCnter  { /// 用户中心： 1.关注按钮隐藏。2.
            addFollowButton.isHidden = true
            deleteButton.isHidden = part == .userCenter
            checkStatuButton.isHidden = part == .userCenter
        } else {
            deleteButton.isHidden = true
            checkStatuButton.isHidden = true
            addFollowButton.isHidden = user.id == UserModel.share().userInfo?.id  // 是自己
        }
        headerImage.kfSetHeaderImageWithUrl(user.cover_path, placeHolder: UserModel.share().getUserHeader(user.id))
        nameLabel.text = user.nikename ?? "老湿"
        if isTop {
            isTopLabel.snp.updateConstraints { (make) in
                make.width.equalTo(38)
            }
        } else {
            isTopLabel.snp.updateConstraints { (make) in
                make.width.equalTo(0)
            }
        }
        if isGood {
            isGoodLabel.snp.updateConstraints { (make) in
                make.width.equalTo(19)
            }
        } else {
            isGoodLabel.snp.updateConstraints { (make) in
                make.width.equalTo(0)
            }
        }
    }
    
    func setTime(_ time: String?) {
         timeLabel.text = time
    }
    
}

// MARK: - Layout
private extension CommunityListUser {
    func layoutPageSubviews() {
        layoutAddFollowButton()
        layoutDeleteButton()
        layoutHeaderImage()
        layoutNamelabel()
        layoutIsToplabel()
        layoutIsGoodlabel()
        layoutLocationLabel()
        layoutTimeLabel()
        layoutFakeUserClickButton()
        layoutCheckButton()
        
    }
    func layoutHeaderImage() {
        headerImage.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(48)
        }
    }
    func layoutNamelabel() {
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(headerImage.snp.trailing).offset(12)
            make.top.equalTo(headerImage.snp.top).offset(5)
        }
    }
    func layoutIsToplabel() {
        isTopLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel.snp.trailing).offset(5)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(18)
            make.width.equalTo(0)
        }
    }
    func layoutIsGoodlabel() {
        isGoodLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(isTopLabel.snp.trailing).offset(6)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(18)
            make.width.equalTo(0)
        }
    }
    func layoutLocationLabel() {
        locationLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
    }
    func layoutTimeLabel() {
        timeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(locationLabel.snp.trailing).offset(0)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.height.equalTo(18)
        }
    }
    func layoutAddFollowButton() {
        addFollowButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-15)
            make.height.equalTo(27)
            make.width.equalTo(60)
        }
    }
    func layoutDeleteButton() {
        deleteButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-15)
            make.height.equalTo(27)
            make.width.equalTo(40)
        }
    }
    func layoutFakeUserClickButton() {
        fakeUserClickButton.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(headerImage)
            make.trailing.equalTo(nameLabel.snp.trailing)
        }
    }
    func layoutCheckButton() {
        checkStatuButton.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel.snp.trailing).offset(15)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(30)
        }
    }
}
