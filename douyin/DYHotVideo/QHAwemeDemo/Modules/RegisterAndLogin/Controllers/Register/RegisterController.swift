//
//  RegisterController.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/18.
//  Copyright © 2018年 pro5. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {

    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "wkkkkk"
        bar.delegate = self
        return bar
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
    lazy var inviteImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "codeImage")
        image.contentMode = .scaleAspectFit
        image.isHidden = true
        return image
    }()
    lazy var phoneText: UITextField = {
        let txfild = UITextField()
        txfild.borderStyle = .none
        txfild.placeholder = "請輸入手機號碼"
        txfild.keyboardType = .numberPad
        txfild.clearButtonMode = .whileEditing
        txfild.font = UIFont.systemFont(ofSize: 16)
        return txfild
    }()
    lazy var inviteCodeBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("請輸入邀請碼(選填)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(ConstValue.kAppDefaultTitleColor, for: .normal)
        button.setTitleColor(ConstValue.kAppDefaultTitleColor, for: .selected)
        button.imagePosition(at: .right, space: 18)
        button.setImage(UIImage(named: "showInviteCode"), for: .normal)
        button.setImage(UIImage(named: "showInviteCode"), for: .selected)
        button.addTarget(self, action: #selector(showInviteCodeText(_:)), for: .touchUpInside)
        return button
    }()
    lazy var inviteText: UITextField = {
        let txfild = UITextField()
        txfild.borderStyle = .none
        txfild.placeholder = "請輸入邀請碼"
        txfild.font = UIFont.systemFont(ofSize: 16)
        txfild.isHidden = true
        return txfild
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("下壹步", for: .normal)
        button.setBackgroundImage(UIImage.imageFromColor(ConstValue.kAppDefaultColor, frame: CGRect(x: 0, y: 0, width: 120, height: 40)), for: .normal)
        button.setBackgroundImage(UIImage.imageFromColor(UIColor.lightGray, frame: CGRect(x: 0, y: 0, width: 120, height: 40)), for: .disabled)
        button.layer.cornerRadius = 22.5
        button.layer.masksToBounds = true
        // button.isEnabled = false
        button.addTarget(self, action: #selector(nextButtonClick), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var selectedButton: UIButton = {
        let button = UIButton()
        button.isSelected = false
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -3)
        button.setImage(UIImage(named: "normalAgree"), for: .normal)
        button.setImage(UIImage(named: "selectedUserAgree"), for: .selected)
        button.setTitle("我已閱讀並同意", for: .normal)
        button.setTitleColor(UIColor(hexadecimalString: "#999999"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        button.addTarget(self, action: #selector(selectedAgreement(_:)), for: .touchUpInside)
        button.isSelected = true
        return button
    }()
    lazy private var agreementButton: UIButton = {
        let button = UIButton()
        button.setTitle("《用護服務協議》", for: .normal)
        button.setTitleColor(ConstValue.kAppDefaultTitleColor, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(userAgreementButtonClick), for: .touchUpInside)
        return button
    }()
    
    var loginButtonClickHandler:(() -> Void)?
    var pswLoginClickHandler:(() -> Void)?
    var navHidenCallBackHandler:((_ navAnimation: Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "註冊"
        view.addSubview(navBar)
        view.addSubview(phoneImage)
        view.addSubview(phoneText)
        view.addSubview(countryCodeBtn)
        view.addSubview(inviteCodeBtn)
        view.addSubview(inviteImage)
        view.addSubview(inviteText)
       
        view.addSubview(nextButton)
        view.addSubview(selectedButton)
        view.addSubview(agreementButton)
        layoutPageSubviews()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func countryCodeButtonClick() {
//        let vc = CountryCodeController()
//        vc.backCountryCode = { [weak self] country, code in
//            DLog("country = \(country) ==== code = \(code)")
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func nextButtonClick() {
        if let phoneStr = phoneText.text {
            let phone = phoneStr.removeAllSpace()
            if phone == nil || phone!.isEmpty {
                XSAlert.show(type: .warning, text: "請輸入手機號碼")
                return
            }
            if phone!.isValidPhoneNumber() {
                let codeVC = CodeController()
                codeVC.phone = phone
                codeVC.inviteCode = inviteText.text
                navigationController?.pushViewController(codeVC, animated: true)
            } else {
                XSAlert.show(type: .warning, text: "請輸入正確的手機號")
            }
        }
    }
    
    @objc func showInviteCodeText(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        inviteImage.isHidden = !sender.isSelected
        inviteText.isHidden = !sender.isSelected
    }
    
    @objc func pswLoginButtonClick() {
        pswLoginClickHandler?()
    }
    
    @objc func userAgreementButtonClick() {
        
    }
    
    @objc private func selectedAgreement(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        nextButton.isEnabled = sender.isSelected
    }
    
}

// MARK: - QHNavigationBarDelegate
extension RegisterController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Layout
private extension RegisterController {
    
    func layoutPageSubviews() {
        layoutNav()
        layoutPhoneItem()
        layoutInviteItem()
        layoutLoginButton()
        layoutAgreementButton()
    }
    
    func layoutNav() {
        navBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    func layoutInviteItem() {
        inviteCodeBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(phoneImage)
            make.top.equalTo(phoneImage.snp.bottom).offset(40)
            make.height.equalTo(40)
        }
        inviteImage.snp.makeConstraints { (make) in
            make.leading.equalTo(phoneImage)
            make.top.equalTo(inviteCodeBtn.snp.bottom).offset(30)
            make.height.width.equalTo(20)
        }
        inviteText.snp.makeConstraints { (make) in
            make.leading.equalTo(inviteImage.snp.trailing).offset(15)
            make.centerY.equalTo(inviteImage)
            make.height.equalTo(35)
            make.trailing.equalTo(phoneText)
        }
        
    }
    
    func layoutPhoneItem() {
        phoneImage.snp.makeConstraints { (make) in
            make.leading.equalTo(25)
            make.top.equalTo(navBar.snp.bottom).offset(70)
            make.width.height.equalTo(20)
        }
        countryCodeBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(phoneImage.snp.trailing).offset(15)
            make.centerY.equalTo(phoneImage)
            make.height.equalTo(30)
            make.width.equalTo(40)
        }
        phoneText.snp.makeConstraints { (make) in
            make.leading.equalTo(countryCodeBtn.snp.trailing).offset(10)
            make.centerY.equalTo(countryCodeBtn)
            make.height.equalTo(35)
            make.trailing.equalTo(-40)
        }
    }
    
   
    func layoutLoginButton() {
        nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(inviteText.snp.bottom).offset(35)
            make.height.equalTo(45)
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
        }
    }
    
    func layoutAgreementButton() {
        selectedButton.snp.makeConstraints { (make) in
            make.leading.equalTo(nextButton.snp.leading).offset(30)
            make.top.equalTo(nextButton.snp.bottom).offset(15)
            make.height.equalTo(35)
            make.width.equalTo(110)
        }
        agreementButton.snp.makeConstraints { (make) in
            make.leading.equalTo(selectedButton.snp.trailing).offset(5)
            make.centerY.equalTo(selectedButton)
            make.height.equalTo(35)
        }
    }
    
}
