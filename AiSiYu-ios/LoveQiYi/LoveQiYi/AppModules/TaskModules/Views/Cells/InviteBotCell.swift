//
//  InviteBotCell.swift
//  YellowBook
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class InviteBotCell: UITableViewCell {

    static let cellId = "InviteBotCell"
    
    private var footer: InvitedBotView = {
        guard let view = Bundle.main.loadNibNamed("InvitedBotView", owner: nil, options: nil)?[0] as? InvitedBotView else { return InvitedBotView() }
        view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 170)
        return view
    }()
    
    var cardActionHandler:(() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(footer)
        layoutFooter()
        footer.inviteCodeActionHandler = { [weak self]  in
            self?.cardActionHandler?()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutFooter() {
        footer.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
    }
    
}
