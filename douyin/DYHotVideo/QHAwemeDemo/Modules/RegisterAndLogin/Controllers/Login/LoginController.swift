//
//  LoginController.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/17.
//  Copyright © 2018年 pro5. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    private lazy var pswLoginController: PswLoginController = {
        let vc = PswLoginController()
        return vc
    }()
    private lazy var fastLoginController: FastLoginController = {
        let vc = FastLoginController()
        return vc
    }()
    private lazy var rightBarButton: UIBarButtonItem = {
        let barItem = UIBarButtonItem(title: localStr("kRegisterTitle"), style: .plain, target: self, action: #selector(goToRegister(_:)))
        barItem.tintColor = UIColor.darkText
        return barItem
    }()
    private lazy var backBarButton: UIBarButtonItem = {
        let barItem = UIBarButtonItem.init(image: UIImage(named: "navBackDefault"), style: .plain, target: self, action: #selector(closeLoginController))
        return barItem
    }()
  
    var loginSuccessCallBack:(() ->Void)?
    var viewModel = RegisterLoginViewModel()
    let userInfo = UserInfoViewModel()
    var loginType = "P"
    var userAcount: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = localStr("kLoginTypePsw")
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.leftBarButtonItem = backBarButton
        addChild(fastLoginController)
        view.addSubview(fastLoginController.view)
        addChild(pswLoginController)
        view.addSubview(pswLoginController.view)
        layoutFastLoginView()
        layoutPswLoginView()
        addviewModelCallback()
        addLoginControllerCallBackHandler()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func addviewModelCallback() {
        viewModel.loadLoginApiSuccess = { [weak self] in
           self?.loadUserInfoData()
        }
        userInfo.loadUserInfoSuccessHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loginSuccessCallBack?()
            strongSelf.saveUserAcount()
            strongSelf.dismiss(animated: true, completion: nil)
        }
        userInfo.loadUserInfoFailHandler = { [weak self] in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
            XSAlert.show(type: .error, text: strongSelf.localStr("kLoginFailAlert"))
        }
        viewModel.loadLoginApiFail = { [weak self] (errorMsg) in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
            XSAlert.show(type: .error, text: errorMsg)
        }
        viewModel.loadSendCodeApiSuccess = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.fastLoginController.codeBtn.isCounting = true
            XSAlert.show(type: .success, text: strongSelf.localStr("kSendCodeSuccess"))
        }
        viewModel.loadSendCodeApiFail = { (errorMsg) in
            XSAlert.show(type: .error, text: errorMsg)
        }
    }
    
    func addLoginControllerCallBackHandler() {
        pswLoginController.loginButtonClickHandler = { [weak self] (params) in
            self?.login(params: params)
        }
        pswLoginController.fastLoginClickHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view.bringSubviewToFront(strongSelf.fastLoginController.view)
            strongSelf.title = strongSelf.localStr("kLoginTypeCode")
            strongSelf.loginType = "C"
        }
        
        fastLoginController.loginButtonClickHandler = { [weak self]  (params) in
            self?.login(params: params)
        }
        fastLoginController.pswLoginClickHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view.bringSubviewToFront(strongSelf.pswLoginController.view)
            strongSelf.title = strongSelf.localStr("kLoginTypePsw")
            strongSelf.loginType = "P"
        }
        fastLoginController.sendCodeButtonClickHandler = { [weak self]  (params) in
            self?.viewModel.sendCode(params)
        }
    }
    
    private func login(params: [String: Any]) {
        var paramers = params
        if let acount = params[UserLoginApi.kMobile] as? String {
            userAcount = acount
        }
        paramers[UserLoginApi.kType] = loginType
        paramers[UserLoginApi.kVerification_key] = viewModel.getCodeModel().verification_key ?? "123"
        XSProgressHUD.showProgress(msg: localStr("kLoginLoadingTitle"), onView: view, animated: false)
        viewModel.loginUser(paramers)
    }
    
    func loadUserInfoData() {
        userInfo.loadUserInfo()
    }
    
    func saveUserAcount() {
        UserDefaults.standard.set(userAcount, forKey: UserDefaults.kUserAcountPhone)
    }
    
    @objc func goToRegister(_ sender: UIBarButtonItem) {
        let registerVC = RegisterController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc func closeLoginController() {
        dismiss(animated: true, completion: nil)
    }
  
}

// MARK: - Layout
private extension LoginController {
    
    
    func layoutPswLoginView() {
        pswLoginController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func layoutFastLoginView() {
        fastLoginController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    
}
