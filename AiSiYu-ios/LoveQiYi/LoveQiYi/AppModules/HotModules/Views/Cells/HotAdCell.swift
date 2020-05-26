//
//  HotAdCell.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/23.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

//热点广告cell
class HotAdCell: UICollectionViewCell {
    
    static let cellId = "HotAdCell"
    static let itemSize = CGSize(width: screenWidth-20, height: (screenWidth - 20)*0.414)
   
    private lazy var imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PH")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutPageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(_ model: AdModel?) {
        imgView.kfSetHorizontalImageWithUrl(model?.cover_oss_path)
    }
}

extension HotAdCell {
    
    private func layoutPageView() {
        layoutImageView()
    }
    
    private func layoutImageView() {
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
}
