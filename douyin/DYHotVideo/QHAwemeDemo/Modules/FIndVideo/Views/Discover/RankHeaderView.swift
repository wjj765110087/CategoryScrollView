//
//  RankHeaderView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/7.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class RankHeaderView: UIView {

    private var config: CyclePageConfig = {
        let config = CyclePageConfig()
        config.isLocalImage = false
        config.animationType = .crossDissolve
        config.transitionDuration = 4
        config.animationDuration = 1.5
        config.activeTintColor = ConstValue.kAppDefaultColor
        config.cycleCornerRadius = 0
        return config
    }()
    
    private lazy var cycleView: CyclePageView = {
        let view = CyclePageView.init(frame: CGRect(x: 0, y: 0, width: screenWidth , height: screenWidth*141/375), config: config)
        return view
    }()
    
    var scrollItemClickHandler:((_ index: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cycleView)
        layoutCycleView()
        cycleView.setImages(["PH"])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImages(images: [String]) {
        cycleView.setImages(images)
        cycleView.pageClickAction = { [weak self] (index) in
            self?.scrollItemClickHandler?(index)
        }
    }
    
}

// MARK: - Layout
private extension RankHeaderView {
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
