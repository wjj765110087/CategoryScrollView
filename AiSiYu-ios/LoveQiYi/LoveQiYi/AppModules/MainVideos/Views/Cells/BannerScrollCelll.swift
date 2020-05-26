//
//  VideoScrollCollectionCell.swift
//  XSVideo
//
//  Created by pro5 on 2018/11/30.
//  Copyright © 2018年 pro5. All rights reserved.
//

import UIKit

/// 用于轮播的BannerCell
class BannerScrollCell: UICollectionViewCell {
    
    static let cellId = "BannerScrollCell"
    static let itemSize = CGSize(width: screenWidth, height: screenWidth/2.16)
    
    private var config: CyclePageConfig = {
        let config = CyclePageConfig()
        config.isLocalImage = false
        config.animationType = .crossDissolve
        config.transitionDuration = 4
        config.animationDuration = 1.5
        config.activeTintColor = kAppDefaultColor
        return config
    }()
    private lazy var cycleView: CyclePageView = {
        let view = CyclePageView.init(frame: CGRect(x: 0, y: 0, width: screenWidth , height: screenWidth/2.16), config: config)
        return view
    }()
    var scrollItemClickHandler:((_ index: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        contentView.addSubview(cycleView)
        layoutCycleView()
        cycleView.setImages(["PH"])
        cycleView.pageClickAction = { [weak self] (index) in
            self?.scrollItemClickHandler?(index)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setImages(images: [String]) {
        cycleView.setImages(images)
    }
    
}

// MARK: - Layout
private extension BannerScrollCell {
    func layoutPageSubviews() {
        layoutCycleView()
    }
  
    func layoutCycleView() {
        cycleView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
}



