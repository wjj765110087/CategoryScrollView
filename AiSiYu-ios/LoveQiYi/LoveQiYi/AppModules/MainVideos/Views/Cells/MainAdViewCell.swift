//
//  MainAdViewCell.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/25.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import UIKit

class MainAdViewCell: UICollectionViewCell {
    static let cellId = "MainAdViewCell"
    static let itemSize = CGSize(width: screenWidth-20, height: (screenWidth - 20)*0.414)
    
    private let adImage: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleToFill
        imageV.image = UIImage(named: "PH")
        return imageV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(adImage)
        layoutImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(_ model: AdModel) {
        adImage.kfSetHorizontalImageWithUrl(model.cover_oss_path)
    }
    
    private func layoutImageView() {
        adImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
