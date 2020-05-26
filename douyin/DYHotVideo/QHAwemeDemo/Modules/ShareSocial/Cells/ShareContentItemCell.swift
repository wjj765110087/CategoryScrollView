//
//  ShareContentItemCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/2.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

struct ShareTypeItemModel {
    var title: String
    var content: String? = nil
    var imageUrl: String? = nil
    var type: ShareContentType
}

enum ShareContentType: Int {
    case text = 0
    case textLink = 1
    case picture = 2
}

class ShareContentItemCell: UICollectionViewCell {
    
    static let cellId = "ShareContentItemCell"
    static let itemSize = CGSize(width: screenWidth*0.6, height: screenWidth*4.15/5)
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.text = "分享内容"
        return label
    }()
    var contentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.text = "抖阴短视频，各种小姐姐视频超好看，你也来一起看吧…"
        return label
    }()
    
    let imageButton: ShareImageContentView = {
        guard let card = Bundle.main.loadNibNamed("ShareImageContentView", owner: nil, options: nil)?[0] as? ShareImageContentView else { return  ShareImageContentView() }
        return card
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = ConstValue.kViewLightColor
        contentView.layer.cornerRadius = 9
        contentView.layer.masksToBounds = true
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(imageButton)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setShareTypeModel(_ model: ShareTypeItemModel) {
        
        titleLabel.text = model.title
        UserModel.share().shareText = model.content ?? ShareContentItemCell.getDefaultContentString()

        if model.type == .textLink || model.type == .text {
            contentLabel.text = ShareContentItemCell.getDefaultContentString()
        } else {
            contentLabel.text = model.content ?? ShareContentItemCell.getDefaultContentString()
        }
        if model.type == .textLink || model.type == .text {
            imageButton.isHidden = true
            contentLabel.isHidden = false
        } else {
            imageButton.isHidden = false
            contentLabel.isHidden = true
        }
    }
    
    /// 获取默认分享文本
    class func getDefaultContentString()-> String {
        var downString = ConstValue.kAppDownLoadLoadUrl
        if let downloadString = AppInfo.share().share_url {
            if downloadString.hasSuffix("/") {
                downString = downloadString
            } else {
                downString = String(format: "%@%@", downloadString, "/")
            }
        }
        if let userInviteCode = UserModel.share().userInfo?.code {
            downString = String(format: "%@%@",downString, userInviteCode)
        } else {
            if let codeSave = UserDefaults.standard.object(forKey: UserDefaults.kUserInviteCode) as? String {
                downString = String(format: "%@%@", downString, codeSave)
            } else {
                downString = String(format: "%@", downString)
            }
        }
        var textShare = "抖阴小视频"
        if let textToShare = AppInfo.share().share_text {
            if textToShare.contains("{{share_url}}") {
                textShare = textToShare.replacingOccurrences(of: "{{share_url}}", with: downString)
            }
        }
        return textShare
    }
    
    class func getDownLoadUrl() -> String {
        var downString = ConstValue.kAppDownLoadLoadUrl
        if let downloadString = AppInfo.share().share_url {
            if downloadString.hasSuffix("/") {
                downString = downloadString
            } else {
                downString = String(format: "%@%@", downloadString, "/")
            }
        }
        if let userInviteCode = UserModel.share().userInfo?.code {
            downString = String(format: "%@%@",downString, userInviteCode)
        } else {
            if let codeSave = UserDefaults.standard.object(forKey: UserDefaults.kUserInviteCode) as? String {
                downString = String(format: "%@%@", downString, codeSave)
            } else {
                downString = String(format: "%@", downString)
            }
        }
        return downString
    }
    
}

// MARK: - Layout
private extension ShareContentItemCell {
    func layoutPageSubviews() {
        layoutTitleLabel()
        layoutContentLabel()
        layoutImageContentButton()
        
    }
    func layoutTitleLabel() {
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(5)
            make.trailing.equalTo(-5)
            make.top.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    func layoutContentLabel() {
        contentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-25)
        }
    }
    func layoutImageContentButton() {
        let height: CGFloat = ShareContentItemCell.itemSize.height - 75
        imageButton.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(height)
            make.width.equalTo(height*3/4)
        }
    }
}
