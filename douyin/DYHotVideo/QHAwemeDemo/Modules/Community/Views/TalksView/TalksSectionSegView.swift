//
//  TalksSectionSegView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/1.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class TalksSectionSegView: UIView {
    
    let enterTimesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 153, g: 153, b: 153)
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "0次浏览"
        return label
    }()
    lazy var newButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("最新", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor(r: 153, g: 153, b: 153), for: .normal)
        button.setTitleColor(UIColor(r: 0, g: 123, b: 255), for: .selected)
        button.addTarget(self, action: #selector(segButtonsClick(_:)), for: .touchUpInside)
        button.isSelected = true
        button.tag = 1
        return button
    }()
    lazy var hotButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("最热", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor(r: 153, g: 153, b: 153), for: .normal)
        button.setTitleColor(UIColor(r: 0, g: 123, b: 255), for: .selected)
        button.addTarget(self, action: #selector(segButtonsClick(_:)), for: .touchUpInside)
        button.tag = 2
        return button
    }()
    private let sepLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    private let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 15, g: 15, b: 29)
        return view
    }()
    private let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 15, g: 15, b: 29)
        return view
    }()
    
    private var fakeButton: UIButton!
    
    // 1: 最新 2. 最热
    var segOrderHandler:((_ index: Int) ->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(topLine)
        addSubview(bottomLine)
        addSubview(enterTimesLabel)
        addSubview(newButton)
        addSubview(sepLine)
        addSubview(hotButton)
        layoutPageSubviews()
        fakeButton = newButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func segButtonsClick(_ sender: UIButton) {
        if fakeButton != sender {
            sender.isSelected = true
            fakeButton.isSelected = false
            fakeButton = sender
            segOrderHandler?(sender.tag)
        }
        
    }

}

// MARK: - Layout
private extension TalksSectionSegView {
    func layoutPageSubviews() {
        layoutTopAndBottomView()
        layoutEnterTimesLabel()
        layoutHotButton()
        layoutSepLine()
        layoutNewButton()
    }
    func layoutTopAndBottomView() {
        topLine.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    func layoutEnterTimesLabel() {
        enterTimesLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(15)
        }
    }
    func layoutHotButton() {
        hotButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-15)
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
    }
    func layoutSepLine() {
        sepLine.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(8)
            make.width.equalTo(1)
            make.trailing.equalTo(hotButton.snp.leading).offset(-5)
        }
    }
    func layoutNewButton() {
        newButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(sepLine.snp.leading).offset(-5)
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
    }
}
