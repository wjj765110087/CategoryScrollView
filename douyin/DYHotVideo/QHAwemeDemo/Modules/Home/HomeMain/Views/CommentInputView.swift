//
//  CommentInputView.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/15.
//  Copyright © 2018年 pro5. All rights reserved.
//

import UIKit

class CommentInputView: UIView {

    private let headerView: UIView = {
        let view = UIView(frame:  CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 40))
        //view.backgroundColor = UIColor.yellow
        return view
    }()
    let titleLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.textAlignment = .left
        lable.textColor = UIColor.darkText
        lable.text = "发评论"
        return lable
    }()
    private lazy var keboardButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "keyBoardArrowUp"), for: .normal)
        button.addTarget(self, action: #selector(keyboardDowm), for: .touchUpInside)
        return button
    }()
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("发送", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(UIColor.orange, for: .normal)
        button.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        return button
    }()
    lazy var textInputView: UITextField = {
        let textView = UITextField()
        textView.backgroundColor = UIColor.white
        textView.borderStyle = .none
        textView.returnKeyType = .send
        textView.placeholder = "@ 我来说两句..."
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.delegate = self

        return textView
    }()
    
    var keyBoardDownHandler:((_ text: String?) -> Void)?
    var sendButtonHandler:((_ text: String?) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        headerView.addSubview(titleLable)
        headerView.addSubview(keboardButton)
        addSubview(headerView)
        addSubview(textInputView)
        addSubview(sendButton)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func keyboardDowm() {
        textInputView.resignFirstResponder()
        keyBoardDownHandler?(textInputView.text)
    }
    @objc private func sendComment() {
        textInputView.resignFirstResponder()
        sendButtonHandler?(textInputView.text)
        textInputView.text = nil
    }
    
}

// MARK: - UITextFieldDelegate
extension CommentInputView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textInputView.resignFirstResponder()
        sendButtonHandler?(textInputView.text)
        textInputView.text = nil
        return true
    }
    
}
private extension CommentInputView {
    
    func layoutPageSubviews() {
        layoutHeaderView()
        layoutSendButton()
        layoutInputView()
        layoutTitleLable()
        layoutKeyboardButton()
    }
    
    func layoutHeaderView() {
        headerView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(35)
        }
    }
    
    func layoutInputView() {
        textInputView.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalToSuperview().offset(-10)
            make.trailing.equalTo(sendButton.snp.leading).offset(-10)
        }
    }
    
    func layoutSendButton() {
        sendButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10)
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(50)
        }
    }
    
    func layoutTitleLable() {
        titleLable.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(120)
        }
    }
    
    func layoutKeyboardButton() {
        keboardButton.snp.makeConstraints { (make) in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
    }
}
