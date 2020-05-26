//
//  FindTypeChoseController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/3.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class FindTypeChoseController: UIViewController {
    
    private lazy var idCardBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("用身份卡找回", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setBackgroundImage(UIImage.imageFromColor(UIColor.groupTableViewBackground, frame: CGRect(x: 0, y: 0, width: screenWidth - 20, height: 60)), for: .normal)
        button.setBackgroundImage(UIImage.imageFromColor(UIColor.white, frame: CGRect(x: 0, y: 0, width: screenWidth - 20, height: 60)), for: .highlighted)
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.addTarget(self, action: #selector(typeChoseBtnClick(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.tag = 101
        return button
    }()

    private lazy var phoneBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("手机号码找回", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setBackgroundImage(UIImage.imageFromColor(UIColor.groupTableViewBackground, frame: CGRect(x: 0, y: 0, width: screenWidth - 20, height: 60)), for: .normal)
        button.setBackgroundImage(UIImage.imageFromColor(UIColor.white, frame: CGRect(x: 0, y: 0, width: screenWidth - 20, height: 60)), for: .highlighted)
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.addTarget(self, action: #selector(typeChoseBtnClick(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.tag = 102
        return button
    }()
    private lazy var infoBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("填写资料找回", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setBackgroundImage(UIImage.imageFromColor(UIColor.groupTableViewBackground, frame: CGRect(x: 0, y: 0, width: screenWidth - 20, height: 60)), for: .normal)
        button.setBackgroundImage(UIImage.imageFromColor(UIColor.white, frame: CGRect(x: 0, y: 0, width: screenWidth - 20, height: 60)), for: .highlighted)
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.addTarget(self, action: #selector(typeChoseBtnClick(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.tag = 103
        return button
    }()
    private lazy var callUsBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("联系客服找回", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setBackgroundImage(UIImage.imageFromColor(UIColor.groupTableViewBackground, frame: CGRect(x: 0, y: 0, width: screenWidth - 20, height: 60)), for: .normal)
        button.setBackgroundImage(UIImage.imageFromColor(UIColor.white, frame: CGRect(x: 0, y: 0, width: screenWidth - 20, height: 60)), for: .highlighted)
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.addTarget(self, action: #selector(typeChoseBtnClick(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.tag = 104
        return button
    }()
    private lazy var cancleBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("取 消", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setBackgroundImage(UIImage.imageFromColor(UIColor.groupTableViewBackground, frame: CGRect(x: 0, y: 0, width: screenWidth - 20, height: 50)), for: .normal)
        button.setBackgroundImage(UIImage.imageFromColor(UIColor.white, frame: CGRect(x: 0, y: 0, width: screenWidth - 20, height: 50)), for: .highlighted)
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.addTarget(self, action: #selector(cancleAction), for: .touchUpInside)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
    }()
    
    var itemClickHandler:((_ index: Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cancleBtn)
        view.addSubview(callUsBtn)
        view.addSubview(infoBtn)
        view.addSubview(phoneBtn)
        view.addSubview(idCardBtn)
        layoutPageSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        dismiss(animated: true, completion: nil)
    }
    

    @objc func typeChoseBtnClick(_ sender: UIButton) {
        itemClickHandler?(sender.tag - 100)
    }
    
    @objc func cancleAction() {
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - Layout
private extension FindTypeChoseController {
    
    func layoutPageSubviews() {
        layoutButtons()
    }
    
    func layoutButtons() {
        cancleBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.height.equalTo(50)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                make.bottom.equalToSuperview().offset(-10)
            }
        }
        
        callUsBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(cancleBtn)
            make.height.equalTo(55)
            make.bottom.equalTo(cancleBtn.snp.top).offset(-10)
        }
        infoBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(callUsBtn)
            make.height.equalTo(55)
            make.bottom.equalTo(callUsBtn.snp.top).offset(-2)
        }
        phoneBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(callUsBtn)
            make.height.equalTo(55)
            make.bottom.equalTo(infoBtn.snp.top).offset(-2)
        }
        idCardBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(callUsBtn)
            make.height.equalTo(55)
            make.bottom.equalTo(phoneBtn.snp.top).offset(-2)
        }
    }
    
}
