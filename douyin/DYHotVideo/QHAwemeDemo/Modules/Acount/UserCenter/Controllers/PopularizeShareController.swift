//
//  PopularizeShareController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import DouYinScan

class PopularizeShareController: UIViewController {
    
    private lazy var backgroundImage: UIImageView = {
       let imageView = UIImageView()
       imageView.image = UIImage(named: "inviteBackground")
       return imageView
    }()
    
    private lazy var popularizeContentView: UIView = {
       let view = UIView()
       view.backgroundColor = UIColor.init(r: 215, g: 58, b: 45)
       view.layer.cornerRadius = 5
       view.layer.masksToBounds = true
       return view
    }()
    
    private lazy var iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appInvite")
        return imageView
    }()
    
    private lazy var titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "inviteText")
        return imageView
    }()
    
    private lazy var QRCodeImageView: UIImageView = {
       let imageView = UIImageView()
       return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImage)
        view.addSubview(popularizeContentView)
        popularizeContentView.addSubview(iconImage)
        popularizeContentView.addSubview(titleImage)
        popularizeContentView.addSubview(QRCodeImageView)
        layoutPageViews()
        loadQRcode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let image = self.view.toImage() {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            XSProgressHUD.showSuccess(msg: "将相册中的图片分享给好友即可", onView: view, animated: true)
        }
    }
    
    func loadQRcode() {
        var downString = String(format: "%@", ConstValue.kAppDownLoadLoadUrl)
        if let downloadString = AppInfo.share().share_url {
            if downloadString.hasSuffix("/") {
                downString = downloadString
            } else {
                downString = String(format: "%@%@", downloadString, "/")
            }
        }
        if let userInviteCode = UserModel.share().userInfo?.code {
            downString = String(format: "%@%@",downString, userInviteCode)
        } else {
            if let codeSave = UserDefaults.standard.object(forKey: UserDefaults.kUserInviteCode) as? String {
                downString = String(format: "%@%@", downString, codeSave)
            } else {
                downString = String(format: "%@", downString)
            }
        }
        let qrImg = ScanWrapper.createCode(codeType: "CIQRCodeGenerator", codeString: downString, size: CGSize(width: 200, height: 200), qrColor: UIColor.black, bkColor: UIColor.clear)
        QRCodeImageView.image = qrImg
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: -Layout
extension PopularizeShareController {
    
    func layoutPageViews() {
        layoutBackgroundImage()
        layoutPopularizeContentView()
        layoutIconImageView()
        layoutTitleImage()
        layoutQRCodeImageView()
    }
    
    func layoutBackgroundImage() {
        backgroundImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func layoutPopularizeContentView() {
        popularizeContentView.snp.makeConstraints { (make) in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.height.equalTo(86.5)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-26.5)
            } else {
                make.bottom.equalTo(-26.5)
            }
        }
    }
    
    func layoutIconImageView() {
        iconImage.snp.makeConstraints { (make) in
            make.leading.equalTo(popularizeContentView.snp.leading).offset(19)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(64)
        }
    }
    
    func layoutTitleImage() {
        titleImage.snp.makeConstraints { (make) in
            make.leading.equalTo(iconImage.snp.trailing).offset(12)
            make.width.equalTo(107)
            make.height.equalTo(41)
            make.centerY.equalToSuperview()
        }
    }
    
    func layoutQRCodeImageView() {
        QRCodeImageView.snp.makeConstraints { (make) in
            make.trailing.equalTo(popularizeContentView.snp.trailing).offset(-18)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(64)
        }
    }
}

//MARK: -QHNavigationBarDelegate
extension PopularizeShareController: QHNavigationBarDelegate {
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
