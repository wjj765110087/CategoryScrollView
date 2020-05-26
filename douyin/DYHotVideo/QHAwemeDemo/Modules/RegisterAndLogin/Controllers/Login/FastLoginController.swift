//
//  FastLoginController.swift
//  LanTest
//
//  Created by pro5 on 2018/12/24.
//  Copyright © 2018年 L. All rights reserved.
//

import UIKit
import SnapKit

class FastLoginController: UIViewController {

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "navBackWhite"), for: .normal)
        button.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        return button
    }()
    lazy var bgImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "loginBgImage")
        return image
    }()
    lazy var waveImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "loginBgWave")
        return image
    }()
    lazy var logolImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "loginLogal")
        return image
    }()
    lazy var phoneImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "phoneImage")
        image.contentMode = .scaleAspectFit
        return image
    }()
    lazy var countryCodeBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("+86", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(countryCodeButtonClick), for: .touchUpInside)
        return button
    }()
    lazy var pswImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "codeImage")
        image.contentMode = .scaleAspectFit
        return image
    }()
    lazy var phoneText: UITextField = {
        let txfild = UITextField()
        txfild.borderStyle = .none
        txfild.placeholder = localStr("kPleaceInputPhoneNum")
        txfild.keyboardType = .numberPad
        txfild.clearButtonMode = .whileEditing
        txfild.font = UIFont.systemFont(ofSize: 16)
        return txfild
    }()
    lazy var codeBtn: CountDownButton = {
        let button = CountDownButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()
    lazy var pswText: UITextField = {
        let txfild = UITextField()
        txfild.borderStyle = .none
        txfild.placeholder = localStr("kPleaceInputMsgCode")
        txfild.font = UIFont.systemFont(ofSize: 16)
        return txfild
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(localStr("kLoginTitle"), for: .normal)
        button.backgroundColor = ConstValue.kAppDefaultColor
        button.layer.cornerRadius = 22.5
        button.layer.masksToBounds = true
        // button.isEnabled = false
        button.addTarget(self, action: #selector(loginButtonClick), for: .touchUpInside)
        return button
    }()
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(localStr("kRegisterTitle"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.addTarget(self, action: #selector(goToRegister(_:)), for: .touchUpInside)
        return button
    }()
    lazy var forgetPswButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(localStr("kForgetPswAction"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(ConstValue.kAppDefaultTitleColor, for: .normal)
        button.addTarget(self, action: #selector(forgetPswClick), for: .touchUpInside)
        return button
    }()
    lazy var fastLoginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(localStr("kLoginTypePsw"), for: .normal)
        button.setTitleColor(ConstValue.kAppDefaultTitleColor, for: .normal)
        button.addTarget(self, action: #selector(pswLoginButtonClick), for: .touchUpInside)
        return button
    }()
    
    var loginButtonClickHandler:((_ params: [String: Any]) -> Void)?
    var pswLoginClickHandler:(() -> Void)?
    var sendCodeButtonClickHandler:((_ params:[String: Any])-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(pswImage)
        view.addSubview(pswText)
        view.addSubview(codeBtn)
        view.addSubview(phoneImage)
        view.addSubview(phoneText)
        view.addSubview(countryCodeBtn)
        view.addSubview(bgImage)
        view.addSubview(waveImage)
        view.addSubview(logolImage)
        view.addSubview(registerButton)
        view.addSubview(forgetPswButton)
        view.addSubview(loginButton)
        view.addSubview(fastLoginButton)
        view.addSubview(backButton)
        layoutPageSubviews()
        addSendCodeCallback()
        getSaveAcountMobil()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func addSendCodeCallback() {
        codeBtn.sendCodeButtonClickHandler = { [weak self] in
            var params = [String: Any]()
            if let phoneStr = self?.phoneText.text {
                let phone = phoneStr.removeAllSpace()
                params[SendCodeApi.kMobile] = phone
            }
            self?.sendCodeButtonClickHandler?(params)
        }
        
    }
    
    func getSaveAcountMobil() {
        if let mobile = UserDefaults.standard.object(forKey: UserDefaults.kUserAcountPhone) as? String {
            phoneText.text = mobile
        }
    }
    
}

// MARK: - User - Action
private extension FastLoginController {
    
    /// 地区编码选择
    @objc func countryCodeButtonClick() {
//        let vc = CountryCodeController()
//        vc.backCountryCode = { [weak self] country, code in
//            DLog("country = \(country) ==== code = \(code)")
//        }
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func backButtonClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func goToRegister(_ sender: UIButton) {
        let registerVC = RegisterController()
        navigationController?.pushViewController(registerVC, animated: true)
    }

    /// 登录
    @objc func loginButtonClick() {
        var params = [String: Any]()
        if let phoneStr = phoneText.text {
            let phone = phoneStr.removeAllSpace()
            if phone == nil || phone!.isEmpty {
                XSAlert.show(type: .warning, text: localStr("kPleaceInputPhoneNum"))
                return
            }
            if !phone!.isValidPhoneNumber() {
               XSAlert.show(type: .warning, text: localStr("kPleaceInputCorrectPhoneNum"))
                return
            }
            params[UserLoginApi.kMobile] = phone!
        }
       
        if let codeStr = pswText.text {
            let code = codeStr.removeAllSpace()
            if code == nil || code!.isEmpty {
                XSAlert.show(type: .warning, text: localStr("kPleaceInputMsgCode"))
                return
            }
            params[UserLoginApi.kCode] = code!
        }
        loginButtonClickHandler?(params)
    }
    
    /// 发送验证码
    @objc func codeBtnClick() {
        
    }
    
    /// 切换登录方式
    @objc func pswLoginButtonClick() {
        pswLoginClickHandler?()
    }
    
    /// 忘记密码
    @objc func forgetPswClick() {
       
    }
}

// MARK: - Layout
private extension FastLoginController {
    
    func layoutPageSubviews() {
        layoutPswItem()
        layoutPhoneItem()
        layoutBgImabges()
        layoutRegisterButton()
        layoutForgetButton()
        layoutLoginButton()
        layoutFastLoginButton()
        layoutBackButton()
    }
    func layoutPswItem() {
        pswImage.snp.makeConstraints { (make) in
            make.leading.equalTo(25)
            make.centerY.equalToSuperview().offset(-10)
            make.height.width.equalTo(20)
        }
        codeBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-40)
            make.centerY.equalTo(pswImage)
            make.height.equalTo(30)
            make.width.equalTo(90)
        }
        pswText.snp.makeConstraints { (make) in
            make.leading.equalTo(pswImage.snp.trailing).offset(15)
            make.centerY.equalTo(pswImage)
            make.height.equalTo(35)
            make.trailing.equalTo(codeBtn.snp.leading).offset(-10)
        }
        
    }
    
    func layoutPhoneItem() {
        phoneImage.snp.makeConstraints { (make) in
            make.leading.equalTo(pswImage)
            make.bottom.equalTo(pswImage.snp.top).offset(-50)
            make.width.height.equalTo(20)
        }
        countryCodeBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(pswText)
            make.centerY.equalTo(phoneImage)
            make.height.equalTo(30)
        }
        phoneText.snp.makeConstraints { (make) in
            make.leading.equalTo(countryCodeBtn.snp.trailing).offset(10)
            make.centerY.equalTo(countryCodeBtn)
            make.height.equalTo(35)
            make.trailing.equalTo(codeBtn)
        }
    }
    
    func layoutBgImabges() {
        bgImage.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(phoneText.snp.top).offset(-60)
            make.top.equalTo(-ConstValue.kStatusBarHeight)
        }
        waveImage.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgImage.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        logolImage.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgImage.snp.centerX)
            make.centerY.equalTo(bgImage.snp.centerY).offset(20)
            make.width.height.equalTo(80)
        }
    }
    
    func layoutRegisterButton() {
        registerButton.snp.makeConstraints { (make) in
            make.leading.equalTo(pswImage.snp.leading)
            make.top.equalTo(pswImage.snp.bottom).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(40)
        }
    }
    
    func layoutForgetButton() {
        forgetPswButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(codeBtn)
            make.top.equalTo(codeBtn.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
    }
    func layoutLoginButton() {
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(forgetPswButton.snp.bottom).offset(30)
            make.height.equalTo(45)
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
        }
    }
    
    func layoutFastLoginButton() {
        fastLoginButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginButton.snp.bottom).offset(15)
            make.height.equalTo(35)
            make.width.equalTo(100)
        }
    }
    
    func layoutBackButton() {
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(ConstValue.kStatusBarHeight + 5)
            make.leading.equalTo(15)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
    }
    
}
