//
//  DaliyTaskSectionHeader.swift
//  QHAwemeDemo
//
//  Created by mac on 20/12/2019.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class DaliyTaskFristCell: UITableViewCell {

    static let reuseId = "DaliyTaskFristCell"
    static let headerHeight: CGFloat = 90.0
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    let conrnerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "兑换区"
        return label
    }()
    let shadowLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = UIColor(r: 245, g: 245, b: 245)
        label.text = "PROPS"
        return label
    }()
    let desLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 176, g: 176, b: 176)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "已拥有: 0个"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(bgView)
        contentView.addSubview(conrnerView)
        bgView.addSubview(shadowLabel)
        bgView.addSubview(titleLabel)
        bgView.addSubview(desLabel)
        layoutPageViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DaliyTaskFristCell {
    
    func layoutPageViews() {
        layoutBgView()
        layoutShadowLabel()
        layoutTitleLabel()
        layoutDesLabel()
    }
    func layoutBgView() {
        bgView.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.bottom.equalToSuperview()
        }
        conrnerView.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(bgView)
            make.height.equalTo(6)
        }
    }
    
    func layoutTitleLabel() {
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(32.5)
        }
    }

    func layoutDesLabel() {
        desLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
        }
    }
    func layoutShadowLabel() {
        shadowLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-10)
            make.height.equalTo(30)
            make.top.equalTo(18)
        }
    }
}
