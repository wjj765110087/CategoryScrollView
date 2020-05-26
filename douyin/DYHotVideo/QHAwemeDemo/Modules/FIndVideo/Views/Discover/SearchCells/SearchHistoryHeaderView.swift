//
//  SearchHistoryHeaderView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/8.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class SearchHistoryHeaderView: UICollectionReusableView {
    
    static let reuseId = "SearchHistoryHeaderView"
    static let headerHeight: CGFloat = 35.0
    
    private lazy var historySearchLabel: UILabel = {
       let label = UILabel()
       label.text = "历史搜索"
       label.textColor = UIColor.init(r: 153, g: 153, b: 153)
       label.font = UIFont.systemFont(ofSize: 14)
       return label
    }()
    
    private lazy var clearButton: UIButton = {
       let button = UIButton()
       button.setImage(UIImage(named: "clearHistoryButton"), for: .normal)
       return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
