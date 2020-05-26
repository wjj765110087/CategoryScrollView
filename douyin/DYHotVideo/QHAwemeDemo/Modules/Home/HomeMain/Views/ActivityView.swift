//
//  ActivityView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/9/18.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  首页的活动view

import UIKit

class ActivityView: UIView {

    private lazy var activityButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didClickActivityButton), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    var activityHandler: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(activityButton)
        layoutPageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///活动按钮点击事件
    @objc func didClickActivityButton() {
        activityHandler?()
    }
    
    func setActivityModel(_ model: ActivityModel) {
        activityButton.kfSetHeaderImageWithUrl(model.icon, placeHolder: nil)
    }
}


//MARK: -Layout
private extension ActivityView {
    
    func layoutPageView() {
        layoutActivityButton()
    }
    
    func layoutActivityButton() {
        activityButton.snp.makeConstraints { (make) in
           make.edges.equalToSuperview()
        }
    }
}
