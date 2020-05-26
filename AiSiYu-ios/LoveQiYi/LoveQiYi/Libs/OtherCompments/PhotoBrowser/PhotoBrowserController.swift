//
//  PhotoBrowserController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/5/16.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import Photos

class PhotoBrowserController: UIViewController {

    private let layoutFlow: PhotoBrowerLayout = {
        let layout = PhotoBrowerLayout()
        layout.itemSize = CGSize(width: screenWidth, height: screenHeight)
        return layout
    }()
    private lazy var collectionScroll: UICollectionView = {
        let collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layoutFlow)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.clear
        collection.showsVerticalScrollIndicator = false
       
        collection.register(PhotoBrowerCell.classForCoder(), forCellWithReuseIdentifier: PhotoBrowerCell.cellId)
        //collection.mj_footer = loadMoreView

        return collection
    }()
    var currentIndex: Int = 0
    var imageUrlSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.addSubview(collectionScroll)
        layoutPageSubviews()
        if currentIndex < imageUrlSource.count {
            collectionScroll.scrollToItem(at: IndexPath.init(item: currentIndex, section: 0), at: .left, animated: false)
        }
    }
    
    private func alertForSuccess(_ msg: String) {
        let alert = UIAlertController.init(title: nil, message: msg, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "知道了", style: .default) { (action) in
            
        }
        alert.addAction(action)
        self.present(alert, animated: false, completion: nil)
    }
    
    private func actionForDownload(_ index: Int) {
        DispatchQueue.global().async {
            if let url = URL(string: self.imageUrlSource[index]), let data = try? Data.init(contentsOf: url) {
                if let img = UIImage(data: data) {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAsset(from: img)
                    }) { (isSuccess: Bool, error: Error?) in
                        if isSuccess {
                            DLog("保存成功：")
                            DispatchQueue.main.async {
                                self.alertForSuccess("保存成功")
                            }
                        } else{
                            DLog("保存失败：", file: error!.localizedDescription)
                            DispatchQueue.main.async {
                                self.alertForSuccess("保存失败")
                            }
                        }
                    }
                }
            }
        }
        
        
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PhotoBrowserController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrlSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellForRow(with: indexPath)
        return cell
    }
    
    /// 配置cell
    func cellForRow(with indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionScroll.dequeueReusableCell(withReuseIdentifier: PhotoBrowerCell.cellId, for: indexPath) as! PhotoBrowerCell
        cell.imageV.kfSetVerticalImageWithUrl(imageUrlSource[indexPath.row])
        cell.countLabel.text = "\(indexPath.item + 1)/\(imageUrlSource.count)"
        cell.imageLongPressAction = { [weak self] in
            self?.actionForDownload(indexPath.item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: - Layout
private extension PhotoBrowserController {
    
    func layoutPageSubviews() {
        layoutCollectionScroll()
    }
    
    
    func layoutCollectionScroll() {
        collectionScroll.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
