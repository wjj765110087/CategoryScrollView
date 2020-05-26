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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "邀请码"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.lineView.isHidden = true
        bar.delegate = self
        return bar
    }()
    private lazy var saveBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("保存", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor(red: 41/255.0, green: 125/255.0, blue: 246/255.0, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(saveBtnClick(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    private lazy var inviteCodeTf: UITextField = {
        let textFiled = UITextField()
        textFiled.tintColor = .clear
        textFiled.backgroundColor = UIColor(red: 51/255.0  , green: 54/255.0, blue: 69/255.0, alpha: 0.99)
        textFiled.textColor = UIColor.white
        textFiled.borderStyle = .none
        textFiled.font = UIFont.systemFont(ofSize: 12)
        textFiled.layer.cornerRadius = 5
        textFiled.layer.masksToBounds = true
        textFiled.setPlaceholderTextColor(placeholderText: "    请填写邀请码", color: UIColor(white: 153/255, alpha: 1))
        textFiled.placeholder = "    请填写邀请码"
        return textFiled
    }()
    private lazy var setInviteCodeApi: SetInviteCodeApi = {
        let api = SetInviteCodeApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        navBar.navBarView.addSubview(saveBtn)
        view.addSubview(navBar)
        view.addSubview(inviteCodeTf)
        layoutPageSubviews()
        inviteCodeTf.setPlaceholderTextColor(placeholderText: "    请填写邀请码", color: UIColor(white: 153/255, alpha: 1))
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


// MARK: - QHNavigationBarDelegate
extension SetInviteCodeController:  QHNavigationBarDelegate  {
    
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
        layoutTextFiled()
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    
    func layoutTextFiled() {
        inviteCodeTf.snp.makeConstraints { (make) in
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
