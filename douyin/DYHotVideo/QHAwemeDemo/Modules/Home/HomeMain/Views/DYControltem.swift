//
//  DYControltem.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/2.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class DYControltem: UIView {

    lazy var iconButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget( self, action: #selector(itemButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    var msgLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.textAlignment = .center
        return lable
    }()
    
    var title: String = "" {
        didSet {
            msgLable.text = title
        }
    }
    var iconImage: String = ""  {
        didSet {
            iconButton.setImage(UIImage(named: iconImage), for: .normal)
        }
    }
    
    var itemClickHandle:((_ button: UIButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = UIColor.yellow
        addSubview(iconButton)
        addSubview(msgLable)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func itemButtonClick(_ sender: UIButton) {
        itemClickHandle?(sender)
    }
    
    
}

// MARK: - Layout
private extension DYControltem {
    
    func layoutPageSubviews() {
        layoutIconButton()
        layoutTitleLable()
    }
    
    func layoutIconButton() {
        iconButton.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
    }
    
    func layoutTitleLable() {
        msgLable.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconButton.snp.bottom).offset(-3.5)
            make.height.equalTo(20)
            make.width.equalTo(60)
        }
    }
    
}
