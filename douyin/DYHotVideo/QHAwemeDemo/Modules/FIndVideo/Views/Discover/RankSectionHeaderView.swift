//
//  RankSectionHeaderView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/7.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class RankSectionHeaderView: UITableViewHeaderFooterView {

     static let reuseId = "RankSectionHeaderView"
     static let headerHeight: CGFloat = 35.0
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "更新于09月12日00:00"
        label.textColor = UIColor.init(r: 153, g: 153, b: 153)
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = ConstValue.kVcViewColor
        contentView.addSubview(label)
        layoutPageSubViews()
    }
    
    func setModel(model: FindRankModel) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -Layout
private extension RankSectionHeaderView {
    
    func layoutPageSubViews() {
        layoutLabel()
    }
    
    func layoutLabel() {
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
