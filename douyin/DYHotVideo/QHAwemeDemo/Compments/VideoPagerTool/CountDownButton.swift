//
//  CountDownButton.swift
//
//  Created by pro5 on 2018/12/25.
//  Copyright © 2018年 cgm. All rights reserved.
//

import UIKit
import SnapKit

/// 验证码倒计时按钮
class CountDownButton: UIView {
    

    lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x:0, y: 0, width: frame.size.width, height: frame.size.height)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.setTitleColor(UIColor.white, for: .disabled)
        button.setTitle("获取验证码", for: .normal)
        button.addTarget(self, action: #selector(sendButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    private var countdownTimer: Timer?
    
    private var remainingSeconds: Int = 0 {
        willSet {
            sendButton.setTitle(String(format: "%@(%d)s", "重新获取", newValue), for: .normal)
            if newValue <= 0 {
                sendButton.setTitle("重新获取", for: .normal)
                isCounting = false
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime(_:)), userInfo: nil, repeats: true)
                
                remainingSeconds = 60
                
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
                //sendButton.backgroundColor = ConstValue.kAppDefaultColor
            }
            sendButton.isEnabled = !newValue
        }
    }
    
    var sendCodeButtonClickHandler:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sendButton)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func sendButtonClick(_ sender: UIButton) {
        sendCodeButtonClickHandler?()
    }
    
    @objc func updateTime(_ timer: Timer) {
        remainingSeconds -= 1
    }
}

// MARK: - Layout
extension CountDownButton {
    
    func layoutPageSubviews() {
        sendButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
