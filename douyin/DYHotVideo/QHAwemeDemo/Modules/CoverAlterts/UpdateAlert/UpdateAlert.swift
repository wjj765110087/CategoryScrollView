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
    @IBOutlet weak var updateTitle: UILabel!
    @IBOutlet weak var EnglishTitle: UILabel!
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
        self.backgroundColor = UIColor.clear
        alertContainView.layer.cornerRadius = 10
        alertContainView.layer.masksToBounds = true
        webUpdateBtn.layer.cornerRadius = 20
        webUpdateBtn.layer.borderWidth = 1.0
        webUpdateBtn.layer.borderColor = UIColor(red: 0/255.0, green: 123/255.0, blue:255/255.0, alpha: 0.8).cgColor
        webUpdateBtn.layer.masksToBounds = true
        
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
