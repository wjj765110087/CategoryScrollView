//
//  NicknameController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/8/27.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

class NicknameController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "修改名字"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitle("保存", for: .normal)
        button.setTitleColor(UIColor.init(r: 41, g: 125, b: 246), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "我的名字"
        label.textColor = UIColor.init(r: 153, g: 153, b: 153)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var nickNameTf: UITextField = {
        let tf = UITextField()
        tf.text = UserModel.share().userInfo?.nikename
        tf.textColor = UIColor.white
        tf.placeholder = "请输入昵称"
        tf.setPlaceholderTextColor(placeholderText: "请输入昵称", color: UIColor(white: 0.7, alpha: 0.6))
        tf.delegate = self
        return tf
    }()
    
    private lazy var clearButton: UIButton = {
       let button = UIButton()
       button.setImage(UIImage(named: "clearNickName"), for: .normal)
       button.addTarget(self, action: #selector(didClearButton), for: .touchUpInside)
       return button
    }()
    
    private lazy var lineView: UIView = {
       let view = UIView()
       view.backgroundColor = UIColor.init(r: 32, g: 29, b: 46)
       return view
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "--/10"
        label.textColor = UIColor.init(r: 153, g: 153, b: 153)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var updateUserInfoApi: UserUpdateInfoApi = {
        let api = UserUpdateInfoApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(navBar)
        navBar.addSubview(rightButton)
        view.addSubview(infoLabel)
        view.addSubview(nickNameTf)
        view.addSubview(clearButton)
        view.addSubview(lineView)
        view.addSubview(countLabel)
        layoutPageSubViews()
        
        countLabel.text = String(format: "%d/8", UserModel.share().userInfo?.nikename?.count ?? 0)
    
    }
}
// MARK: - QHNavigationBarDelegate
extension NicknameController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension NicknameController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if text.count > 8 || text.count == 0 {
                rightButton.isEnabled = false
            } else {
                rightButton.isEnabled = true
            }
            countLabel.text = String(format: "%d/8", text.count)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            if text.count > 8 || text.count == 0 {
                rightButton.isEnabled = false
            } else {
                rightButton.isEnabled = true
            }
            countLabel.text = String(format: "%d/8", text.count)
        }
        return true
    }
    
    @objc func save() {
        if let text = nickNameTf.text, !text.isEmpty {
            if text.count > 8 {
                XSAlert.show(type: .error, text: "昵称不能超过8个字")
                return
            }
            if text != UserModel.share().userInfo?.nikename {
                XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
                let _ = updateUserInfoApi.loadData()
            }
        }
    }
    @objc func didClearButton() {
         nickNameTf.text = ""
    }
    
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension NicknameController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        let params = [UserUpdateInfoApi.kKey: "nikename", UserUpdateInfoApi.kValue: nickNameTf.text ?? ""]
        if manager is UserUpdateInfoApi {
            return params
        }
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserUpdateInfoApi {
            XSProgressHUD.showSuccess(msg: "修改昵称成功", onView: view, animated: true)
            UserModel.share().userInfo?.nikename = nickNameTf.text
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        XSAlert.show(type: .error, text: "昵称修改失败")
    }
}

// MARK: - Layout
private extension NicknameController {
    func layoutPageSubViews() {
        layoutNavBar()
        layoutRightButton()
        layoutInfoLabel()
        layoutTextField()
        layoutClearButton()
        layoutCountLabel()
    }
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    
    func layoutRightButton() {
        rightButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-5)
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
    }
    
    func layoutInfoLabel() {
        infoLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(24)
            make.top.equalTo(navBar.snp.bottom).offset(18)
        }
    }
    
    func layoutTextField() {
        nickNameTf.snp.makeConstraints { (make) in
            make.leading.equalTo(24)
            make.trailing.equalTo(-15)
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
    }
    
    func layoutClearButton() {
        clearButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-23.5)
            make.centerY.equalTo(nickNameTf.snp.centerY)
            make.width.height.equalTo(15)
        }
    }
    
    func layoutCountLabel() {
        countLabel.snp.makeConstraints { (make) in
           make.leading.equalTo(24)
           make.top.equalTo(nickNameTf.snp.bottom).offset(9.5)
        }
    }
}
