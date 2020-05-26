//
//  HistoryCell.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    static let cellId = "HistoryCell"
    
    private let customLayout: CustomFlowSingleLayout = {
        let layout = CustomFlowSingleLayout()
        layout.itemSize = VideoDoubleCollectionCell.itemSize
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: self.bounds, collectionViewLayout: customLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(UINib.init(nibName: "VideoDoubleCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: VideoDoubleCollectionCell.cellId)
        return collection
    }()
    
    var itemClickHandler:((_ index: Int) -> ())?
    
    var videoList = [VideoModel]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setModels(_ models: [VideoModel]) {
        videoList = models
//        if models.count == 0 {
//            NicooErrorView.showErrorMessage("暂无历史观看记录", on: contentView, customerTopMargin: 0, clickHandler: nil)
//        } else {
//            NicooErrorView.removeErrorMeesageFrom(contentView)
//        }
        collectionView.reloadData()
    }
    
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HistoryCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoDoubleCollectionCell.cellId, for: indexPath) as! VideoDoubleCollectionCell
        let model = videoList[indexPath.item]
        cell.setModel(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        itemClickHandler?(indexPath.item)
    }
    
}

// MARK: - Layout
private extension HistoryCell {
    
    func layoutPageSubviews() {
        layoutCollection()
    }
    
    func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
}
