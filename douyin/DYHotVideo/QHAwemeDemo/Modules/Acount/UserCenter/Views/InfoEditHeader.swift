//
//  InfoEditHeader.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/8/27.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class InfoEditHeader: UIView {
    
    lazy var headerBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ChartPicture"), for: .normal)
        btn.backgroundColor = UIColor(r: 56 , g: 59 , b: 71)
        btn.layer.cornerRadius = 52
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(updateHeaderAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var cameraBtn: UIButton = {
       let btn = UIButton(type: .custom)
       btn.setImage(UIImage(named: "camera"), for: .normal)
       btn.addTarget(self, action: #selector(updateHeaderAction), for: .touchUpInside)
       return btn
    }()

    let tipsTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "点击更换头像"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    var choosePictureAction:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerBtn)
        addSubview(cameraBtn)
        addSubview(tipsTitle)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func updateHeaderAction() {
        choosePictureAction?()
    }
    
    
}

// MARK: - Layout
private extension InfoEditHeader {
    func layoutPageSubviews() {
        layoutHeaderBtn()
        layoutCamaraBtn()
        layoutTipsLabel()
    }
    func layoutHeaderBtn() {
        headerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(104)
        }
    }
    func layoutCamaraBtn() {
        cameraBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(headerBtn.snp.centerY)
            make.width.equalTo(38)
            make.height.equalTo(31)
        }
    }
    
    func layoutTipsLabel() {
        tipsTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerBtn.snp.bottom).offset(10)
        }
    }
}
