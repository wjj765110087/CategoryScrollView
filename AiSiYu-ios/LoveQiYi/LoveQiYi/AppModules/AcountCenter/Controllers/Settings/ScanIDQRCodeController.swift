//
//  ScanIDQRCodeController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/17.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import DouYinScan

class ScanIDQRCodeController: ScanViewController {
    
    private lazy var photoBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("相册", for: .normal)
        button.setTitleColor(kAppDefaultTitleColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(photoBtnClick(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var navBar: CNavigationBar = {
        let bar = CNavigationBar()
        bar.titleLabel.text = "用身份卡找回"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = kBarColor
        bar.lineView.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    var libraryClickHandler:(()-> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(navBar)
        navBar.navBarView.addSubview(photoBtn)
        layoutPageSubviews()
    }
    
    @objc func photoBtnClick(_ sender: UIButton) {
        libraryClickHandler?()
        navigationController?.popViewController(animated: false)
    }
    

}

// MARK: - CNavigationBarDelegate
extension ScanIDQRCodeController:  CNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}


private extension ScanIDQRCodeController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutPhotoBtn()
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(statusBarHeight + 44)
        }
    }
    
    func layoutPhotoBtn() {
        photoBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-12)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
    }

}
