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
    static let itemSize = CGSize(width: screenWidth - 20, height: (screenWidth-20)*140/351)
    
    private var config: CyclePageConfig = {
        let config = CyclePageConfig()
        config.isLocalImage = false
        config.animationType = .crossDissolve
        config.transitionDuration = 4
        config.animationDuration = 1.5
        config.activeTintColor = ConstValue.kAppDefaultColor
        config.cycleCornerRadius = 5
        config.placeHolderImage = ConstValue.kHorizontalPHImage
        config.itemSize = CGSize(width: screenWidth - 20, height: (screenWidth-20)*140/351)
        return config
    }()
    private lazy var cycleView: CycleScrollView = {
        let view = CycleScrollView.init(frame: CGRect(x: 0, y: 0, width: screenWidth-10 , height: (screenWidth-10)*140/351), config: config)
        return view
    }()
    
    var scrollItemClickHandler:((_ index: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        contentView.addSubview(cycleView)
        layoutCycleView()
        cycleView.setImages(images: ["PH"], titles: nil)
        cycleView.pageClickAction = { [weak self] (index) in
            self?.scrollItemClickHandler?(index)
        }
    }
    
    func setModel(models: [FindAdContentModel]) {
        var images = [String]()
        for model in models {
            if let cover_oss_path  = model.cover_oss_path {
                images.append(cover_oss_path)
            }
        }
        setImages(images: images)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setImages(images: [String]) {
        cycleView.setImages(images: images ,titles: nil)
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



