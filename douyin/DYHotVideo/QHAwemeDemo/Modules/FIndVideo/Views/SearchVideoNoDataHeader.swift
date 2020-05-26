//
//  SearchVideoNoDataHeader.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/11.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class SearchVideoNoDataHeader: UICollectionReusableView {
    
    static let reuseId = "SearchVideoNoDataHeader"
    static let headerSize: CGSize = CGSize(width: screenWidth, height: 100.0)
    
    lazy var label: UILabel = {
       let label = UILabel()
       label.text = ""
       label.textAlignment = .center
       label.font = UIFont.systemFont(ofSize: 15)
       label.textColor = UIColor.init(r: 153, g: 153, b: 153)
       return label
    }()
    lazy var recommentlabel: UILabel = {
        let label = UILabel()
        label.text = "精彩推荐"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(label)
        addSubview(recommentlabel)
        layoutPageViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -Layout
extension SearchVideoNoDataHeader {
    
    private func layoutPageViews() {
        layoutRecommentLabel()
        layoutLabel()
    }
    
    private func layoutLabel() {
        label.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(-20)
        }
    }
    func layoutRecommentLabel() {
        recommentlabel.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.bottom.equalTo(-5)
            make.height.equalTo(20)
        }
    }
    
}

///其他的搜索无数据的
class SearchOtherNoDataHeader: UITableViewHeaderFooterView {
    
    static let reuseId = "SearchOtherNoDataHeader"
    static let headerHeight: CGFloat = 100.0
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.init(r: 153, g: 153, b: 153)
        return label
    }()
    lazy var recommentlabel: UILabel = {
        let label = UILabel()
        label.text = "精彩推荐"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.white
        return label
    }()
        
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = ConstValue.kVcViewColor
        addSubview(label)
        addSubview(recommentlabel)
        layoutPageViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -Layout
extension SearchOtherNoDataHeader {
    
    private func layoutPageViews() {
        layoutRecommentLabel()
        layoutLabel()
    }
    
    private func layoutLabel() {
        label.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(-20)
        }
    }
    func layoutRecommentLabel() {
        recommentlabel.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.bottom.equalTo(-5)
            make.height.equalTo(20)
        }
    }
}

class SearchOtherNoDataHeaderView: UIView {

        static let headerHeight: CGFloat = 100.0
        
        lazy var label: UILabel = {
            let label = UILabel()
            label.text = "暂未搜索到内容"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 15)
            label.textColor = UIColor.init(r: 153, g: 153, b: 153)
            return label
        }()
        lazy var recommentlabel: UILabel = {
            let label = UILabel()
            label.text = "精彩推荐"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 15)
            label.textColor = UIColor.white
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .clear
            addSubview(label)
            addSubview(recommentlabel)
            layoutPageViews()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

}

//MARK: -Layout
extension SearchOtherNoDataHeaderView {
    
    private func layoutPageViews() {
        layoutRecommentLabel()
        layoutLabel()
    }
    
    private func layoutLabel() {
        label.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(-20)
        }
    }
    func layoutRecommentLabel() {
        recommentlabel.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.bottom.equalTo(-5)
            make.height.equalTo(20)
        }
    }
}

