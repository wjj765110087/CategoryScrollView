//
//  CommunityHeader.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/9/30.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class CommunityHeader: UIView {

    let titleLab: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "话题圈"
        return label
    }()
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("MORE", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor(r: 153, g: 153, b: 153), for: .normal)
        button.addTarget(self, action: #selector(moreButtonClick), for: .touchUpInside)
        return button
    }()
    private let customLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CommunityItemCell.itemSize
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 6
        layout.sectionInset = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 5)
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 80, height: 90), collectionViewLayout: customLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(CommunityItemCell.classForCoder(), forCellWithReuseIdentifier: CommunityItemCell.cellId)
        return collection
    }()
    
    var itemClickHandler:((_ index: Int)->Void)?
    var moreButtonHandler: (()->())?
    
    var talksModels: [TalksModel]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ConstValue.kViewLightColor
        addSubview(titleLab)
        addSubview(moreButton)
        addSubview(collectionView)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func moreButtonClick() {
        moreButtonHandler?()
    }
    func setModels(_ list: [TalksModel]?) {
        talksModels = list
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CommunityHeader: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return talksModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityItemCell.cellId, for: indexPath) as! CommunityItemCell
        cell.itemImage.kfSetVerticalImageWithUrl(talksModels?[indexPath.item].cover_url)
        cell.titleLab.text = "#\(talksModels?[indexPath.item].title ?? "")"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        itemClickHandler?(indexPath.item)
    }
    
}

// MARK: - Layout
private extension CommunityHeader {
    func layoutPageSubviews() {
        layoutTitleLab()
        layoutMoreButton()
        layoutCollection()
    }
    func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom).offset(7)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    func layoutTitleLab() {
        titleLab.snp.makeConstraints { (make) in 
            make.leading.equalTo(15)
            make.top.equalTo(15)
            make.height.equalTo(25)
        }
    }
    func layoutMoreButton() {
        moreButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLab)
            make.trailing.equalTo(-15)
            make.height.equalTo(25)
            make.width.equalTo(55)
        }
    }
    
}
