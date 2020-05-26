//
//  PayTypeChoseCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/26.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class PayTypeChoseCell: UITableViewCell {
    
    static let cellId = "PayTypeChoseCell"
    
    private let customLayout: CustomFlowSingleLayout = {
        let layout = CustomFlowSingleLayout()
        layout.itemSize = CGSize(width: 110, height: 60)
        layout.sectionInset = UIEdgeInsets.init(top: 15, left: 20, bottom: 10, right:15)
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 60), collectionViewLayout: customLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        //collection.allowsSelection = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(PayTypeItemCell.classForCoder(), forCellWithReuseIdentifier: PayTypeItemCell.cellId)
        return collection
    }()
    var itemClickHandler:((_ currentModel: PayTypeModel) -> Void)?
    var currentIndex: Int = 0
    var payTypeList: [PayTypeModel]?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(collectionView)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModels(_ list: [PayTypeModel]?) {
        self.payTypeList = list
        if payTypeList != nil, payTypeList!.count > 0 {
            payTypeList![0].selected = true
        }
        collectionView.reloadData()
    }
    
    var payTypeSelectedHandler:((_ index: Int) -> Void)?
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PayTypeChoseCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return payTypeList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PayTypeItemCell.cellId, for: indexPath) as! PayTypeItemCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if currentIndex != indexPath.item {
            if payTypeList != nil && payTypeList!.count > indexPath.item {
                if (payTypeList![indexPath.item].status?.allowPay ?? false) == true { /// 可用才可点
                    payTypeList![currentIndex].selected = false
                    payTypeList![indexPath.item].selected = true
                    currentIndex = indexPath.item
                    collectionView.reloadData()
                    itemClickHandler?(payTypeList![indexPath.item])
                }
            }
        }
    }
    
}

// MARK: - Layout
private extension PayTypeChoseCell {
    private func layoutPageSubviews() {
        layoutCollection()
    }
    private func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}


