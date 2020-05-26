//
//  UploadLicenseController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/5/10.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

enum WebType: Int {
    case typeUpload = 0
    case typeFenxiao = 1
    case typePayExplain = 2
    case typeWebUrl = 3
}

class UploadLicenseController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "抖阴成人小视频上传须知"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    
    var webType: WebType = WebType.typeUpload
    var webUrlString: String?
    var navTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(navBar)
        layoutNavBar()
        getUploadLicenseVc()
    }
    
    private func getUploadLicenseVc() {
        let licenseVc = LicenseController()
        if webType == .typeUpload {  // 上传
            navBar.titleLabel.text = "抖阴成人小视频上传须知"
            let resouce = Bundle.main.path(forResource: "regulation", ofType: "html")
            let urlstr = String(format: "file://%@", resouce!)
            licenseVc.urlString = urlstr
        } else if webType == .typeFenxiao {
            navBar.titleLabel.text = "抖阴赚钱"
            if let urlstr = AppInfo.share().wallet_url {
                licenseVc.urlString = urlstr
            }
        } else if webType == .typePayExplain {
            navBar.titleLabel.text = "支付说明"
            let resouce = Bundle.main.path(forResource: "pre_pay_feedback", ofType: "html")
            let urlHtm = String(format: "file://%@", resouce!)
            licenseVc.urlString = urlHtm
        } else if webType == .typeWebUrl {
            navBar.titleLabel.text = navTitle
            if let url = webUrlString {
                licenseVc.urlString = url
            }
        }
        self.addChild(licenseVc)
        view.addSubview(licenseVc.view)
        layoutLicenseView(licenseVc.view)
    }

}

// MARK: - QHNavigationBarDelegate
extension UploadLicenseController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Layout
private extension UploadLicenseController {
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
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
