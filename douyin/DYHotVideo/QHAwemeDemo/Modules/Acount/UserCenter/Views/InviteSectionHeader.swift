//
//  InviteSectionHeader.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class InviteSectionHeader: UITableViewHeaderFooterView {

    static let reuseId = "InviteSectionHeader"
    static let headerHeight: CGFloat = 70.0
    
    private lazy var invitePeopelLab: UILabel = {
        let label = UILabel()
        label.text = "邀请人数"
        label.textColor = UIColor.init(r: 34, g: 34, b: 34)
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var vipCountLab: UILabel = {
        let label = UILabel()
        label.text = "奖励VIP"
        label.textColor = UIColor.init(r: 34, g: 34, b: 34)
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        backgroundView = view
        contentView.backgroundColor = .white
        contentView.addSubview(invitePeopelLab)
        contentView.addSubview(vipCountLab)
        layoutPageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -Layout
extension InviteSectionHeader {
    
    func layoutPageView() {
        layoutInvitePeopelLab()
        layoutVipCountLab()
    }
    
    func layoutInvitePeopelLab() {
        invitePeopelLab.snp.makeConstraints { (make) in
            make.leading.equalTo(50)
            make.centerY.equalToSuperview()
        }
    }
    
    func layoutVipCountLab() {
        vipCountLab.snp.makeConstraints { (make) in
            make.trailing.equalTo(-50)
            make.centerY.equalToSuperview()
        }
    }
}
