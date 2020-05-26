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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private lazy var photoBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("相册", for: .normal)
        button.setTitleColor(ConstValue.kTitleYelloColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(photoBtnClick(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = navTitle
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = ConstValue.kVcViewColor
        bar.delegate = self
        return bar
    }()
    var libraryClickHandler:(()-> Void)?
    var navTitle: String = "用身份卡找回"

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

// MARK: - QHNavigationBarDelegate
extension ScanIDQRCodeController:  QHNavigationBarDelegate  {
    
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
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
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
