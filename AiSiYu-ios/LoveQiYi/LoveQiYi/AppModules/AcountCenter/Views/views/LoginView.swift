//
//  LoginView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class LoginView: UIView {
   
    @IBOutlet weak var lineView2: UIView!
    @IBOutlet weak var lineView1: UIView!
    @IBOutlet weak var contryCode: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    var sendCodeActionHandler:(() ->Void)?
    var addPhoneActionHandler:(() -> Void)?
    
    lazy var codeBtn: CountDownButton = {
        let button = CountDownButton(frame: CGRect(x: 0, y: 0, width: 90, height: 35))
        button.layer.cornerRadius = 17.5
        button.layer.masksToBounds = true
        button.layer.borderColor = kAppDefaultTitleColor.cgColor
        button.layer.borderWidth = 0.8
        button.sendButton.setTitleColor(kAppDefaultTitleColor, for: .normal)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loginBtn.layer.cornerRadius = 22
        loginBtn.layer.masksToBounds = true
        loginBtn.clipsToBounds = false
        //字体颜色
        phoneNumber.setValue(UIColor.lightGray, forKeyPath: "_placeholderLabel.textColor")
        codeTF.setValue(UIColor.lightGray, forKeyPath: "_placeholderLabel.textColor")
        addSubview(codeBtn)
        codeBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(lineView2.snp.trailing)
            make.width.equalTo(90)
            make.height.equalTo(35)
            make.centerY.equalTo(codeTF)
        }
        
        codeBtn.sendCodeButtonClickHandler = { [weak self] in
            self?.sendCode()
        }

    }
    
    @IBAction func countryCodeBtnClick(_ sender: Any) {
    }
    
    @IBAction func loginBtnClick(_ sender: UIButton) {
        addPhoneActionHandler?()
    }
    
   
    
    func sendCode() {
        sendCodeActionHandler?()
    }
}
