//
//  MainSearchView.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

class MainSearchView: UIView {
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: screenWidth - 30, height: 34))
        searchBar.placeholder = "老湿，请多多 “指” 教"
        searchBar.changeFont(UIFont.systemFont(ofSize: 13))
        searchBar.searchBarStyle = .default
        searchBar.backgroundColor = UIColor.clear
        searchBar.backgroundImage = UIImage()
        searchBar.changeTextFieldBackgroundColor(UIColor(r: 56, g: 56, b: 59, a: 0.99))
        return searchBar
    }()
    private lazy var searchFakeBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(searchViewBtnClick), for: .touchUpInside)
        return button
    }()
    private lazy var histroyBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "mainHisIcon"), for: .normal)
        button.addTarget(self, action: #selector(searchViewBtnClick), for: .touchUpInside)
        return button
    }()
    private lazy var typeBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "doubleArrow"), for: .normal)
        button.setTitle("最新", for: .normal)
        button.setTitle("最热", for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(searchViewBtnClick), for: .touchUpInside)
        button.backgroundColor = UIColor(r: 56, g: 56, b: 59, a: 0.99)
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        button.isHidden = true
        return button
    }()
    /// 是否是推荐
    var isModuleVc: Bool = true {
        didSet {
            typeBtn.isHidden = isModuleVc
            histroyBtn.isHidden = !isModuleVc
            searchBar.snp.updateConstraints { (make) in
                make.trailing.equalTo(isModuleVc ? -47 : -72)
            }
        }
    }
    
    var actionHandler:((_ actionId: Int) -> Void)?
    
    var sort: String = HotListApi.kSort_new
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kBarColor
        addSubview(searchBar)
        addSubview(searchFakeBtn)
        addSubview(histroyBtn)
        addSubview(typeBtn)
        layoutPageSubviews()
        if let searchField: UITextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchField.layer.cornerRadius = 17.0
            searchField.layer.masksToBounds = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func searchViewBtnClick(_ sender: UIButton) {
        if sender == searchFakeBtn {
            actionHandler?(1)
        }
        if sender == histroyBtn {
            actionHandler?(2)
        }
        if sender == typeBtn {
            typeBtn.isSelected = !typeBtn.isSelected
            sort = typeBtn.isSelected ? HotListApi.kSort_hot : HotListApi.kSort_new
            actionHandler?(3)
        }
    }
    
}

private extension MainSearchView {
    
    func layoutPageSubviews() {
        layoutHistroyBtn()
        layoutTypeBtn()
        layoutSearchBar()
        layoutSearchBtn()
    }
    func layoutSearchBar() {
        searchBar.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-47)
            make.leading.equalTo(5)
            make.height.equalTo(34)
        }
    }
    func layoutSearchBtn() {
        searchFakeBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(searchBar)
        }
    }
    
    func layoutHistroyBtn() {
        histroyBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-8)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(34)
        }
    }
    func layoutTypeBtn() {
        typeBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-8)
            make.centerY.equalToSuperview()
            make.height.equalTo(34)
            make.width.equalTo(62)
        }
    }
}

