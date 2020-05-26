//
//  SpecialTopicHeaderCell.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/6.
//  Copyright © 2018年 pro5. All rights reserved.
//

import UIKit

class SpecialTopicHeaderCell: UICollectionViewCell {

    static let cellId = "SpecialTopicHeaderCell"
    
    let imageBg: UIImageView = {
        let imageV = UIImageView()
        imageV.isUserInteractionEnabled = true
        imageV.contentMode = .scaleAspectFill
        imageV.layer.masksToBounds = true
        return imageV
    }()
    let imageCover: UIImageView = {
        let imageV = UIImageView()
        imageV.isUserInteractionEnabled = true
        imageV.contentMode = .scaleAspectFill
        imageV.image = UIImage(named: "headerSerCover")
        imageV.layer.masksToBounds = true
        return imageV
    }()
    
    let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 3
        return view
    }()
    let infoTitle: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.textColor = UIColor.white
        lable.text = "国产妹儿"
        return lable
    }()
    let infoLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = UIColor.init(white: 0.9, alpha: 1.0)
        lable.numberOfLines = 2
        lable.text = "Av片看得索然无味，抖阴带你飞"
        lable.backgroundColor = UIColor.clear
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(imageBg)
        contentView.addSubview(imageCover)
        contentView.addSubview(infoView)
        infoView.addSubview(infoTitle)
        infoView.addSubview(infoLable)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var cellFrame = layoutAttributes.frame
        cellFrame.size.height = size.height
        layoutAttributes.frame = cellFrame
        return layoutAttributes
    }
}

// MARK: - Layout
private extension SpecialTopicHeaderCell {
    
    func layoutPageSubviews() {
        layoutImageView()
        layoutInfoBgView()
        layoutImageCover()
        layoutInfoTitle()
        layoutInfoLable()
    }
    
    func layoutImageView() {
        imageBg.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(330)
        }
    }
    
    func layoutImageCover() {
        imageCover.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(imageBg)
            make.height.equalTo(25)
        }
    }
    
    func layoutInfoBgView() {
        infoView.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.equalTo(imageBg.snp.bottom).offset(5)
            make.bottom.equalTo(-5)
        }
    }
    
    func layoutInfoTitle() {
        infoTitle.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalTo(10)
            make.height.equalTo(20)
        }
    }
    
    func layoutInfoLable() {
        infoLable.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalTo(infoTitle.snp.bottom).offset(5)
            make.trailing.equalTo(-10)
            make.bottom.equalTo(-5)
        }
    }
}
