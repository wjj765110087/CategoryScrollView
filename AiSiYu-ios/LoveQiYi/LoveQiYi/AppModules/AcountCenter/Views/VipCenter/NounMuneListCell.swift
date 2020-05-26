//
//  NounMuneListCell.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import UIKit

class NounMuneListCell: UITableViewCell {
    
    static let cellId = "NounMuneListCell"
  
    let tipsLabel: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.lightGray
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.text = "支付失败或未收到会员，请及时反馈"
        return lable
    }()
    private let customLayout: CustomFlowSingleLayout = {
        let layout = CustomFlowSingleLayout()
        layout.itemSize = NounMenuItemCell.itemSize
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: self.bounds, collectionViewLayout: customLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(UINib.init(nibName: "NounMenuItemCell", bundle: Bundle.main), forCellWithReuseIdentifier: NounMenuItemCell.cellId)
        return collection
    }()
    
    var itemClickHandler:((_ chargeModel: ChargeModel) -> ())?
    
    var selectedIndex: Int = 0
    var chargeModels: [ChargeModel]?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(tipsLabel)
        contentView.addSubview(collectionView)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModels(_ charges: [ChargeModel]) {
        chargeModels = charges
        collectionView.reloadData()
    }
    
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension NounMuneListCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chargeModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NounMenuItemCell.cellId, for: indexPath) as! NounMenuItemCell
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.layer.borderWidth = 0.8
        cell.contentView.layer.borderColor = UIColor(r: 244, g: 244, b: 244).cgColor
        if let models = chargeModels, models.count > indexPath.item {
            let model = models[indexPath.item]
            let price = String(format: "¥%.f", Double(model.price ?? "0.00") ?? 0.00)
            cell.priceLabel.attributedText = TextSpaceManager.configColorString(allString: price, attribStr: "¥", kAppDefaultTitleColor, UIFont.boldSystemFont(ofSize: 13))
            cell.timeLabel.text = model.title ?? ""
            cell.priceEach.text = model.description ?? ""
            if model.offer == nil || model.offer!.isEmpty {
                cell.welfareLable.isHidden = true
            } else {
                cell.welfareLable.isHidden = false
                cell.welfareLable.text = model.offer ?? ""
            }
            if indexPath.item == selectedIndex {
                cell.contentView.layer.borderColor = kAppDefaultColor.cgColor
            } else {
                cell.contentView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.item != selectedIndex {
            if let charges = chargeModels,charges.count > indexPath.item {
                selectedIndex = indexPath.item
                itemClickHandler?(charges[indexPath.item])
                collectionView.reloadData()
            }
        }
    }
    
}

// MARK: - Layout
private extension NounMuneListCell {
    
    func layoutPageSubviews() {
        layoutTipsLabel()
        layoutCollection()
    }
    
    func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(tipsLabel.snp.top)
        }
    }
    func layoutTipsLabel() {
        tipsLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-8)
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
    }
}
