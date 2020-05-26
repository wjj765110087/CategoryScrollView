//
//  InviteRecordCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/14.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class InviteRecordCell: UITableViewCell {

   
    static let cellId = "InviteRecordCell"
    
    let userIdLab: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.textColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.text = "ID: User_Teacher"
        return lable
    }()
    let userNameLab: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.textColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.text = "老湿"
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
        contentView.addSubview(userIdLab)
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
        userIdLab.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo((ConstValue.kScreenWdith-100)/2)
        }
        userNameLab.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(userIdLab.snp.trailing)
            make.width.equalTo(100)
        }
        inviteTimeLab.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo((ConstValue.kScreenWdith-100)/2)
        }
    }
}
