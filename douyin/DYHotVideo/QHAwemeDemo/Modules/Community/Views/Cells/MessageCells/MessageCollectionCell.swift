//
//  MessageCollectionCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/2.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class MessageCollectionCell: UICollectionViewCell {
    
    static let itemSize = CGSize(width: 49, height: 90)
    static let cellId = "MessageCollectionCell"
    
    let countLab: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(r: 255, g: 51, b: 51)
        label.text = ""
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 11)
        label.layer.borderColor = ConstValue.kVcViewColor.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 7.0
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()
    
    let itemImage: UIImageView = {
        let image = UIImageView()
        image.image = ConstValue.kDefaultHeader
        image.layer.cornerRadius = 20.5
        image.layer.masksToBounds = true
        return image
    }()
    let titleLab: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.lightGray
        lable.textAlignment = .center
        lable.text = "--"
        lable.font = UIFont.systemFont(ofSize: 12)
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        contentView.addSubview(itemImage)
        contentView.addSubview(countLab)
        contentView.addSubview(titleLab)
        layoutPageSubviews()
    }
    
    func setTitle(title: String) {
        self.titleLab.text = title
    }
    
    func setIconImage(image: String) {
        self.itemImage.image = UIImage(named: image)
    }
    
    func setModel(model: MessageModel) {
        if let num = model.num {
            if num > 0 {
                countLab.text = String(format: "%d", model.num ?? "")
                countLab.isHidden = false
                let size = countLab.textSize(text: "\(num)", font: UIFont.systemFont(ofSize: 11), maxSize: CGSize.init(width: 35, height: 20))
                countLab.snp.updateConstraints { (make) in
                    make.size.equalTo(CGSize.init(width: size.width + 15, height: size.height))
                }
            } else {
                countLab.isHidden = true
                countLab.text = ""
                countLab.snp.updateConstraints { (make) in
                    make.size.equalTo(CGSize(width: 30, height: 15))
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - layout
private extension MessageCollectionCell {
    func layoutPageSubviews() {
        layoutItemImage()
        layoutCountLab()
        layoutTitleLab()
    }

    func layoutItemImage() {
        itemImage.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.width.height.equalTo(49)
        }
    }
    func layoutCountLab() {
        countLab.snp.makeConstraints { (make) in
            make.top.equalTo(-2)
            make.leading.equalTo(itemImage.snp.leading).offset(33)
            make.height.equalTo(15)
            make.width.equalTo(35)
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
