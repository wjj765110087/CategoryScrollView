//
//  UpdateAlert.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/15.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

/// 更新弹框
class UpdateAlert: UIView {

    @IBOutlet weak var alertContainView: UIView!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var updateInfo: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    
    @IBOutlet weak var webUpdateBtn: UIButton!
    
    
    var updateActionHandler:(() ->Void)?
    var closeActionHandler:(() ->Void)?
    var webUpdateActonhandler:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        alertContainView.layer.masksToBounds = false
        titleLable.text = AppInfo.share().appInfo?.version_code ?? ""
    }
    
    @IBAction func updateAction(_ sender: UIButton) {
        updateActionHandler?()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        closeActionHandler?()
    }
    
    @IBAction func webBtnClickHandler(_ sender: UIButton) {
        webUpdateActonhandler?()
    }
    
    
}
