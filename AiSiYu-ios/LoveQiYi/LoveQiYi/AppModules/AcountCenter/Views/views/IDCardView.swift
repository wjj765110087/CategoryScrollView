//
//  IDCardView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/17.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import DouYinScan


class IDCardView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logalImage: UIImageView!
    @IBOutlet weak var nickNameLable: UILabel!
    @IBOutlet weak var userIDCodeTitle: UILabel!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var webSiteLable: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var codeImgeTipsLab: UILabel!

    
    var cardType: Int = 0   /// 0 : 身份卡   1 ： 分享卡
    let viewModel = AcountViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.containerView.backgroundColor = UIColor.white
        self.containerView.layer.cornerRadius = 15
        containerView.addShadow(radius: 5, opacity: 1.0)
        logalImage.addShadow(radius: 5, opacity: 0.8)
        saveButton.backgroundColor = kAppDefaultTitleColor
        saveButton.addShadow(radius: 3, opacity: 0.8)
        webSiteLable.layer.cornerRadius = 15
        webSiteLable.layer.masksToBounds = true
    }
    
    func setUpIdCodeUI() {
        let userInfo = UserModel.share().userInfo
        nickNameLable.text = userInfo?.nick_name ?? "老湿"
        //userIDCode.text = userInfo?.code ?? ""
        let uidSalt = "\(userInfo?.id ?? "0")\(userInfo?.salt ?? "")"
        if !uidSalt.isEmpty {
            let idFake = "asyqra/\(uidSalt)"
            createQRCode(idFake.encodeWithXorByte(key: 101))
        }
        webSiteLable.text = "官网地址: \(AppInfo.share().appInfo?.official_url ?? ConstValue.kAppDownLoadLoadUrl)"
        logalImage.image = UserModel.share().getUserHeader()
        userIDCodeTitle.attributedText = TextSpaceManager.configColorString(allString: "邀请码: \(userInfo?.invite_code ?? "--")", attribStr: "\(userInfo?.invite_code ?? "--")")
        tipsLabel.text = "身份卡是个人专属身份标识,可用于账号找回，请提前保存至本地，切勿泄露与他人"
        codeImgeTipsLab.text = "扫码找回原账号"
        saveButton.setTitle("保存至相册", for: .normal)
        cardType = 0
    }
    
    func setInviteCodeUI() {
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
        createQRCode(downString)
        let userInfo = UserModel.share().userInfo
        nickNameLable.text = "我的邀请码"
        webSiteLable.text = "官网地址: \(AppInfo.share().appInfo?.official_url ?? downString)"
        logalImage.image = UserModel.share().getUserHeader()
        userIDCodeTitle.text = "\(userInfo?.invite_code ?? "--")"
        userIDCodeTitle.textColor = UIColor(r: 255, g: 42, b: 49)
        tipsLabel.text = "下载前请保存发布网址，可随时找到爱私欲"
        codeImgeTipsLab.text = "扫码下载爱私欲APP"
        saveButton.setTitle("保存并分享推广", for: .normal)
        cardType = 1
    }
    
    @IBAction func saveImage(_ sender: UIButton) {
        let image = screenSnapshot(save: true)
        if  image != nil {
            let showMessage = "保存成功！"
            XSAlert.show(type: .success, text: showMessage)
        }
        
        if cardType == 0 {
//            params = [TaskDoneApi.kEvent: TaskKey.saveCard.rawValue]
            let params = [String: Any]()
            viewModel.taskDone(params)
        } else if cardType == 1 {
            //params = [TaskDoneApi.kEvent: TaskKey.savePhoto.rawValue]
        }
        
    }
    
    func createQRCode(_ idString: String) {
        let qrImg = ScanWrapper.createCode(codeType: "CIQRCodeGenerator", codeString: idString, size: CGSize(width: 120, height: 120), qrColor: UIColor.black, bkColor: UIColor.white)
        qrCodeImage.image = qrImg
        //ScanWrapper.addImageLogo(srcImg: qrImg!, logoImg: logoImg!, logoSize: CGSize(width: 30, height: 30))
    }
    
    private func screenSnapshot(save: Bool) -> UIImage? {
        guard let window = UIApplication.shared.keyWindow else { return nil }
        // 用下面这行而不是UIGraphicsBeginImageContext()，因为前者支持Retina
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, 0.0)
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if save { UIImageWriteToSavedPhotosAlbum(image ?? qrCodeImage.image!, self, nil, nil) }
        return image
    }
}
