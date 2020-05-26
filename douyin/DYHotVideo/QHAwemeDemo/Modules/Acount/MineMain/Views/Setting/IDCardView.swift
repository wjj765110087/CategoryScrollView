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
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    @IBOutlet weak var tipsLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var webSite: UILabel!
    
    var actionHandler:((_ id: Int) ->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.containerView.layer.cornerRadius = 15
        self.containerView.layer.masksToBounds = true
        logalImage.layer.cornerRadius = 43.5
        logalImage.layer.masksToBounds = true
//        logalImage.layer.borderColor = UIColor.white.cgColor
//        logalImage.layer.borderWidth = 8
        saveButton.layer.cornerRadius = 22.5
        saveButton.layer.masksToBounds = true
        webSite.layer.cornerRadius = 15
        webSite.layer.masksToBounds = true
        setUpUI()
    }
    
    func setUpUI() {
        let userInfo = UserModel.share().userInfo
        nickNameLable.text = userInfo?.nikename ?? "老湿"
        userNameLabel.text = "邀请码: \(userInfo?.code ?? "--")"
        logalImage.kfSetHeaderImageWithUrl(userInfo?.cover_path, placeHolder: UIImage(named: "iconShare"))
        let uidSalt = "\(userInfo?.id ?? 0)\(userInfo?.salt ?? "")"
        if !uidSalt.isEmpty {
            createQRCode(uidSalt)
        }
        
        if let official_url = AppInfo.share().official_url, !official_url.isEmpty {
            webSite.text = "官网地址：\(official_url)"
            webSite.textColor = UIColor.init(r: 34, g: 34, b: 34, a: 1.0)
            webSite.textAlignment = .center
            webSite.backgroundColor = UIColor(white: 200/255.0, alpha: 1.0)
        }
    }

    @IBAction func saveImage(_ sender: UIButton) {
        let image = screenSnapshot(save: true)
        if  image != nil {
            let showMessage = "保存成功！"
            XSAlert.show(type: .success, text: showMessage)
            actionHandler?(0)
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
