//
//  ActivityItemsHeaderView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/6.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class ActivityItemsHeaderView: UIView {
    
    private let customLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 11
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: customLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(ActivityChildItemCell.classForCoder(), forCellWithReuseIdentifier: ActivityChildItemCell.cellId)
        return collection
    }()
    
    var itemClickHandler:((_ index: Int)->Void)?
    var moreButtonHandler: (()->())?
    
    var activityChilds = [ActivityChild]()
    
    /// 当前选中的index
    var currentSelectedIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(collectionView)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func moreButtonClick() {
        moreButtonHandler?()
    }
    
    func setModels(_ list: [ActivityChild]?) {
        
        if let items = list, items.count > 0 {
            activityChilds = items
            activityChilds[0].selected = true
        }
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ActivityItemsHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activityChilds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityChildItemCell.cellId, for: indexPath) as! ActivityChildItemCell
         cell.setModel(activityChilds[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.item != currentSelectedIndex {
            activityChilds[indexPath.item].selected = true
            activityChilds[currentSelectedIndex].selected = false
            currentSelectedIndex = indexPath.item
            collectionView.reloadData()
            itemClickHandler?(indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spec: CGFloat = CGFloat((activityChilds.count - 1) * 11)
        let itemWith = (screenWidth - 24 - spec)/CGFloat(activityChilds.count > 3 ? 3 : activityChilds.count)
        return CGSize(width: itemWith, height: 38)
    }
    
}

// MARK: - Layout
private extension ActivityItemsHeaderView {
    func layoutPageSubviews() {
        layoutCollection()
    }
    func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(0)
            make.bottom.equalToSuperview()
        }
    }
}

class ActivityChildItemCell: UICollectionViewCell {
    
    static let cellId = "ActivityChildItemCell"
    
    let itemButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setBackgroundImage(UIImage.imageFromColor(UIColor(r: 30, g: 31, b: 49), frame: CGRect(x: 0, y: 0, width: screenWidth, height: 38)), for: .normal)
        button.setBackgroundImage(UIImage.imageFromColor(UIColor(r: 1, g: 123, b: 254), frame: CGRect(x: 0, y: 0, width: screenWidth, height: 38)), for: .selected)
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        contentView.addSubview(itemButton)
        itemButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(_ model: ActivityChild) {
        itemButton.setTitle(model.name ?? "", for: .normal)
        itemButton.isSelected = model.selected ?? false
    }
}
