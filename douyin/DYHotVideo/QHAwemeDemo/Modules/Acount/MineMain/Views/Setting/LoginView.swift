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
        let button = CountDownButton(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.layer.borderColor = ConstValue.kTitleYelloColor.cgColor
        button.layer.borderWidth = 1
        button.sendButton.setTitleColor(ConstValue.kTitleYelloColor, for: .normal)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lineView1.backgroundColor = ConstValue.kAppSepLineColor
        lineView2.backgroundColor = ConstValue.kAppSepLineColor
        loginBtn.layer.cornerRadius = 22
        loginBtn.layer.masksToBounds = true
        //字体颜色
        codeTF.setPlaceholderTextColor(placeholderText: "请输入验证码", color: UIColor.init(white: 0.9, alpha: 1.0))
        phoneNumber.setPlaceholderTextColor(placeholderText: "请输入手机号", color: UIColor.init(white: 0.9, alpha: 1.0))
        addSubview(codeBtn)
        codeBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(lineView2.snp.trailing)
            make.width.equalTo(90)
            make.height.equalTo(30)
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
