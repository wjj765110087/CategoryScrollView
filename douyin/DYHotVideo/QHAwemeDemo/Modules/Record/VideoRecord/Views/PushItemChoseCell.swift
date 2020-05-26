//
//  PushItemChoseCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class PushItemChoseCell: UICollectionViewCell {
    static let cellId = "PushItemChoseCell"
    
    let itemView: CateChoseItemView = {
        let item = CateChoseItemView(frame: CGRect.zero)
        item.titleLable.text = "添加话题"
        item.tipsLable.text = "参与话题,让更多人看到"
        item.iconImage.image = UIImage(named: "talksPushIcon")
        return item
    }()
    
    var itemClickHandler:(()->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        contentView.addSubview(itemView)
        layoutItemView()
        itemView.itemClickHandler = { [weak self] in
            self?.itemClickHandler?()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
private extension PushItemChoseCell {
    func layoutItemView() {
        itemView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}


class PushTipsCell: UICollectionViewCell {
    
    static let cellId = "PushTipsCell"
    
    let tipsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 153, g: 153, b: 153)
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.attributedText = TextSpaceManager.getAttributeStringWithString("发布后请在我的动态查看审核进度，审核通过后将在首页或话题展示。", lineSpace: 5)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        contentView.addSubview(tipsLabel)
        layoutTipslabel()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func layoutTipslabel() {
        tipsLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(20)
        }
    }
}


class PushTypeItemCell: UICollectionViewCell {
    static let itemSize = CGSize(width: (screenWidth-40)/3, height: 90)
    static let cellId = "PushTyppItemCell"
    let itemImage: UIImageView = {
        let image = UIImageView()
        image.image = ConstValue.kDefaultHeader
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 30
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        return image
    }()
    let titleLab: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.darkText
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 13)
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        contentView.addSubview(itemImage)
        contentView.addSubview(titleLab)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - layout
private extension PushTypeItemCell {
    func layoutPageSubviews() {
        layoutItemView()
        layoutTitleLab()
    }
    func layoutItemView() {
        itemImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
            make.height.width.equalTo(60)
        }
    }
    func layoutTitleLab() {
        titleLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(itemImage)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(itemImage.snp.bottom).offset(8)
        }
    }
 
}
