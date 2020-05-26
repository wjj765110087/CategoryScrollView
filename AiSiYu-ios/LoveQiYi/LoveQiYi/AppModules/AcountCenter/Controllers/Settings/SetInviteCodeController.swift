//
//  SetInviteCodeController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/26.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

class SetInviteCodeController: UIViewController {

    private lazy var navBar: CNavigationBar = {
        let bar = CNavigationBar()
        bar.titleLabel.text = "绑定邀请码"
        bar.backgroundColor = kBarColor
        bar.delegate = self
        return bar
    }()
    private lazy var saveBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("保存", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(kAppDefaultTitleColor, for: .normal)
        button.addTarget(self, action: #selector(saveBtnClick(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    private lazy var inviteCodeTf: UITextField = {
        let textFiled = UITextField()
        textFiled.tintColor = .clear
        textFiled.backgroundColor = UIColor.clear
        textFiled.textColor = UIColor.darkText
        textFiled.borderStyle = .none
        textFiled.font = UIFont.systemFont(ofSize: 18)
        textFiled.layer.cornerRadius = 8
        textFiled.layer.masksToBounds = true
        textFiled.setValue(UIColor.lightGray, forKeyPath: "_placeholderLabel.textColor")
        textFiled.placeholder = "请输入邀请人的邀请码"
        return textFiled
    }()
    private let contView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 244, g: 244, b: 244)
        view.layer.cornerRadius = 6
        return view
    }()
    private lazy var setInviteCodeApi: SetInviteCodeApi = {
        let api = SetInviteCodeApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navBar.navBarView.addSubview(saveBtn)
        view.addSubview(navBar)
        view.addSubview(contView)
        view.addSubview(inviteCodeTf)
        layoutPageSubviews()
        inviteCodeTf.setValue(UIColor.lightGray, forKeyPath: "_placeholderLabel.textColor")
        if let inviteCode = UserModel.share().userInfo?.invite_me_code, !inviteCode.isEmpty {
            inviteCodeTf.text = " \(inviteCode)"
            saveBtn.isHidden = true
            inviteCodeTf.isEnabled = false
        } else {
            saveBtn.isHidden = false
            inviteCodeTf.isEnabled = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func saveBtnClick(_ sender: UIButton) {
        /// 调用
        let _  = setInviteCodeApi.loadData()
    }
   
}


// MARK: - CNavigationBarDelegate
extension SetInviteCodeController:  CNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension SetInviteCodeController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: self.view, imageNames: nil, bgColor: UIColor.clear, animated: false)
        return [SetInviteCodeApi.kCode: inviteCodeTf.text ?? ""]
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is SetInviteCodeApi {
            XSAlert.show(type: .success, text: "邀请码绑定成功。")
            UserModel.share().userInfo?.invite_me_code = inviteCodeTf.text ?? ""
            navigationController?.popViewController(animated: true)
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is SetInviteCodeApi {
            XSAlert.show(type: .error, text: manager.errorMessage)
        }
    }
}

// MARK: - Layout
private extension SetInviteCodeController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutSaveBtnBtn()
        layoutContView()
        layoutTextFiled()
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(statusBarHeight + 44)
        }
    }
    
    func layoutTextFiled() {
        inviteCodeTf.snp.makeConstraints { (make) in
            make.leading.equalTo(32)
            make.trailing.equalTo(-25)
            make.top.equalTo(navBar.snp.bottom).offset(25)
            make.height.equalTo(50)
        }
    }
    func layoutContView() {
        contView.snp.makeConstraints { (make) in
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.top.equalTo(navBar.snp.bottom).offset(25)
            make.height.equalTo(50)
        }
    }
    
    func layoutSaveBtnBtn() {
        saveBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(65)
            make.height.equalTo(35)
        }
    }
}
