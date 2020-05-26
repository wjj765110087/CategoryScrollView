//
//  CodeController.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/24.
//  Copyright © 2018年 pro5. All rights reserved.
//

import UIKit

class CodeController: UIViewController {

  
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "wkkkkk"
        bar.backgroundColor = UIColor.groupTableViewBackground
        bar.delegate = self
        return bar
    }()
    lazy var tipsLable: UILabel = {
        let lable = UILabel()
        lable.textColor = ConstValue.kAppDefaultTitleColor
        lable.text = localStr("kClickToGetMsgCode")
        return lable
    }()
    lazy var phoneLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.darkText
        lable.textAlignment = .center
        lable.text = "+86 --"
        return lable
    }()
    lazy var codeImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "codeImage")
        image.contentMode = .scaleAspectFit
        return image
    }()
    lazy var codeText: UITextField = {
        let txfild = UITextField()
        txfild.borderStyle = .none
        txfild.placeholder = localStr("kPleaceInputMsgCode")
        txfild.font = UIFont.systemFont(ofSize: 16)
        return txfild
    }()
    lazy var codeBtn: CountDownButton = {
        let button = CountDownButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        return button
    }()
    lazy var pswImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "pswImage")
        image.contentMode = .scaleAspectFit
        return image
    }()
    lazy var pswText: UITextField = {
        let txfild = UITextField()
        txfild.borderStyle = .none
        txfild.placeholder = localStr("kSetPswPlaceHolder")
        txfild.isSecureTextEntry = true
        txfild.font = UIFont.systemFont(ofSize: 16)
        return txfild
    }()
    lazy var seePswBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "pswSeeBtn"), for: .normal)
        button.setImage(UIImage(named: "noSeePsw"), for: .selected)
        button.addTarget(self, action: #selector(showPswText(_:)), for: .touchUpInside)
        return button
    }()
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(localStr("kRegisterTitle"), for: .normal)
        button.backgroundColor = ConstValue.kAppDefaultColor
        button.layer.cornerRadius = 22.5
        button.layer.masksToBounds = true
        // button.isEnabled = false
        button.addTarget(self, action: #selector(registerButtonClick), for: .touchUpInside)
        return button
    }()
 
    var phone: String?
    var inviteCode: String?
    var registerButtonClickHandler:((_ params: [String: Any]) -> Void)?
    var pswLoginClickHandler:(() -> Void)?
    
    let viewModel = RegisterLoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = localStr("kGetMsgCodeTitle")
        view.addSubview(navBar)
        view.addSubview(tipsLable)
        view.addSubview(phoneLable)
        view.addSubview(codeImage)
        view.addSubview(codeText)
        view.addSubview(codeBtn)
        view.addSubview(pswImage)
        view.addSubview(pswText)
        view.addSubview(seePswBtn)
     
        view.addSubview(registerButton)
        layoutPageSubviews()
        phoneLable.text = " +86\(phone ?? "")"
        addViewModelCallBack()
        addSendCodeCallBack()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func addViewModelCallBack() {
        viewModel.loadRegisterApiSuccess = { [weak self] in
            guard let strongself = self else { return }
            XSProgressHUD.hide(for: strongself.view, animated: false)
            self?.showDialog(title: strongself.localStr("kRegisterSuccessTitle"), message: strongself.localStr("kRegisterSuccessAlertMsg"), okTitle: strongself.localStr("kGoLogin"), cancelTitle: strongself.localStr("kCancle"), okHandler: {
                self?.navigationController?.popToRootViewController(animated: true)
            }, cancelHandler: nil)
        }
        viewModel.loadRegisterApiFail = { [weak self] (errorMsg) in
            guard let strongself = self else { return }
            XSProgressHUD.hide(for: strongself.view, animated: false)
            XSAlert.show(type: .error, text: errorMsg)
        }
        
        viewModel.loadSendCodeApiSuccess = { [weak self] in
            guard let strongSelf = self else { return }
            self?.codeBtn.isCounting = true
            XSAlert.show(type: .success, text: strongSelf.localStr("kSendCodeSuccess"))
        }
        viewModel.loadSendCodeApiFail = { (errorMsg) in
             XSAlert.show(type: .error, text: errorMsg)
        }
    }
    
    func addSendCodeCallBack() {
        var params = [String: Any]()
        params[SendCodeApi.kMobile] = phone
        codeBtn.sendCodeButtonClickHandler = { [weak self] in
            self?.viewModel.sendCode(params)
        }
    }

    @objc func registerButtonClick() {
        var params = [String: Any]()
        if let codeStr = codeText.text {
            let code = codeStr.removeAllSpace()
            if code == nil || code!.isEmpty {
                XSAlert.show(type: .warning, text: localStr("kPleaceInputMsgCode"))
                return
            }
            params[UserRegisterApi.kCode] = code!
        }
        if let pswStr = pswText.text {
            let psw = pswStr.removeAllSpace()
            if psw == nil || psw!.isEmpty {
                XSAlert.show(type: .warning, text: localStr("kPleaceInputPassword"))
                return
            }
            params[UserRegisterApi.kPassword_confirmation] = psw!
        }
        params[UserRegisterApi.kMobile] = phone
        if inviteCode != nil && !inviteCode!.isEmpty {
           params[UserRegisterApi.kInvite_code] = inviteCode
        }
        params[UserRegisterApi.kDevice_code] = UIDevice.current.getIdfv()
        params[UserRegisterApi.kVerification_key] = viewModel.getCodeModel().verification_key ?? "6856"
        // 注册接口
        XSProgressHUD.showProgress(msg: nil, onView: view, animated: false)
        viewModel.reginsterUser(params)
        
    }
    
    @objc func showPswText(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        pswText.isSecureTextEntry = !sender.isSelected
    }
 
}

// MARK: - QHNavigationBarDelegate
extension CodeController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Layout
private extension CodeController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutTipsLable()
        layoutPhoneLable()
        layoutCodeItem()
        layoutPswItem()
       
       layoutRegisterButton()
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    
    func layoutPswItem() {
        pswImage.snp.makeConstraints { (make) in
            make.leading.equalTo(25)
            make.top.equalTo(codeText.snp.bottom).offset(35)
            make.height.width.equalTo(20)
        }
        seePswBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-40)
            make.centerY.equalTo(pswImage)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        pswText.snp.makeConstraints { (make) in
            make.leading.equalTo(pswImage.snp.trailing).offset(15)
            make.centerY.equalTo(pswImage)
            make.height.equalTo(35)
            make.trailing.equalTo(seePswBtn.snp.leading).offset(-10)
        }
    }
    
    func layoutCodeItem() {
        codeImage.snp.makeConstraints { (make) in
            make.leading.equalTo(tipsLable)
            make.top.equalTo(phoneLable.snp.bottom).offset(40)
            make.width.height.equalTo(20)
        }
        codeBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-40)
            make.centerY.equalTo(codeImage)
            make.height.equalTo(30)
            make.width.equalTo(90)
        }
        codeText.snp.makeConstraints { (make) in
            make.leading.equalTo(codeImage.snp.trailing).offset(15)
            make.centerY.equalTo(codeBtn)
            make.height.equalTo(35)
            make.trailing.equalTo(codeBtn.snp.leading).offset(-10)
        }
    }
    
    func layoutTipsLable() {
        tipsLable.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom).offset(70)
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.height.equalTo(20)
        }
    }
    func layoutPhoneLable() {
        phoneLable.snp.makeConstraints { (make) in
            make.top.equalTo(tipsLable.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
   
    func layoutRegisterButton() {
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(pswText.snp.bottom).offset(45)
            make.height.equalTo(45)
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
        }
    }
    
   
    
}
