//
//  DiscoverSearchCancelView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/7.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class DiscoverSearchCancelView: UICollectionReusableView {
    
    static let reuseId = "DiscoverSearchCancelView"
    static let headerHeight: CGFloat = 60.0
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.tag = 100
        button.addTarget(self, action: #selector(buttonDidClick), for: .touchUpInside)
        return button
    }()
    
    private let searchBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 34, g: 29, b: 47)
        view.layer.cornerRadius = 17.0
        view.layer.masksToBounds = true
        return view
    }()
    
    private let textField: UITextField = {
       let textField = UITextField()
       textField.backgroundColor = .clear
       return textField
    }()
    
    private let searchImage: UIImageView = {
        let search = UIImageView(image: UIImage(named: "communitySeachIcon"))
        search.contentMode = .scaleAspectFit
        search.isUserInteractionEnabled = true
        return search
    }()
    private let searchTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 103, g: 102, b: 117)
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "搜索用户/视频/话题"
        return label
    }()
    
    private lazy var searchFakeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 101
        button.addTarget(self, action: #selector(buttonDidClick), for: .touchUpInside)
        return button
    }()
    
    var buttonClickHandler: ((_ index: Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor =  ConstValue.kViewLightColor
        addSubview(cancelButton)
        addSubview(searchBgView)
        addSubview(searchFakeButton)
        searchBgView.addSubview(textField)
        searchBgView.addSubview(searchImage)
        searchBgView.addSubview(searchTitle)
        
        layoutpageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func buttonDidClick(_ sender: UIButton) {
        buttonClickHandler?(sender.tag)
    }
}

// MARK: - Layout
private extension DiscoverSearchCancelView {
    func layoutpageSubviews() {
        layoutCancelButton()
        layoutSearchBgView()
        
        layoutSearchImage()
        layoutSearchTitle()
        layoutFakeSearchBtn()
    }
    
    func layoutCancelButton() {
        cancelButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-19.5)
            make.width.equalTo(50)
            make.centerY.equalToSuperview().offset(10)
        }
    }
    
    func layoutSearchBgView() {
        searchBgView.snp.makeConstraints { (make) in
            make.trailing.equalTo(cancelButton.snp.leading).offset(-16.5)
            make.leading.equalTo(12)
            make.centerY.equalToSuperview().offset(10)
            make.height.equalTo(36)
        }
    }
    func layoutSearchImage() {
        searchImage.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.centerY.equalToSuperview()
        }
    }
    func layoutSearchTitle() {
        searchTitle.snp.makeConstraints { (make) in
            make.leading.equalTo(searchImage.snp.trailing).offset(10)
            make.centerY.equalTo(searchImage)
        }
    }
    func layoutFakeSearchBtn() {
        searchFakeButton.snp.makeConstraints { (make) in
            make.leading.edges.equalTo(searchBgView)
        }
    }
}
