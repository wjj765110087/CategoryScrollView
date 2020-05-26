//
//  ItemTitleCell.swift
//  RootTabBarController
//
//  Created by mac on 2019/6/15.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit
import SnapKit
class TitleItemCell: UICollectionViewCell {
    
    static let cellId = "TitleItemCell"
    
    lazy var itemBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.addTarget(self, action: #selector(itemClick(_:)), for: .touchUpInside)
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.backgroundColor = UIColor.clear
        return btn
    }()
    let lineView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        return view
    }()
    
    var itemClickHandler:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        addSubview(lineView)
        addSubview(itemBtn)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConfig(_ config: PageItemConfig) {
        itemBtn.setTitleColor(config.titleColorNormal, for: .normal)
        itemBtn.setTitleColor(config.titleColorSelected, for: .selected)
        itemBtn.layer.cornerRadius = config.itemCornerRadius
        lineView.layer.cornerRadius = config.lineSize.height/2
        itemBtn.layer.masksToBounds = true
        if config.lineImage != nil {
            lineView.image = config.lineImage
        } else {
            lineView.backgroundColor = config.lineColor
        }
        lineView.snp.remakeConstraints { (make) in
            make.top.equalTo(itemBtn.snp.bottom).offset(-5)
            make.width.equalTo(config.lineSize.width)
            make.height.equalTo(config.lineSize.height)
            if config.lineViewLocation == .center {
                make.centerX.equalToSuperview()
            } else if config.lineViewLocation == .left {
                make.leading.equalTo(config.titleMargin - 3.0)
            } else if config.lineViewLocation == .right {
                make.trailing.equalTo(-(config.titleMargin - 3.0))
            }
        }
    }
    
    @objc func itemClick(_ sender: UIButton) {
        if !sender.isSelected {
            itemClickHandler?()
        }
        
    }
    
    
}

private extension TitleItemCell {
    func layoutPageSubviews() {
        layoutItemBtn()
        layoutLineView()
    }
    func layoutItemBtn() {
        itemBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    func layoutLineView() {
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(itemBtn.snp.bottom).offset(-5)
            make.centerX.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(6)
        }
    }
}
