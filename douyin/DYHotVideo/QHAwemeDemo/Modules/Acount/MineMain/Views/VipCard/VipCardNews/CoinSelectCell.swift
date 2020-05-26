//
//  CoinSelectCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/18.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class CoinSelectCell: UITableViewCell {

    static let cellId = "CoinSelectCell"
    static let cellHeight: CGFloat = 180.0

    private let customLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8   // 水平最小间距
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right:10)
        layout.itemSize = VipCardItemCell.itemSize
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: self.bounds, collectionViewLayout: customLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(UINib.init(nibName: "CoinItemCell", bundle: Bundle.main), forCellWithReuseIdentifier: CoinItemCell.cellId)
        return collection
    }()
    
    var itemClickHandler:((_ selIndex: Int) -> ())?
    
    var selectedIndex: Int = 0
    var coinModels: [CoinModel]?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        contentView.addSubview(collectionView)
        layoutPageSubviews()
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModels(_ charges: [CoinModel]) {
        coinModels = charges
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CoinSelectCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coinModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinItemCell.cellId, for: indexPath) as! CoinItemCell
        cell.contentView.layer.cornerRadius = 3
        cell.contentView.layer.borderWidth = 2.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        if let models = coinModels, models.count > indexPath.item {
            let model = models[indexPath.item]
            let price = String(format: "¥%.f", Double(model.price ?? "0.00") ?? 0.00)
            cell.moneyLabel.attributedText = TextSpaceManager.configColorString(allString: price, attribStr: "¥", ConstValue.kTitleYelloColor, UIFont.boldSystemFont(ofSize: 13))
            if let coins = model.coins {
                cell.coinLabel.text = "\(coins)金币"
            }
            cell.discountLabel.text = model.intro ?? ""

            if indexPath.item == selectedIndex {
                cell.contentView.layer.borderColor = ConstValue.kTitleYelloColor.cgColor
            } else {
                cell.contentView.layer.borderColor = UIColor.clear.cgColor
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.item != selectedIndex {
            if let charges = coinModels, charges.count > indexPath.item {
                selectedIndex = indexPath.item
                itemClickHandler?(indexPath.item)
                collectionView.reloadData()
            }
        }
    }
    
}

// MARK: - Layout
private extension CoinSelectCell {
    
    func layoutPageSubviews() {
        layoutCollection()
    }
    
    func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(-10)
            make.height.equalTo(160)
        }
    }
}
