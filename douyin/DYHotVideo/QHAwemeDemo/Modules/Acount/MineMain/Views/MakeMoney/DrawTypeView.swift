//
//  DrawTypeView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/6/1.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class DrawTypeView: UIView {


   lazy var alipayBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.clear
        button.setTitle("提现到支付宝", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor(r: 255, g: 42, b: 49), for: .selected)
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        button.isSelected = true
        button.tag = 1
        fakeBtn = button
        return button
    }()
   lazy var bankCardBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.clear
        button.setTitle("提现到银行卡", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor(r: 255, g: 42, b: 49), for: .selected)
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        button.tag = 2
        return button
    }()
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 42, b: 49)
        view.layer.cornerRadius = 1.5
        view.layer.masksToBounds = true
        return view
    }()
    var fakeBtn: UIButton!
    var actionHandler:((_ senderTag: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(alipayBtn)
        addSubview(bankCardBtn)
        addSubview(lineView)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonClick(_ sender: UIButton) {
        if fakeBtn == sender { return }
        sender.isSelected = true
        fakeBtn.isSelected = false
        fakeBtn = sender
        if sender == alipayBtn {
            lineView.snp.updateConstraints { (make) in
                  make.centerX.equalTo(ConstValue.kScreenWdith/4)
            }
        } else {
            lineView.snp.updateConstraints { (make) in
                  make.centerX.equalTo(ConstValue.kScreenWdith*3/4)
            }
        }
        actionHandler?(sender.tag)
    }
    
    private func layoutPageSubviews() {
        alipayBtn.snp.makeConstraints { (make) in
            make.leading.bottom.equalToSuperview()
            make.top.equalTo(6)
            make.width.equalTo(ConstValue.kScreenWdith/2)
        }
        bankCardBtn.snp.makeConstraints { (make) in
            make.trailing.bottom.equalToSuperview()
            make.top.equalTo(6)
            make.width.equalTo(ConstValue.kScreenWdith/2)
        }
        lineView.snp.makeConstraints { (make) in
            make.centerX.equalTo(ConstValue.kScreenWdith/4)
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
            make.width.equalTo(60)
        }
    }
}

