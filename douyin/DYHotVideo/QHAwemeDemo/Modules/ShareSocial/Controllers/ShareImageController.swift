//
//  ShareImageController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/2.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import DouYinScan

class ShareImageController: QHBaseViewController {
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = ""
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    
    let cardView: ShareImageContentView = {
        guard let card = Bundle.main.loadNibNamed("ShareImageContentView", owner: nil, options: nil)?[0] as? ShareImageContentView else { return  ShareImageContentView() }
        return card
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(r: 0, g: 123, b: 255)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.setTitle("分 享", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor =  ConstValue.kViewLightColor
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.setTitle("保 存", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    var shareActivityHandler:(() -> Void)?
    
    var model: ShareTypeItemModel?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
         NotificationCenter.default.addObserver(self, selector: #selector(shareactivityDown), name: Notification.Name.kShareActivityDownNotification, object: nil)
        super.viewDidLoad()
        loadCard()
    }
   
    private func loadCard() {
        view.addSubview(navBar)
        view.addSubview(cardView)
        view.addSubview(saveButton)
        view.addSubview(shareButton)
        layoupageSubvies()
        let image = UIImage(named: "defaultShare\(arc4random()%3)")
        if let url = model?.imageUrl {
            cardView.topicImage.kfSetHeaderImageWithUrl(url, placeHolder: image)
        } else {
            cardView.topicImage.image = image
        }
        cardView.shareText.text = model?.content ?? ShareContentItemCell.getDefaultContentString()
        cardView.webLabel.text = ConstValue.kAppDownLoadLoadUrl
        loadQRcode()
        setUserInviteCode()
        
    }
    
    @objc private func buttonClick(_ sender: UIButton) {
        if sender == saveButton {
            if let image = cardView.toImage() {
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
                XSAlert.show(type: .success, text: "保存成功")
                self.dismiss(animated: false, completion: nil)
            }
        } else {
            if let image = cardView.toImage() {
                 self.share(image)
            }
        }
    }
    
    @objc private func shareactivityDown() {
        self.dismiss(animated: false, completion: nil)
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
        let qrImg = ScanWrapper.createCode(codeType: "CIQRCodeGenerator", codeString: downString, size: CGSize(width: 200, height: 200), qrColor: UIColor.black, bkColor: UIColor.white)
        //let logoImg = UIImage(named: "iconShare")
        cardView.inviteCodeImg.image = qrImg
       
    }
    
    func setUserInviteCode() {
        if let userInviteCode = UserModel.share().userInfo?.code {
            cardView.inviteCodeText.text = userInviteCode
        } else {
            if let codeSave = UserDefaults.standard.object(forKey: UserDefaults.kUserInviteCode) as? String {
                cardView.inviteCodeText.text = codeSave
            }
        }
    }
    
}

// MARK: - QHNavigationBarDelegate
extension ShareImageController:  QHNavigationBarDelegate  {
    
    func backAction() {
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: - Layout
private extension ShareImageController {
    func layoupageSubvies() {
        layoutNavBar()
        layoutCard()
        layoutSaveButton()
        layoutShareButton()
    }
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    func layoutShareButton() {
        shareButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-35)
            make.top.equalTo(cardView.snp.bottom).offset(35)
            make.leading.equalTo(self.view.snp.centerX).offset(10)
            make.height.equalTo(40)
        }
    }
    func layoutSaveButton() {
        saveButton.snp.makeConstraints { (make) in
            make.leading.equalTo(35)
            make.top.equalTo(cardView.snp.bottom).offset(35)
            make.trailing.equalTo(self.view.snp.centerX).offset(-10)
            make.height.equalTo(40)
        }
    }
    func layoutCard() {
        cardView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom).offset(20)
            make.width.equalTo(300)
            make.height.equalTo(450)
        }
    }
   
}
