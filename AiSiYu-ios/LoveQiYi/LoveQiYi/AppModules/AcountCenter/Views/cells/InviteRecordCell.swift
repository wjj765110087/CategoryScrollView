//
//  InviteRecordCell.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/25.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

class InviteRecordCell: UITableViewCell {

    static let cellId = "InviteRecordCell"
    let userNameLab: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.textColor = UIColor.darkText
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.text = "小黄"
        return lable
    }()
    let inviteTimeLab: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.textColor = UIColor.lightGray
        lable.numberOfLines = 2
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.text = "2019.12.09"
        return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        contentView.addSubview(userNameLab)
        contentView.addSubview(inviteTimeLab)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension InviteRecordCell {
    
    func layoutPageSubviews() {
        layoutLables()
    }
    
    func layoutLables() {
        userNameLab.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(screenWidth/2)
        }
        inviteTimeLab.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(screenWidth/2)
        }
    }
}
