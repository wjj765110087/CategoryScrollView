//
//  CommunityItemCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/9/30.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class CommunityItemCell: UICollectionViewCell {
    static let itemSize = CGSize(width: 70, height: 90)
    static let cellId = "CommunityItemCell"
    let itemBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 27.5
        view.layer.borderColor = UIColor(r: 0, g: 123, b: 255).cgColor
        view.layer.borderWidth = 1.0
        return view
    }()
    let itemImage: UIImageView = {
        let image = UIImageView()
        image.image = ConstValue.kDefaultHeader
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 22.5
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        return image
    }()
    let titleLab: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.lightGray
        lable.textAlignment = .center
        lable.text = "#巨乳合集"
        lable.font = UIFont.systemFont(ofSize: 12)
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        contentView.addSubview(itemBgView)
        contentView.addSubview(titleLab)
        itemBgView.addSubview(itemImage)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - layout
private extension CommunityItemCell {
    func layoutPageSubviews() {
        layoutItemBgView()
        layoutTitleLab()
        layoutItemImage()
    }
    func layoutItemBgView() {
        itemBgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
            make.height.width.equalTo(55)
        }
    }
    func layoutTitleLab() {
        titleLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(itemBgView)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(itemBgView.snp.bottom).offset(8)
        }
    }
    func layoutItemImage() {
        itemImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(45)
        }
    }
}
