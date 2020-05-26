//
//  ShareImageContentView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/2.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import DouYinScan

class ShareImageContentView: UIView {
    @IBOutlet weak var topicImage: UIImageView!
    @IBOutlet weak var shareText: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var webLabel: UILabel!
    @IBOutlet weak var inviteCodeText: UILabel!
    @IBOutlet weak var inviteCodeImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(r: 44, g: 40, b: 60)
        self.layer.masksToBounds = true
        inviteCodeText.layer.masksToBounds = true
        setUserInviteCode()
        loadQRcode()
        setCardInfo()
    }
    
    func setCardInfo() {
        tipsLabel.text = "抖阴分享性福生活"
        webLabel.text = AppInfo.share().official_url ?? ConstValue.kAppDownLoadLoadUrl
        shareText.text = UserModel.share().shareText
    }
   
    
}

private extension ShareImageContentView {
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
        inviteCodeImg.image = qrImg
           // ScanWrapper.addImageLogo(srcImg: qrImg!, logoImg: nil, logoSize: CGSize(width: 30, height: 30))
    }
    
    func setUserInviteCode() {
        if let userInviteCode = UserModel.share().userInfo?.code {
            inviteCodeText.text = userInviteCode
        } else {
            if let codeSave = UserDefaults.standard.object(forKey: UserDefaults.kUserInviteCode) as? String {
                inviteCodeText.text = codeSave
            }
        }
    }
}
