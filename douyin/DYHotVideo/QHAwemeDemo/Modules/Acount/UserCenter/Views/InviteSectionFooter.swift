//
//  InviteSectionFooter.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import DouYinScan

class InviteSectionFooter: UIView {

    static let reuseId = "InviteSectionFooter"
    static let footerHeight: CGFloat = 784
    
    private lazy var shareContentView: UIView = {
       let view = UIView()
       view.backgroundColor = UIColor.init(r: 254, g: 250, b: 238)
       return view
    }()
    
    private lazy var QRCodeImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var myInviteLab: UILabel = {
       let label = UILabel()
       label.text = "我的邀请码"
       label.textColor = UIColor.init(r: 34, g: 34, b: 34)
       label.font = UIFont.systemFont(ofSize: 16)
       return label
    }()
    
    private lazy var inviteCodeLab: UILabel = {
        let label = UILabel()
        label.text = "--------"
        label.textColor = UIColor.init(r: 215, g: 58, b: 45)
        label.font = UIFont.systemFont(ofSize: 29)
        return label
    }()
    
    private lazy var indicatorButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "inviteIndicator"), for: .normal)
       
        return button
    }()
    
    private lazy var eventButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.tag = 102
        button.addTarget(self, action: #selector(buttonDidClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var urlShareBtn: UIButton = {
        let button = UIButton()
        button.setTitle("复制链接分享", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(UIColor.init(r: 0, g: 123, b: 255), for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.tag = 100
        button.addTarget(self, action: #selector(buttonDidClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageShareBtn: UIButton = {
        let button = UIButton()
        button.setTitle("保存图片分享", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(UIColor.init(r: 215, g: 58, b: 45), for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.tag = 101
        button.addTarget(self, action: #selector(buttonDidClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "inviteRewardIntro")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var buttonClickHandler: ((_ tag: Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        addSubview(shareContentView)
        shareContentView.addSubview(QRCodeImageView)
        shareContentView.addSubview(myInviteLab)
        shareContentView.addSubview(inviteCodeLab)
        shareContentView.addSubview(indicatorButton)
        shareContentView.addSubview(eventButton)
        addSubview(urlShareBtn)
        addSubview(imageShareBtn)
        addSubview(iconImageView)
        layoutPageViews()
        loadQRcode()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        if let userInviteCode = UserModel.share().userInfo?.code {
            inviteCodeLab.text = userInviteCode
        } else {
            if let codeSave = UserDefaults.standard.object(forKey: UserDefaults.kUserInviteCode) as? String {
                inviteCodeLab.text = codeSave
            }
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
    
    

}

//MARK: -Event
extension InviteSectionFooter {
    
    @objc func buttonDidClick(sender: UIButton) {
        buttonClickHandler?(sender.tag)
    }
}

//MARK: -Layout
extension InviteSectionFooter {
    
    func layoutPageViews() {
        layoutShareContentView()
        layoutQRCodeImageView()
        layoutMyInviteLab()
        layoutInviteCodeLab()
        layoutInviteIndicatorButton()
        layoutEventButton()
        layoutUrlShareBtn()
        layoutImageShareBtn()
        layoutIconImageView()
    }
    
    func layoutShareContentView() {
        shareContentView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalToSuperview()
            make.height.equalTo(104)
        }
    }
    
    func layoutQRCodeImageView() {
        QRCodeImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.top.equalTo(9)
            make.width.height.equalTo(84)
        }
    }
    
    func layoutMyInviteLab() {
        myInviteLab.snp.makeConstraints { (make) in
            make.leading.equalTo(QRCodeImageView.snp.trailing).offset(22)
            make.top.equalTo(25)
        }
    }
    
    func layoutInviteCodeLab() {
        inviteCodeLab.snp.makeConstraints { (make) in
            make.leading.equalTo(QRCodeImageView.snp.trailing).offset(22)
            make.top.equalTo(myInviteLab.snp.bottom).offset(15)
        }
    }
    
    func layoutInviteIndicatorButton() {
        indicatorButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-15)
            make.centerY.equalTo(QRCodeImageView.snp.centerY)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
    }
    
    func layoutEventButton() {
        eventButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func layoutUrlShareBtn() {
        urlShareBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.width.equalTo((screenWidth-56)/2)
            make.height.equalTo(56)
            make.top.equalTo(QRCodeImageView.snp.bottom).offset(34)
        }
    }
    
    func layoutImageShareBtn() {
        imageShareBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(0)
            make.width.equalTo(urlShareBtn.snp.width)
            make.height.equalTo(urlShareBtn.snp.height)
            make.top.equalTo(QRCodeImageView.snp.bottom).offset(34)
        }
    }
    
    func layoutIconImageView() {
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(imageShareBtn.snp.bottom).offset(30)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(572)
        }
    }
}
