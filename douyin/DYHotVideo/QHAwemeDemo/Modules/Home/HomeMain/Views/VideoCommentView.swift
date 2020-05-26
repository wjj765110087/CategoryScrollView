//
//  VideoCommentView.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/15.
//  Copyright © 2018年 pro5. All rights reserved.
//

import UIKit


/// 视频详情底部的评论弹框
class VideoCommentView: UIView {
    
    let inputBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.1)
        view.layer.cornerRadius = 20.0
        view.layer.masksToBounds = true
        return view
    }()

    lazy var textInputView: UITextField = {
        let textView = UITextField()
        textView.borderStyle = .none
        textView.placeholder = "请输入评论..."
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColor.white
        textView.delegate = self
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "sendMsg_dis"), for: .disabled)
        button.setImage(UIImage(named: "sendMsg_en"), for: .normal)
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    var sendCommentTextHandler:((_ commentText: String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
        addSubview(inputBgView)
        addSubview(sendButton)
        inputBgView.addSubview(textInputView)
        layoutPageSubviews()
        textInputView.setPlaceholderTextColor(placeholderText: "请输入评论...", color: UIColor(white: 0.7, alpha: 0.6))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func buttonClick(_ sender: UIButton) {
       sendCommentTextHandler?(textInputView.text ?? "")
    }
    
}

// MARK: - UITextFieldDelegate
extension VideoCommentView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let texts = textInputView.text, !texts.isEmpty {
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let texts = textInputView.text, !texts.isEmpty {
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
        return true
    }
}

// MARK: - Layout
private extension VideoCommentView {
    
    func layoutPageSubviews() {
        layoutSendBtn()
        layoutInputBgView()
        layoutTextView()
    }
    
    func layoutTextView() {
        textInputView.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.trailing.equalTo(-12)
        }
    }
    
    func layoutInputBgView() {
        inputBgView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(sendButton.snp.leading).offset(-15)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
    }

    func layoutSendBtn() {
        sendButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-15)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(30)
        }
    }
    
}
