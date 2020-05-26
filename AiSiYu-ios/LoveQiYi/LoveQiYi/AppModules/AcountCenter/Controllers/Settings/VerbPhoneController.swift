//
//  VerbPhoneController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class VerbPhoneController: UIViewController {
    
    
    private lazy var navBar: CNavigationBar = {
        let bar = CNavigationBar()
        bar.titleLabel.text = "绑定手机号"
        bar.backgroundColor = kBarColor
        bar.lineView.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    private let helloLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.darkText
        lable.font = UIFont.systemFont(ofSize: 25)
        lable.text = "Hello ～ 爱私欲"
        return lable
    }()
    private lazy var loginView: LoginView = {
        guard let login = Bundle.main.loadNibNamed("LoginView", owner: nil, options: nil)?[0] as? LoginView else { return LoginView() }
        login.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 350)
        return login
    }()
    private let registerViewModel = CommonViewModel()
    var verbPhoneSuccessCallback:(() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(navBar)
        view.addSubview(helloLable)
        view.addSubview(loginView)
        layoutPageSubviews()
        addViewModelCallBackHandler()
        addloginViewActionHandler()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func addloginViewActionHandler() {
        loginView.sendCodeActionHandler = { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.loginView.phoneNumber.text != nil && !strongSelf.loginView.phoneNumber.text!.isEmpty {
                strongSelf.sendCode()
            } else {
                XSAlert.show(type: .error, text: "请输入手机号码。")
            }
        }
        
        loginView.addPhoneActionHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.addPhoneNumber()
        }
    }
    
    private func addViewModelCallBackHandler() {
        registerViewModel.loadSendCodeApiSuccess = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loginView.codeBtn.isCounting = true
        }
        registerViewModel.loadSendCodeApiFail = { (msg) in
            XSAlert.show(type: .error, text: msg)
        }
        registerViewModel.loadRegisterApiSuccess = { [weak self] in
            XSAlert.show(type: .success, text: "绑定成功。")
            UserModel.share().userInfo?.mobile = self?.loginView.phoneNumber.text ?? ""
            NotificationCenter.default.post(name: Notification.Name.kLoadTaskListNotification, object: nil)
            self?.navigationController?.popViewController(animated: true)
        }
        registerViewModel.loadRegisterApiFail = { (msg) in
             XSAlert.show(type: .error, text: msg)
        }
    }
    
    private func sendCode() {
        registerViewModel.sendCode([SendCodeApi.kMobile: loginView.phoneNumber.text!])
    }
    
    private func addPhoneNumber() {
        if loginView.phoneNumber.text == nil {
            XSAlert.show(type: .error, text: "请输入手机号。")
            return
        }
        if loginView.phoneNumber.text!.isEmpty {
            XSAlert.show(type: .error, text: "请输入手机号。")
            return
        }
        if loginView.codeTF.text != nil && !loginView.codeTF.text!.isEmpty {
            let params = [UserRegisterApi.kMobile: loginView.phoneNumber.text ?? "", UserRegisterApi.kCode: loginView.codeTF.text!, UserRegisterApi.kVerification_key: registerViewModel.codeModel?.verification_key ?? "123"]
            registerViewModel.reginsterUser(params)
        } else {
            XSAlert.show(type: .error, text: "请输入验证码。")
        }
    }
}

// MARK: - CNavigationBarDelegate
extension VerbPhoneController:  CNavigationBarDelegate  {
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Layout
private extension VerbPhoneController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutHelloLable()
        layoutLoginView()
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(statusBarHeight + 44)
        }
    }
    
    func layoutHelloLable() {
        helloLable.snp.makeConstraints { (make) in
            make.leading.equalTo(30)
            make.top.equalTo(navBar.snp.bottom).offset(50)
            make.height.equalTo(30)
        }
    }
    
    func layoutLoginView() {
        loginView.snp.makeConstraints { (make) in
            make.top.equalTo(helloLable.snp.bottom).offset(40)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(350)
        }
    }
    
}
