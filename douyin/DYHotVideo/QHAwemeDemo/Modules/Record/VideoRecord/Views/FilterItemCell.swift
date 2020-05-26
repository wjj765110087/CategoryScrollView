//
//  FilterItemCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/20.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class FilterItemCell: UICollectionViewCell {
    
    static let cellId = "FilterItemCell"
    // lineSelected
    lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setBackgroundImage(UIImage(named: "filterNormal"), for: .normal)
        button.setBackgroundImage(UIImage(named: "filterSelected"), for: .selected)
        button.addTarget(self, action: #selector(justThisFilter(_:)), for: .touchUpInside)
        return button
    }()
    let filterNameLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.init(white: 0.9, alpha: 1.0)
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.textAlignment = .center
        lable.text = "初恋"
        return lable
    }()
    
    var filterClickHandler:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(filterButton)
        contentView.addSubview(filterNameLable)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func justThisFilter(_ sender: UIButton) {
        filterClickHandler?()
    }
    
}

// MARK: - Layout
private extension FilterItemCell {
    
    func layoutPageSubviews() {
        layoutFilterButton()
        layoutFilterLable()
    }
    
    func layoutFilterButton() {
        filterButton.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(75)
        }
    }
    
    func layoutFilterLable() {
        filterNameLable.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-5)
            make.top.equalTo(filterButton.snp.bottom).offset(6)
        }
    }
}
