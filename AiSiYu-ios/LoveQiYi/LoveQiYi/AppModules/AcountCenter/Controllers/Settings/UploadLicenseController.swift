//
//  UploadLicenseController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/5/10.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class UploadLicenseController: UIViewController {

    private lazy var navBar: CNavigationBar = {
        let bar = CNavigationBar()
        bar.titleLabel.text = isPay ? "充值说明" : "充值反馈说明"
        bar.titleLabel.textColor =  UIColor.white
        bar.backgroundColor = kBarColor
        bar.delegate = self
        return bar
    }()
    /// 是否是冠以我们
    var isPay: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(navBar)
        layoutNavBar()
        getUploadLicenseVc()
    }
    
    private func getUploadLicenseVc() {
        var urlHtm = ""
        if isPay {
            let resouce = Bundle.main.path(forResource: "pre_pay_detail", ofType: "html")
            urlHtm = String(format: "file://%@", resouce!)
        } else {
            let resouce = Bundle.main.path(forResource: "pre_pay_feedback", ofType: "html")
            urlHtm = String(format: "file://%@", resouce!)
        }
       
        let licenseVc = LicenseController()
        licenseVc.urlString = urlHtm
        self.addChild(licenseVc)
        view.addSubview(licenseVc.view)
        layoutLicenseView(licenseVc.view)
    }

}

// MARK: - QHNavigationBarDelegate
extension UploadLicenseController:  CNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Layout
private extension UploadLicenseController {
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(statusBarHeight + 44)
        }
    }
    
    func layoutLicenseView(_ view: UIView) {
        view.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
}
