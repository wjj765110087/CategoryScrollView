//
//  PhoneFindAcountController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/3.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class PhoneFindAcountController: UIViewController {

    private lazy var navBar: CNavigationBar = {
        let bar = CNavigationBar()
        bar.titleLabel.text = "账号找回"
        bar.backgroundColor = kBarColor
        bar.lineView.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    private let helloLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.darkText
        lable.font = UIFont.systemFont(ofSize: 25)
        lable.text = "手机号码找回账号"
        return lable
    }()
    private lazy var loginView: LoginView = {
        guard let login = Bundle.main.loadNibNamed("LoginView", owner: nil, options: nil)?[0] as? LoginView else { return LoginView() }
        login.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 350)
        return login
    }()
    private let registerViewModel = CommonViewModel()
    private let userViewModel = AcountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        loginView.loginBtn.setTitle("立即找回", for: .normal)
        view.addSubview(navBar)
        view.addSubview(helloLable)
        view.addSubview(loginView)
        layoutPageSubviews()
        addViewModelCallBackHandler()
        addloginViewActionHandler()
        loginView.loginBtn.setTitle("立即找回", for: .normal)
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
        
        userViewModel.loadUserFindBackSuccessHandler = { [weak self] in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
            UserModel.share().userInfo?.mobile = strongSelf.loginView.phoneNumber.text ?? ""
            strongSelf.showAlert(true, errorMsg: nil)
        }
        userViewModel.loadUserFindBackFailHandler = { [weak self] (msg) in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
            strongSelf.showAlert(false, errorMsg: msg)
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
            XSProgressHUD.showCustomAnimation(msg: nil, onView: self.view, imageNames: nil, bgColor: UIColor.clear, animated: false)
            let params = [AcountBackWithPhoneApi.kMobile: loginView.phoneNumber.text ?? "", AcountBackWithPhoneApi.kCode: loginView.codeTF.text!, AcountBackWithPhoneApi.kDevice_code: UIDevice.current.getIdfv(), AcountBackWithPhoneApi.kVerification_key: registerViewModel.codeModel?.verification_key ?? "123"]
            userViewModel.findAcountBack(params)
        } else {
            XSAlert.show(type: .error, text: "请输入验证码。")
        }
    }
    
    private func showAlert(_ success: Bool, errorMsg: String?) {
        let succeedModel = ConvertCardAlertModel.init(title: "恭喜找回成功", msgInfo: "您的账号信息已恢复", success: true)
        let failedModel = ConvertCardAlertModel.init(title: "很遗憾找回失败", msgInfo: errorMsg ?? "请稍后再试", success: false)
        let controller = AlertManagerController(alertInfoModel: success ? succeedModel : failedModel)
        controller.modalPresentationStyle = .overCurrentContext
        controller.view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        controller.commitActionHandler = { [weak self] in
            if success {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        self.modalPresentationStyle = .currentContext
        self.present(controller, animated: true, completion: nil)
    }
    
    
}

// MARK: - CNavigationBarDelegate
extension PhoneFindAcountController:  CNavigationBarDelegate  {
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Layout
private extension PhoneFindAcountController {
    
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
