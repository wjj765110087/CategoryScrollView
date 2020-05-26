//
//  ShareContenView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/2.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class ShareContenView: UIView {

    let titleLab: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "选择分享内容 (点击分享)"
        return label
    }()
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "shareColose"), for: .normal)
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        return button
    }()
    private let customLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = ShareContentItemCell.itemSize
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 65, height: 90), collectionViewLayout: customLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(ShareContentItemCell.classForCoder(), forCellWithReuseIdentifier: ShareContentItemCell.cellId)
        collection.register(UINib(nibName: ShareImageItemCell.cellId, bundle: Bundle.main), forCellWithReuseIdentifier: ShareImageItemCell.cellId)
        return collection
    }()
    private lazy var copyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("复制链接", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor =  ConstValue.kViewLightColor
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("保存图片", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor =  ConstValue.kViewLightColor
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        return button
    }()
    var itemClickHandler:((_ index: Int)->Void)?
    var closebtnClickHadnler:(()->Void)?
    
    var shareModels = [ShareTypeItemModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(r: 15, g: 15, b: 29)
        addSubview(copyButton)
        addSubview(saveButton)
        addSubview(collectionView)
        addSubview(titleLab)
        addSubview(closeButton)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func buttonClick(_ sender: UIButton) {
        if sender == closeButton {
            closebtnClickHadnler?()
        } else if sender == copyButton {
            UIPasteboard.general.string = String(format: "%@", ShareContentItemCell.getDefaultContentString())
            XSAlert.show(type: .success, text: "复制成功！")
        } else if sender == saveButton {
            itemClickHandler?(1)
        }
    }
    
    func setShareModels(_ models: [ShareTypeItemModel]) {
        shareModels = models
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ShareContenView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shareModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let model = shareModels[indexPath.item]
        if model.type == .picture {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShareImageItemCell.cellId, for: indexPath) as! ShareImageItemCell
            cell.setShareTypeModel(model)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShareContentItemCell.cellId, for: indexPath) as! ShareContentItemCell
            cell.setShareTypeModel(model)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        itemClickHandler?(indexPath.item)
    }
    
}

// MARK: - Layout
private extension ShareContenView {
    func layoutPageSubviews() {
        layoutCopyButton()
        layoutSaveButton()
        layoutTitleLab()
        layoutCollection()
        layoutMoreButton()
    }
    func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(copyButton.snp.top).offset(-22)
            make.top.equalTo(titleLab.snp.bottom).offset(10)
        }
    }
    func layoutTitleLab() {
        titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.leading.equalTo(45)
            make.trailing.equalTo(-45)
            make.height.equalTo(45)
        }
    }
    func layoutMoreButton() {
        closeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLab)
            make.trailing.equalTo(-15)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
    }
    func layoutCopyButton() {
        copyButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(UIDevice.current.isiPhoneXSeriesDevices() ? -54 : -20)
            make.leading.equalTo(20)
            make.trailing.equalTo(self.snp.centerX).offset(-12)
            make.height.equalTo(40)
        }
    }
    func layoutSaveButton() {
        saveButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-20)
            make.leading.equalTo(self.snp.centerX).offset(12)
            make.centerY.equalTo(copyButton)
            make.height.equalTo(40)
        }
    }
    
}
