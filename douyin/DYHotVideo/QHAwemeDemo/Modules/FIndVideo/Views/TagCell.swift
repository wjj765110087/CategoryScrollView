//
//  TagCell.swift
//  GroupTagDemo
//
//  Created by Janise on 2019/1/24.
//  Copyright © 2019年 Janise. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    
    static let cellId = "TagCell"
    
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor =  ConstValue.kViewLightColor
        label.layer.cornerRadius = 17.5
        label.layer.masksToBounds = true
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        contentView.addSubview(tagLabel)
        layoutPageSubviews()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TagCell {
    
    func layoutPageSubviews() {
        tagLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

class PushKeysCell: UICollectionViewCell {
    
    static let cellId = "PushKeysCell"
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(r: 30, g: 31, b:49)
        label.layer.cornerRadius = 17.5
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    lazy var deleBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "deleteTagsBtn"), for: .normal)
        button.addTarget(self, action: #selector(deleteButtonClick), for: .touchUpInside)
        return button
    }()
    
    var deleteTagsHandler:(() ->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(tagLabel)
        contentView.addSubview(deleBtn)
        layoutPageSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func deleteButtonClick() {
        deleteTagsHandler?()
    }
}

private extension PushKeysCell {
    
    func layoutPageSubviews() {
        tagLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        deleBtn.snp.makeConstraints { (make) in
            make.top.equalTo(tagLabel).offset(-12)
            make.trailing.equalTo(tagLabel).offset(12)
            make.width.height.equalTo(25)
        }
    }
    
}


