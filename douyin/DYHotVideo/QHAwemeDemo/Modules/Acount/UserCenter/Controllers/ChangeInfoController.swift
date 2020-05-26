//
//  ChangeInfoController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/12.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

class ChangeInfoController: QHBaseViewController {

    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "修改简介"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = ConstValue.kViewLightColor
        bar.backButton.isHidden = false
        bar.titleLabel.isHidden = false
        bar.lineView.isHidden = true
        bar.delegate = self
        
        return bar
    }()
    
    private lazy var rightButton: UIButton = {
       let button = UIButton()
       button.setTitle("保存", for: .normal)
       button.setTitleColor(UIColor.init(r: 41, g: 125, b: 246), for: .normal)
       button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
       button.addTarget(self, action: #selector(save), for: .touchUpInside)
       return button
    }()
    
    private lazy var infoLabel: UILabel = {
       let label = UILabel()
       label.text = "个人简介(100字以内)"
       label.textColor = UIColor.init(r: 153, g: 153, b: 153)
       label.font = UIFont.systemFont(ofSize: 13)
       return label
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "填写个人简介更容易获得别人关注哦"
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.textColor = UIColor.white
        textView.delegate = self as UITextViewDelegate
        textView.backgroundColor = ConstValue.kViewLightColor
//        textView.becomeFirstResponder()
        return textView
    }()
    
    private lazy var updateUserInfoApi: UserUpdateInfoApi = {
       let api = UserUpdateInfoApi()
       api.paramSource = self
       api.delegate = self
       return api
    }()
    
    var textViewHandler: ((String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(navBar)
        navBar.addSubview(rightButton)
        view.addSubview(infoLabel)
        view.addSubview(textView)
        layoutPageViews()
        if let intro = UserModel.share().userInfo?.intro {
            textView.text = intro
        }
    }
    
    func loadData() {
        let _ = updateUserInfoApi.loadData()
    }

}

//MARK: - 点击事件
extension ChangeInfoController: UITextViewDelegate {
    
    @objc func save() {
        if let text = textView.text, !text.isEmpty {
            if text.count > 100 {
                XSProgressHUD.showMsg(to: view, msg: "个人简介限制100个字以内", animated: true)
                return
            }
             loadData()
        } else {
            XSProgressHUD.showMsg(to: view, msg: "填写个人简介更容易获得别人关注哦", animated: true)
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.becomeFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}

//MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate

extension ChangeInfoController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        let params = [UserUpdateInfoApi.kKey: "intro", UserUpdateInfoApi.kValue: textView.text ?? ""]
        if manager is UserUpdateInfoApi {
            
        }
        return params
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        
        if manager is UserUpdateInfoApi {
            textViewHandler?(textView.text ?? "填写个人简介更容易获得别人关注哦")
            UserModel.share().userInfo?.intro = textView.text ?? ""
            XSProgressHUD.showMsg(to: view, msg: "保存成功", animated: true)
        }
        
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        if manager is UserUpdateInfoApi {
            
        }
    }

}


//MARK: -Layout
extension ChangeInfoController {
    
    func layoutPageViews() {
        layoutNavBar()
        layoutRightButton()
        layoutInfoLabel()
        layoutTextView()
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(safeAreaTopHeight)
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
            make.leading.equalTo(20.5)
            make.top.equalTo(navBar.snp.bottom).offset(15)
        }
    }
    
    func layoutTextView() {
        textView.snp.makeConstraints { (make) in
            make.leading.equalTo(20.5)
            make.top.equalTo(infoLabel.snp.bottom).offset(12)
            make.trailing.equalTo(-17.5)
            make.height.equalTo(160)
        }
    }
}

//MARK: - QHNavigationBarDelegate
extension ChangeInfoController: QHNavigationBarDelegate {
    
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
