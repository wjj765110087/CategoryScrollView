//
//  SearchSecHeadView.swift
//  LayoutCollection
//
//  Created by mac on 2019/6/2.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class SearchSecHeadView: UICollectionReusableView {
    static let identifier = "SearchSecHeadView"
    
    private var titleView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    var titleLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor(r: 153, g: 153, b: 153)
        lable.text = "历史搜索"
        lable.font = UIFont.boldSystemFont(ofSize: 14)
        return lable
    }()
    lazy var rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cleanASearchHis"), for: .normal)
        button.addTarget(self, action: #selector(rightActionClick), for: .touchUpInside)
        return button
    }()
    var rightAction:(() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        addSubview(titleView)
        titleView.addSubview(titleLable)
        titleView.addSubview(rightButton)
        layoutPageSubviews()
    }
    
    @objc func rightActionClick() {
        rightAction?()
    }
    
}

private extension SearchSecHeadView {
    func layoutPageSubviews() {
        titleView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        titleLable.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-80)
        }
        rightButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(35)
            
        }
    }
}
