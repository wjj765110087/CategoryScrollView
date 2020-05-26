//
//  VideoDetailSectionHeader.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/22.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

class VideoDetailSectionHeader: UICollectionReusableView {
    
    static let cellId = "VideoDetailSectionHeader"
    static let itemSize = CGSize(width: screenWidth - 20, height: 30)
    
    private lazy var label: UILabel = {
       let label = UILabel()
       label.text = "更多推荐"
       label.textColor = UIColor.init(r: 34, g: 34, b: 34)
       label.font = UIFont.systemFont(ofSize: 18)
       label.textAlignment = .left
       return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.leading.equalTo(11)
            make.trailing.equalTo(-11)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
