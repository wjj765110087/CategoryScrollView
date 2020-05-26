//
//  CommunityImagesView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/9/30.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class CommunityImagesView: UIView {
    
    private let customLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let w = (ConstValue.kScreenWdith - 40)/3
        layout.itemSize = CGSize(width: w, height: w)
        layout.minimumInteritemSpacing = 2.5   // 水平最小间距
        layout.minimumLineSpacing = 5          // 垂直最小间距
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)// 边距
        // layout.
        return layout
    }()
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 120), collectionViewLayout: customLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(PhotoImageCell.classForCoder(), forCellWithReuseIdentifier: PhotoImageCell.cellId)
        return collection
    }()
    var pictures = [String]()
    var maxCount = 3
    
    var clickPictureAction:((_ index: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        layoutCollection()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPictures(_ pics: [String]) {
        pictures = pics
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CommunityImagesView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoImageCell.cellId, for: indexPath) as! PhotoImageCell
        cell.photoImage.kfSetVerticalImageWithUrl(pictures[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        clickPictureAction?(indexPath.item)
    }
    
}

// MARK: - Layout
private extension CommunityImagesView {
    private func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}


/// Picture Cell
class PhotoImageCell: UICollectionViewCell {
    
    static let cellId = "PhotoImageCell"
    
    var photoImage: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 3
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        return image
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        contentView.addSubview(photoImage)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PhotoImageCell {
    func layoutPageSubviews() {
        photoImage.snp.makeConstraints { (make) in
            make.leading.top.equalTo(0)
            make.bottom.trailing.equalTo(0)
        }
    }
}
