//
//  TypeKeysCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/8/30.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class TypeKeysCell: UICollectionViewCell {
    
    static let cellId = "TypeKeysCell"

    let titleLab: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.white
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.backgroundColor = UIColor(white: 0.8, alpha: 0.3)
        lable.layer.cornerRadius = 3
        lable.layer.masksToBounds = true
        return lable
    }()
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        self.addSubview(titleLab)
        layoutTitleLab()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Lyout
private extension TypeKeysCell {
    func layoutTitleLab() {
        titleLab.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
    }
}

