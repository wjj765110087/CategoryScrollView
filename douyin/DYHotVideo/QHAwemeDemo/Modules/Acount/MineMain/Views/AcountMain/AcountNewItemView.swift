//
//  AcountNewItemView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/4.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class AcountNewItemView: UIView {
    
    private let iconImage = ["VIpIcon","packetIcon","InviteItenIcon","tgItemIcon"]
    private let titles = ["充值中心","钱包","邀请看片","加群交流"]
    
    private let customLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (screenWidth - 66)/4, height: (screenWidth - 66)/4)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 65, height: 90), collectionViewLayout: customLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.isScrollEnabled = false
        collection.register(AcountNewItemCell.classForCoder(), forCellWithReuseIdentifier: AcountNewItemCell.cellId)
        return collection
    }()
    
    var itemClickHandler:((_ index: Int)->Void)?
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(collectionView)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension AcountNewItemView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AcountNewItemCell.cellId, for: indexPath) as! AcountNewItemCell
        cell.iconImage.image = UIImage(named: iconImage[indexPath.item])
        cell.titleLable.text = titles[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        itemClickHandler?(indexPath.item)
    }
    
}

// MARK: - Layout
private extension AcountNewItemView {
    func layoutPageSubviews() {
        layoutCollection()
    }
    func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}

class AcountNewItemCell: UICollectionViewCell {
    static let cellId = "AcountNewItemCell"
    let iconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    let titleLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(r:214, g: 215, b: 220)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor =  ConstValue.kViewLightColor
        contentView.layer.cornerRadius = 5
        contentView.addSubview(iconImage)
        contentView.addSubview(titleLable)
        layoutPageSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func layoutPageSubviews() {
        layoutIconImage()
        layoutTitleLabel()
    }
    private func layoutIconImage() {
        iconImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.centerY)
            make.width.height.equalTo(25)
        }
    }
    private func layoutTitleLabel() {
        titleLable.snp.makeConstraints { ( make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(iconImage.snp.bottom).offset(10)
        }
    }
}
