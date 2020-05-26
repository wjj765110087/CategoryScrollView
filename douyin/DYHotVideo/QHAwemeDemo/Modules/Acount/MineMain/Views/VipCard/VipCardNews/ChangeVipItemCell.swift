//
//  ChangeVipItemCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class ChangeVipItemCell: UITableViewCell {

    static let cellId = "ChangeVipItemCell"
    private let titleLab: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.text = "兑换中心"
        return label
    }()
    private let desLab: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(r: 153, g: 153, b: 153)
        label.text = "使用兑换码兑换"
        return label
    }()
    private let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r:30, g: 31, b: 49)
        return view
    }()
    private let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r:30, g: 31, b: 49)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        contentView.addSubview(titleLab)
        contentView.addSubview(desLab)
        contentView.addSubview(topLine)
        contentView.addSubview(bottomLine)
        layoutPageSubview()
        self.accessoryType = .disclosureIndicator
        let view = UIView()
        view.backgroundColor = UIColor(r: 30, g: 31, b:49)
        selectedBackgroundView = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Layout
private extension ChangeVipItemCell {
    func layoutPageSubview() {
        layoutTitleLabel()
        layoutDesLabel()
        layoutLines()
    }
    func layoutTitleLabel() {
        titleLab.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.centerY.equalToSuperview()
        }
    }
    func layoutDesLabel() {
        desLab.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10)
            make.centerY.equalToSuperview()
        }
    }
    func layoutLines() {
        topLine.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.top.equalToSuperview()
            make.trailing.equalTo(0)
            make.height.equalTo(0.5)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.bottom.equalToSuperview()
            make.trailing.equalTo(0)
            make.height.equalTo(0.5)
        }
    }
}
