//
//  UploadRankCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class UploadRankCell: UITableViewCell {

    static let cellId = "UploadRankCell"
    static let rowHeight: CGFloat = 85.0
    
    var headerImage: UIImageView = {
        let header = UIImageView()
        header.contentMode = .scaleAspectFill
        header.image = ConstValue.kDefaultHeader
        header.layer.cornerRadius = 27.5
        header.layer.masksToBounds = true
        header.clipsToBounds = true
        return header
    }()
    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 153, g: 153, b: 153)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    let uploadCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    let rankLabel: UILabel = {
        let label = UILabel()
        label.textColor = ConstValue.kTitleYelloColor
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(headerImage)
        contentView.addSubview(nickNameLabel)
        contentView.addSubview(uploadCountLabel)
        contentView.addSubview(rankLabel)
        laayoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(_ user: UserInfoModel) {
        headerImage.kfSetHeaderImageWithUrl(user.avatar, placeHolder: UserModel.share().getUserHeader(user.id))
        rankLabel.text = "TOP.\(user.top ?? 1)"
        nickNameLabel.text = "\(user.nikename ?? "老湿")"
        uploadCountLabel.text = "上传数量：\(user.count ?? 0)"
    }
    
}


// MARK: - Layout
private extension UploadRankCell {
    func laayoutPageSubviews() {
        layoutRankLabel()
        layoutHeaderView()
        layoutNameLabel()
        layoutUploadCountLabel()
    }
    
    func layoutHeaderView() {
        headerImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(12)
            make.height.width.equalTo(55)
        }
    }
    func layoutNameLabel() {
        nickNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(headerImage.snp.trailing).offset(18.5)
            make.top.equalTo(headerImage)
            make.height.equalTo(25)
        }
    }
    func layoutUploadCountLabel() {
        uploadCountLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nickNameLabel)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
    }
    func layoutRankLabel() {
        rankLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(-25)
            make.centerY.equalToSuperview()
        }
    }
}
