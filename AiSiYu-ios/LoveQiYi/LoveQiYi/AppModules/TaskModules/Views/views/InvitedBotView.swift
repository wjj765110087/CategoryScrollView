//
//  InvitedBotView.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/5/30.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit
import DouYinScan

class InvitedBotView: UIView {

    @IBOutlet weak var fakeBtn: UIButton!
    @IBOutlet weak var inviteCodeLab: UILabel!
    @IBOutlet weak var saveCodeBtn: UIButton!
    @IBOutlet weak var qrCodeImg: UIImageView!
    @IBOutlet weak var copyLinkBtn: UIButton!
    
    var codeImage: UIImage?
    var inviteCodeActionHandler:(() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.addShadow(radius: 5, opacity: 0.3)
        copyLinkBtn.addShadow(radius: 3, opacity: 0.6)
        saveCodeBtn.addShadow(radius: 3, opacity: 0.6)
        copyLinkBtn.addShadow(radius: 3, opacity: 0.6)
        loadQRcode()
        inviteCodeLab.text = UserModel.share().userInfo?.invite_code ?? ""
    }
    
    @IBAction func action(_ sender: UIButton) {
        if sender.tag == 2 {
            inviteCodeActionHandler?()
        } else if sender.tag == 3 {
            inviteFriends()
        } else if sender.tag == 1 {
            inviteCodeActionHandler?()
        }
    }
    
    /// 复制邀请链接
    func inviteFriends() {
        var downString = ConstValue.kAppDownLoadLoadUrl
        if let downloadString = AppInfo.share().appInfo?.share_url {
            if downloadString.hasSuffix("/") {
                downString = downloadString
            } else {
                downString = String(format: "%@%@", downloadString, "/")
            }
        }
        if let userInviteCode = UserModel.share().userInfo?.invite_code {
            downString = String(format: "%@%@",downString, userInviteCode)
        } else {
            if let codeSave = UserDefaults.standard.object(forKey: UserDefaults.kUserInviteCode) as? String {
                downString = String(format: "%@%@", downString, codeSave)
            } else {
                downString = String(format: "%@", downString)
            }
        }
        var textShare = "小黄书"
        if let textToShare = AppInfo.share().appInfo?.share_text {
            if textToShare.contains("{{share_url}}") {
                textShare = textToShare.replacingOccurrences(of: "{{share_url}}", with: downString)
            }
        }
        UIPasteboard.general.string = String(format: "%@", textShare)
        XSAlert.show(type: .success, text: "复制成功！")
    }
    
    /// 保存二维码
    func screenSnapshot(save: Bool) -> UIImage? {
        guard let window = UIApplication.shared.keyWindow else { return nil }
        // 用下面这行而不是UIGraphicsBeginImageContext()，因为前者支持Retina
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, 0.0)
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if save { UIImageWriteToSavedPhotosAlbum(image ?? UIImage() , self, nil, nil) }
        return image
    }
    
    /// 生成二维码
    private func loadQRcode() {
        var downString = String(format: "%@", ConstValue.kAppDownLoadLoadUrl)
        if let downloadString = AppInfo.share().appInfo?.share_url {
            if downloadString.hasSuffix("/") {
                downString = downloadString
            } else {
                downString = String(format: "%@%@", downloadString, "/")
            }
        }
        if let userInviteCode = UserModel.share().userInfo?.invite_code {
            downString = String(format: "%@%@",downString, userInviteCode)
        } else {
            if let codeSave = UserDefaults.standard.object(forKey: UserDefaults.kUserInviteCode) as? String {
                downString = String(format: "%@%@", downString, codeSave)
            } else {
                downString = String(format: "%@", downString)
            }
        }
        let qrImg = ScanWrapper.createCode(codeType: "CIQRCodeGenerator", codeString: downString, size: CGSize(width: 200, height: 200), qrColor: UIColor.black, bkColor: UIColor.clear)
        qrCodeImg.image = qrImg
        codeImage = qrImg
    }
}
