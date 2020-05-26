//
//  PhotoChoseView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/18.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit


class PhotoChoseView: UIView {

    private let customLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 6
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }()
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 120), collectionViewLayout: customLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(PhotoItemCell.classForCoder(), forCellWithReuseIdentifier: PhotoItemCell.cellId)
        return collection
    }()
    var pictures = [UIImage]()
    var maxCount = 3
    
    var addPictureAction:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        layoutCollection()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPictures(_ pics: [UIImage]) {
        pictures = pics
        collectionView.reloadData()
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PhotoChoseView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count < maxCount ? pictures.count + 1 : pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoItemCell.cellId, for: indexPath) as! PhotoItemCell
        if indexPath.row < pictures.count {
            let picture = pictures[indexPath.row]
            cell.photoImage.image = picture
            cell.deleteBtn.isHidden = false
        } else {
            cell.photoImage.image = UIImage(named: "addPhotoImage")
            cell.deleteBtn.isHidden = true
        }
        cell.deleteImageAction = { [weak self] in
            self?.pictures.remove(at: indexPath.row)
            self?.collectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.row == pictures.count  {
            // 点击了添加
            if pictures.count < maxCount {
                addPictureAction?()
            } else {
                XSAlert.show(type: .error, text: "最多添加\(maxCount)个图片")
            }
        } else {
            let dataSource = JXLocalDataSource(numberOfItems: {
                // 共有多少项
                return self.pictures.count
            }, localImage: { index -> UIImage? in
                // 每一项的图片对象
                return self.pictures[index]
            })
            JXPhotoBrowser(dataSource: dataSource).show(pageIndex: indexPath.item)
        }
    }
    
}

// MARK: - Layout
private extension PhotoChoseView {
    
    private func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}


/// Picture Cell
class PhotoItemCell: UICollectionViewCell {
    
    static let cellId = "PhotoItemCell"
    
    var photoImage: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 3
        image.layer.masksToBounds = true
        return image
    }()
    lazy var deleteBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.red
        button.setImage(UIImage(named: "deletePicture"), for: .normal)
        button.addTarget(self, action: #selector(deleteBtnClick), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    let gigTipsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "gif"
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()
    var deleteImageAction:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        contentView.addSubview(photoImage)
        contentView.addSubview(deleteBtn)
        contentView.addSubview(gigTipsLabel)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func deleteBtnClick() {
        deleteImageAction?()
    }
}

private extension PhotoItemCell {
    func layoutPageSubviews() {
        photoImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        deleteBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.width.equalTo(16)
        }
        gigTipsLabel.snp.makeConstraints { (make) in
            make.leading.bottom.equalToSuperview()
            make.height.equalTo(18)
            make.width.equalTo(25)
        }
    }
}
