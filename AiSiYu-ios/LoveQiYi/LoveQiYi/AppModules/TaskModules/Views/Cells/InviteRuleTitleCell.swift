//
//  InviteRuleTitleCell.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/18.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import UIKit

class InviteRuleTitleCell: UITableViewCell {
    
    static let cellId = "InviteRuleTitleCell"
    
    let titleLab: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.darkText
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "邀请好友，免费畅看"
        return label
    }()
    
    let tipsLab: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "邀请人数越多，奖励越大，邀请满5人永久免费畅看"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLab)
        contentView.addSubview(tipsLab)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Layout
private extension InviteRuleTitleCell {
    
    func layoutPageSubviews() {
        layoutTitleLabel()
        layoutTipLabel()
    }
    func layoutTitleLabel() {
        titleLab.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(10)
            make.height.equalTo(20)
        }
    }
    func layoutTipLabel() {
        tipsLab.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleLab)
            make.top.equalTo(titleLab.snp.bottom).offset(5)
            make.bottom.equalTo(-5)
        }
    }
}
