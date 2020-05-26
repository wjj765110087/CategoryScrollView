//
//  DiscoverSearchView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/5.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class DiscoverSearchView: UIView {
    
    private lazy var discoverLabel: UILabel = {
        let label = UILabel()
        label.text = "发现"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    private let searchBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 34, g: 29, b: 47)
        view.layer.cornerRadius = 18.0
        view.layer.masksToBounds = true
        return view
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
        button.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)
        return button
    }()
    
    var didClickSearchHandler: (()->())?
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(discoverLabel)
        addSubview(searchBgView)
        addSubview(searchFakeButton)
        searchBgView.addSubview(searchImage)
        searchBgView.addSubview(searchTitle)
        layoutpageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func searchBtnClick() {
        didClickSearchHandler?()
    }
}

// MARK: - Layout
private extension DiscoverSearchView {
    func layoutpageSubviews() {
        layoutDiscoverLabel()
        layoutSearchBgView()
        layoutSearchImage()
        layoutSearchTitle()
        layoutFakeSearchBtn()
    }
    func layoutDiscoverLabel() {
        discoverLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(14.5)
            make.width.equalTo(40)
            make.centerY.equalToSuperview()
        }
    }
    func layoutSearchBgView() {
        searchBgView.snp.makeConstraints { (make) in
            make.leading.equalTo(discoverLabel.snp.trailing).offset(15)
            make.trailing.equalTo(-12)
            make.centerY.equalToSuperview()
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
