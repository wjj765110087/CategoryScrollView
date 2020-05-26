//
//  CateTagsSectionHeader.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/5/2.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

/// 选择分类区头
class CateTagsSectionHeader: UICollectionReusableView {
    
    static let identifier = "CateTagsSectionHeader"
    
    var titleLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 15)
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 50))
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        addSubview(titleLable)
        layoutViews()
    }
}

// MARK: - Layout
private extension CateTagsSectionHeader {
    
    func layoutViews() {
        layoutTitleLable()
    }

    func layoutTitleLable() {
        titleLable.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(15)
            $0.trailing.equalTo(-15)
        }
    }
}
