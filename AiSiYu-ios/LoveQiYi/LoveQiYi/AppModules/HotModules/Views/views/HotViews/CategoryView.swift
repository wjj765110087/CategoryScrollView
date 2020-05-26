//
//  CategoryView.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/18.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

class CategoryView: UIView {
    
    private lazy var newButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("最新", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .clear
        button.tag = 1
        button.addTarget(self, action: #selector(didClick(button:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var hotButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("最热", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .clear
        button.tag = 2
        button.addTarget(self, action: #selector(didClick(button:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var lineView: UIView = {
       let view = UIView()
       view.backgroundColor = UIColor.white
       return view
    }()
    
    private lazy var newlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var clickButtonHandler: ((Int) -> ())?
    
    var selectedButton: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutPageView()
        newlineView.isHidden = false
        lineView.isHidden = true
        selectedButton = newButton
    }
    
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didClick(button:UIButton) {
        if selectedButton != button {
            if button == newButton {
                lineView.isHidden = true
                newlineView.isHidden = false
                selectedButton = button
            }
            
            if button == hotButton {
                newlineView.isHidden = true
                lineView.isHidden = false
                selectedButton = button
            }
            
            if let clickButtonHandler = clickButtonHandler {
                clickButtonHandler(button.tag)
            }
        }
    }
}

extension CategoryView {
    private func layoutPageView() {
        addSubview(newButton)
        addSubview(hotButton)
        addSubview(lineView)
        addSubview(newlineView)
        
        
        newButton.snp.makeConstraints { (make) in
            make.left.equalTo(80)
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 32))
        }
        
        hotButton.snp.makeConstraints { (make) in
            make.right.equalTo(-80)
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 32))
        }
        
        newlineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-6)
            make.centerX.equalTo(newButton.snp.centerX)
            make.size.equalTo(CGSize(width: 20, height: 3))
        }
        
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-6)
            make.centerX.equalTo(hotButton.snp.centerX)
            make.size.equalTo(CGSize(width: 20, height: 3))
        }
    }
}
