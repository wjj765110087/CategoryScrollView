//
//  VipCardsContentCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/13.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class VipCardsContentCell: UITableViewCell {
    
    static let cellId = "VipCardsContentCell"
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
        collection.register(UINib.init(nibName: "VipCardItemCell", bundle: Bundle.main), forCellWithReuseIdentifier: VipCardItemCell.cellId)
        return collection
    }()
    
    var itemClickHandler:((_ selIndex: Int) -> ())?
    
    var selectedIndex: Int = 0
    var vipCardModels: [VipCardModel]?
    
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
    
    func setModels(_ charges: [VipCardModel]) {
        vipCardModels = charges
        collectionView.reloadData()
    }
    
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension VipCardsContentCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vipCardModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VipCardItemCell.cellId, for: indexPath) as! VipCardItemCell
        cell.contentView.layer.cornerRadius = 3
        cell.contentView.layer.borderWidth = 2.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        if let models = vipCardModels, models.count > indexPath.item {
            let model = models[indexPath.item]
            let price = String(format: "¥%.f", Double(model.price_current ?? "0.00") ?? 0.00)
            cell.cardPrise.attributedText = TextSpaceManager.configColorString(allString: price, attribStr: "¥", ConstValue.kTitleYelloColor, UIFont.boldSystemFont(ofSize: 13))
            cell.cardName.text = model.title ?? ""
            cell.cardIntro.text = model.remark ?? ""
            if let days = model.daily_until, days > 0 {
                if days >= 1000 {
                    cell.cardTime.text = "永久无限"
                } else {
                    cell.cardTime.text = "\(days)天"
                }
            }
            if indexPath.item == selectedIndex {
                cell.contentView.layer.borderColor = ConstValue.kTitleYelloColor.cgColor
            } else {
                cell.contentView.layer.borderColor = UIColor.clear.cgColor
            }
            if let color = model.color, !color.isEmpty  {
                if color.hasPrefix("#"), color.count <= 7 && color.count > 6 {
                    cell.cardTagView.backgroundColor = UIColor.init(hexString: color)
                } else {
                    cell.cardTagView.backgroundColor = UIColor.init(hexString:"#FF2A31")
                }
            } else {
                cell.cardTagView.backgroundColor = UIColor.init(hexString: "#FF2A31")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.item != selectedIndex {
            if let charges = vipCardModels, charges.count > indexPath.item {
                selectedIndex = indexPath.item
                itemClickHandler?(indexPath.item)
                collectionView.reloadData()
            }
        }
    }
    
}

// MARK: - Layout
private extension VipCardsContentCell {
    
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



class UpdoorServerContentCell: UITableViewCell {
    
    static let cellId = "UpdoorServerContentCell"
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
        collection.register(UINib.init(nibName: "VipCardItemCell", bundle: Bundle.main), forCellWithReuseIdentifier: VipCardItemCell.cellId)
        return collection
    }()
    
    var itemClickHandler:((_ selIndex: Int) -> ())?
    
    var selectedIndex: Int = 0
    var serverModels: [UpDoorServerModel]?
    
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
    
    func setModels(_ charges: [UpDoorServerModel]) {
        serverModels = charges
        collectionView.reloadData()
    }
    
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension UpdoorServerContentCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serverModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VipCardItemCell.cellId, for: indexPath) as! VipCardItemCell
        cell.contentView.layer.cornerRadius = 3
        cell.contentView.layer.borderWidth = 2.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        if let models = serverModels, models.count > indexPath.item {
            let model = models[indexPath.item]
            let price = String(format: "¥%.f", Double(model.price_current ?? "0.00") ?? 0.00)
            cell.cardPrise.attributedText = TextSpaceManager.configColorString(allString: price, attribStr: "¥", ConstValue.kTitleYelloColor, UIFont.boldSystemFont(ofSize: 13))
            cell.cardName.text = model.title ?? ""
            cell.cardIntro.text = model.remark ?? ""
            cell.cardTime.isHidden = true
            cell.daysLabelHeight.constant = 0.0
            cell.dayTopMargin.constant = 0.0
            if indexPath.item == selectedIndex {
                cell.contentView.layer.borderColor = ConstValue.kTitleYelloColor.cgColor
            } else {
                cell.contentView.layer.borderColor = UIColor.clear.cgColor
            }
            if let color = model.color, !color.isEmpty  {
                if color.hasPrefix("#"), color.count <= 7 && color.count > 6 {
                    cell.cardTagView.backgroundColor = UIColor.init(hexString: color)
                } else {
                    cell.cardTagView.backgroundColor = UIColor.init(hexString:"#FF2A31")
                }
            } else {
                cell.cardTagView.backgroundColor = UIColor.init(hexString: "#FF2A31")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.item != selectedIndex {
            if let charges = serverModels, charges.count > indexPath.item {
                selectedIndex = indexPath.item
                itemClickHandler?(indexPath.item)
                collectionView.reloadData()
            }
        }
    }
    
}

// MARK: - Layout
private extension UpdoorServerContentCell {
    
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
