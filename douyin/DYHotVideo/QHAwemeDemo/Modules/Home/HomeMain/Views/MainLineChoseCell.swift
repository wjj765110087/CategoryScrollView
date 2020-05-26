//
//  MainLineChoseCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/22.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class MainLineChoseCell: UITableViewCell {
    
    static let cellId = "MainLineChoseCell"
    
    var nameLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "VIP线路1"
        return label
    }()
   var selectedBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "mainLineUnselected"), for: .normal)
        button.setImage(UIImage(named: "lineSelected"), for: .selected)
        //button.addTarget(self, action: #selector(selectedMainLine(_:)), for: .touchUpInside)
        return button
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLable)
        contentView.addSubview(selectedBtn)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   
}

// MARK: - Layout
private extension MainLineChoseCell {
    
    func layoutPageSubviews() {
        nameLable.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(110)
        }
        selectedBtn.snp.makeConstraints { (make) in
            make.width.equalTo(30)
            make.trailing.equalTo(-10)
            make.top.bottom.equalToSuperview()
        }
        
    }
}
