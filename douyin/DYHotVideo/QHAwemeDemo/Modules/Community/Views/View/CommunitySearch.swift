//
//  CommunitySearch.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/9/30.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class CommunitySearch: UIView {

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
    private lazy var msgButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "msgIcon"), for: .normal)
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.setTitle("...", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: -8, left: 0, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(msgBtnClick), for: .touchUpInside)
        return button
    }()
    private lazy var searchFakeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)
        return button
    }()
     lazy var dotView: UIImageView = {
      let imageView = UIImageView()
      imageView.image = UIImage(named: "messageDot")
      imageView.isHidden = true
      return imageView
    }()
    var msgButtonHandler: (()->())?
    var serachItemHandler:(() ->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(msgButton)
        addSubview(dotView)
        addSubview(searchBgView)
        addSubview(searchFakeButton)
        searchBgView.addSubview(searchImage)
        searchBgView.addSubview(searchTitle)
        layoutpageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func msgBtnClick() {
        msgButtonHandler?()
    }
    @objc private func searchBtnClick() {
        serachItemHandler?()
    }
    
}

// MARK: - Layout
private extension CommunitySearch {
    func layoutpageSubviews() {
        layoutMsgBtn()
        layoutSearchBgView()
        layoutSearchImage()
        layoutSearchTitle()
        layoutFakeSearchBtn()
        layoutDotView()
    }
    func layoutMsgBtn() {
        msgButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-15)
            make.width.height.equalTo(28)
            make.bottom.equalTo(-5)
        }
    }
    func layoutSearchBgView() {
        searchBgView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(msgButton.snp.leading).offset(-10)
            make.height.equalTo(36)
            make.centerY.equalTo(msgButton).offset(-3)
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
    func layoutDotView() {
        dotView.snp.makeConstraints { (make) in
            make.trailing.equalTo(msgButton.snp.trailing)
            make.top.equalTo(msgButton.snp.top)
            make.width.height.equalTo(12)
        }
    }
}
