//
//  CommunityVideoCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/1.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

/// 视频cell
class CommunityVideoCell: UITableViewCell {
    
    static let cellId = "CommunityVideoCell"
    
    lazy var userView: CommunityListUser = {
        let view = CommunityListUser(frame: CGRect.zero)
        return view
    }()
    lazy var bottomView: CommunityBottomView = {
        if let view = Bundle.main.loadNibNamed("CommunityBottomView", owner: nil, options: nil)?[0] as? CommunityBottomView {
            return view
        }
        return CommunityBottomView()
    }()
    lazy var videoCoverBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "CommunityPlayIcon"), for: .normal)
        button.backgroundColor = UIColor(r: 15, g: 15, b: 29)
        button.addTarget(self, action: #selector(videoClick), for: .touchUpInside)
        button.layer.cornerRadius = 3.0
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    lazy var topicFakeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(topicClick), for: .touchUpInside)
        return button
    }()
    let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    var videoClickHandler:(()->Void)?
    var bottomActionHandler:((_ actionId: Int)->Void)?
    var userViewActionHandler:((_ actionId: Int)->Void)?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(userView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(topicFakeButton)
        contentView.addSubview(videoCoverBtn)
        contentView.addSubview(bottomView)
        layoutPageSubviews()
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func topicClick() {
        bottomActionHandler?(1)
    }
    func setModel(_ topicModel: TopicModel, _ topicPart: TopicListPart) {
        if let user = topicModel.user {
            userView.setUserModel(user,topicPart, topicModel.is_top == 1, topicModel.is_recommend == 1)
        }
        userView.isTopLabel.isHidden = (topicModel.check ?? 0) != 1
        userView.isGoodLabel.isHidden = (topicModel.check ?? 0) != 1
        userView.setTime(topicModel.time)
        if (topicModel.check ?? 0) == 0 {
            userView.checkStatuButton.setImage(UIImage(named: "shenhezhong"), for: .normal)
            userView.checkStatuButton.setTitle(" 审核中...", for: .normal)
            userView.checkStatuButton.setTitleColor(UIColor(r: 0, g: 123, b: 255), for: .normal)
        } else if (topicModel.check ?? 0) == -1 {
            userView.checkStatuButton.setImage(UIImage(named: "noPassWork"), for: .normal)
            userView.checkStatuButton.setTitle(" 审核未通过", for: .normal)
            userView.checkStatuButton.setTitleColor(UIColor(r: 255, g: 42, b: 49), for: .normal)
        } else if (topicModel.check ?? 0) == 1 {
            userView.checkStatuButton.setImage(nil, for: .normal)
            userView.checkStatuButton.isHidden = true
            userView.checkStatuButton.setTitle("", for: .normal)
        }
        if (topicModel.is_attention ?? .noRecommend) == .noRecommend {
            userView.addFollowButton.layer.borderColor = UIColor(r: 0, g: 123, b: 255).cgColor
            userView.addFollowButton.layer.borderWidth = 1.0
            userView.addFollowButton.backgroundColor = UIColor.clear
            userView.addFollowButton.setTitle("+关注", for: .normal)
            userView.addFollowButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            userView.addFollowButton.layer.borderColor = UIColor.clear.cgColor
            userView.addFollowButton.layer.borderWidth = 0
            userView.addFollowButton.backgroundColor =  ConstValue.kViewLightColor
            userView.addFollowButton.setTitle("已关注", for: .normal)
            userView.addFollowButton.setTitleColor(UIColor(r: 153, g: 153, b: 153), for: .normal)
        }
        if let content = topicModel.content {
              contentLabel.attributedText =  TextSpaceManager.configColorString(allString: "#\(topicModel.topic?.title ?? "巨乳合集")#  \(content)", attribStr: "#\(topicModel.topic?.title ?? "巨乳合集")#", ConstValue.kTitleYelloColor, UIFont.boldSystemFont(ofSize: 14), 7.0)
        }
        if let topicTitle =  topicModel.topic?.title {
            let width = (topicTitle.count + 2) * 17
            topicFakeButton.snp.updateConstraints { (make) in
                make.width.equalTo(CGFloat(width))
            }
        }
        if let videoModels = topicModel.video, videoModels.count > 0 {
            setVideo(videoModels[0])
        }
        bottomView.commentTipsBtn.setTitle("\(getStringWithNumber(topicModel.comment_count ?? 0))", for: .normal)
        bottomView.favorTipsBtn.setTitle("\(getStringWithNumber(topicModel.like ?? 0))", for: .normal)
        bottomView.favorTipsBtn.isSelected = (topicModel.is_like ?? .unlike) == .like
        /// actionId : 1.话题点击 2.评论点击 3.分享点击 4.点赞
        bottomView.itemActionHandler = { [weak self] (actionId) in
            self?.bottomActionHandler?(actionId)
        }
        //1. 用户点击 2.删除动态 3.对用户添加关注
        userView.userItemClickHandler = { [weak self] (actionId) in
            self?.userViewActionHandler?(actionId)
        }
    }
    
    @objc private func videoClick() {
        videoClickHandler?()
    }
    
    func setVideo(_ model: VideoModel) {
        videoCoverBtn.kfSetVerticalVBackgroundImageWithUrl(model.cover_path)
    }
    
}

// MARK: - layout
private extension CommunityVideoCell {
    func layoutPageSubviews() {
        layoutUserView()
        layoutBottomView()
        layoutVideoButton()
        layoutContentLabel()
        layoutTopicButton()
    }
    func layoutUserView() {
        userView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(15)
            make.height.equalTo(CommunityListUser.height)
        }
    }
    func layoutBottomView() {
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(CommunityBottomView.height)
        }
    }
    func layoutContentLabel() {
        contentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(userView.snp.bottom).offset(5)
            make.bottom.equalTo(videoCoverBtn.snp.top).offset(-10)
        }
    }
    func layoutVideoButton() {
        let width: CGFloat = (screenWidth - 30)/2
        let height: CGFloat = width*1.39
        videoCoverBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.bottom.equalTo(bottomView.snp.top).offset(-10)
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
    }
    func layoutTopicButton() {
        topicFakeButton.snp.makeConstraints { (make) in
            make.leading.equalTo(contentLabel)
            make.top.equalTo(contentLabel)
            make.height.equalTo(20)
            make.width.equalTo(0)
        }
    }
}
