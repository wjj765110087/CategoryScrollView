//
//  WalletHeaderView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/12.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class WalletHeaderView: UIView {
    
    var titleLabel: UILabel = {
        let labe = UILabel()
        labe.textColor = UIColor(r: 176, g: 176, b: 176)
        labe.text = "余额账户 (元)"
        labe.font = UIFont.systemFont(ofSize: 13)
        return labe
    }()
    var moneyLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "0.00"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        return label
    }()
//    var incomeLabel: UILabel = {
//        let labe = UILabel()
//        labe.textColor = UIColor(r: 118, g: 118, b: 118)
//        labe.text = "累计收益：0.00 元"
//        labe.font = UIFont.systemFont(ofSize: 15)
//        return labe
//    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor =  ConstValue.kVcViewColor
        addSubview(titleLabel)
        addSubview(moneyLabel)
//        addSubview(incomeLabel)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Layout
private extension WalletHeaderView {
    func layoutPageSubviews() {
        layoutTitleLab()
        layoutMoneyLabel()
//        layouIncomeLabel()
    }
    func layoutTitleLab() {
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.top.equalTo(20)
            make.height.equalTo(20)
            make.trailing.equalTo(-20)
        }
    }
    func layoutMoneyLabel() {
        moneyLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
        }
    }
//    func layouIncomeLabel() {
//        incomeLabel.snp.makeConstraints { (make) in
//            make.leading.equalTo(titleLabel)
//            make.trailing.equalTo(titleLabel)
//            make.top.equalTo(moneyLabel.snp.bottom).offset(15)
//        }
//    }
}
