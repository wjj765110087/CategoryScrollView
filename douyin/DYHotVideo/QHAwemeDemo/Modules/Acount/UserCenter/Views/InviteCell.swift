//
//  InviteCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class InviteCell: UITableViewCell {

     static let cellId = "InviteCell"
     static let cellHeight: CGFloat = 40.0
    
    private lazy var invitePeopelLab: UILabel = {
        let label = UILabel()
        label.text = "--人"
        label.textColor = UIColor.init(r: 34, g: 34, b: 34)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var dayCountLab: UILabel = {
       let label = UILabel()
        label.text = "--天"
        label.textColor = UIColor.init(r: 34, g: 34, b: 34)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(invitePeopelLab)
        contentView.addSubview(dayCountLab)
        layoutPageViews()
    }
    
    func setModel(model: InviteRuleModel) {
        invitePeopelLab.text = String(format: "%d人", model.person ?? 0)
        dayCountLab.text = String(format: "%d天", model.view_daily ?? 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -Layout
extension InviteCell {
    
    func layoutPageViews() {
        layoutInvitePeopelLab()
        layoutDayCountLabel()
    }
    
    func layoutInvitePeopelLab() {
        invitePeopelLab.snp.makeConstraints { (make) in
            make.leading.equalTo(60)
            make.centerY.equalToSuperview()
        }
    }
    
    func layoutDayCountLabel() {
        dayCountLab.snp.makeConstraints { (make) in
            make.trailing.equalTo(-60)
            make.centerY.equalToSuperview()
        }
    }
}
