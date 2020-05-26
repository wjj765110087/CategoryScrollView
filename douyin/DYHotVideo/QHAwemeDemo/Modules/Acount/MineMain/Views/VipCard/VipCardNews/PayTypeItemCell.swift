//
//  PayTypeItemCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class PayTypeItemCell: UITableViewCell {

    static let cellId = "PayTypeItemCell"
    
    lazy var payBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        return button
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "支付宝"
        return label
    }()
    let selectedBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "payTypeUnSelected"), for: .normal)
        button.setImage(UIImage(named: "PayTypeSelected"), for: .selected)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        contentView.addSubview(payBtn)
        contentView.addSubview(titleLabel)
        contentView.addSubview(selectedBtn)
        layoutPageSubviews()
        let view = UIView()
        view.backgroundColor = UIColor(r: 30, g: 31, b:49)
        selectedBackgroundView = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(_ model: PayTypeModel) {
        selectedBtn.isSelected = model.selected ?? false
        titleLabel.textColor = (model.status ?? .enable) == .enable ? UIColor.white : UIColor.darkGray
        titleLabel.text = model.title ?? ""
        if model.id == 2 {
            if (model.status ?? .enable) == .enable {
                payBtn.setImage(UIImage(named: "wechatIcon"), for: .normal)
            } else {
                payBtn.setImage(UIImage(named: "wechatPayEnble"), for: .normal)
            }
        } else if model.id == 1 {
            if (model.status ?? .enable) == .enable {
                payBtn.setImage(UIImage(named: "zhifubaoIcon"), for: .normal)
            } else {
                payBtn.setImage(UIImage(named: "alipayenAble"), for: .normal)
            }
        } else if model.id == 3 {
            if (model.status ?? .enable) == .enable {
                payBtn.setImage(UIImage(named: "CloudPay"), for: .normal)
            } else {
                payBtn.setImage(UIImage(named: "CloudPayDis"), for: .normal)
            }
        } else if model.id == 4 {
            if let balance = UserDefaults.standard.object(forKey: "UserBalance") as? String {
                if let title = model.title {
                    titleLabel.text = title + balance
                }
            }
            if (model.status ?? .enable) == .enable {
                payBtn.setImage(UIImage(named: "balancePay"), for: .normal)
            } else {
                payBtn.setImage(UIImage(named: "balancePayDisable"), for: .normal)
            }
        }
    }
    
}

// MARK: - layout
private extension PayTypeItemCell {
    
    func layoutPageSubviews() {
        layoutIconBtn()
        layoutTitleLabel()
        layoutSelectedBtn()
    }
    
    func layoutIconBtn() {
        payBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }
    func layoutTitleLabel() {
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(payBtn.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    func layoutSelectedBtn() {
        selectedBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-20)
            make.centerY.equalToSuperview()
        }
    }
}
