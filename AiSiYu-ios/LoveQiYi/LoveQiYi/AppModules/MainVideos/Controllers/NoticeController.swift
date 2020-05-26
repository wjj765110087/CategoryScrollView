//
//  NoticeController.swift
//  YellowBook
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class NoticeController: BaseViewController {

    private let lab: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(navBar.snp.bottom).offset(20)
        }
        view.bringSubviewToFront(navBar)
        navBar.titleLabel.text = "系统公告"
        
        let ss = SystemMsg.share()
        
        if ss.systemMsgs != nil && ss.systemMsgs!.count > 0 {
            let noticeMsg = ss.systemMsgs![0].msg ?? ""
            lab.attributedText = TextSpaceManager.getAttributeStringWithString(noticeMsg, lineSpace: 6)
        } else {
            let notice = "欢迎来到爱私欲,新用户登陆送3天免费无限天数。"
            lab.attributedText = TextSpaceManager.getAttributeStringWithString(notice, lineSpace: 6)
        }
    }
    
}
