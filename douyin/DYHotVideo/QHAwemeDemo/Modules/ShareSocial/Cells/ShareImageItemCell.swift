//
//  ShareImageItemCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/11.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import DouYinScan

class ShareImageItemCell: UICollectionViewCell {
    
    static let cellId = "ShareImageItemCell"
    
    @IBOutlet weak var shareImage: UIImageView!
    
    @IBOutlet weak var ccontentLabel: UILabel!
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    @IBOutlet weak var inviteCode: UILabel!
    
    @IBOutlet weak var linkLabel: UILabel!
    
    @IBOutlet weak var playVideoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor =  ConstValue.kViewLightColor
        contentView.layer.cornerRadius = 9
        contentView.layer.masksToBounds = true
    }
    
    func setShareTypeModel(_ model: ShareTypeItemModel) {
        UserModel.share().shareText = model.content ?? ShareContentItemCell.getDefaultContentString()
        let image = UIImage(named: "defaultShare\(arc4random()%3)")
        if let url = model.imageUrl {
             shareImage.kfSetHeaderImageWithUrl(url, placeHolder: image)
        } else {
            shareImage.image = image
        }
        ccontentLabel.text = model.content ?? ShareContentItemCell.getDefaultContentString()
        linkLabel.text =  ConstValue.kAppDownLoadLoadUrl
        loadQRcode()
        setUserInviteCode()
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
        qrCodeImage.image = qrImg
        // ScanWrapper.addImageLogo(srcImg: qrImg!, logoImg: nil, logoSize: CGSize(width: 30, height: 30))
    }
    
    func setUserInviteCode() {
        if let userInviteCode = UserModel.share().userInfo?.code {
            inviteCode.text = userInviteCode
        } else {
            if let codeSave = UserDefaults.standard.object(forKey: UserDefaults.kUserInviteCode) as? String {
                inviteCode.text = codeSave
            }
        }
    }

}
