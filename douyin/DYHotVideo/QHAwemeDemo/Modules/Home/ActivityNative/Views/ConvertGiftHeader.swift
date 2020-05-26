//
//  ConvertGiftHeader.swift
//  QHAwemeDemo
//
//  Created by mac on 2019-12-23.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class ConvertGiftHeader: UIView {
    // 150 + (screenWidth-85)/5
    private let customLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width: CGFloat = 45
        layout.itemSize = CGSize(width: width, height: 70)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 80, height: 90), collectionViewLayout: customLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.allowsSelection = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(ConvertPropItemCell.classForCoder(), forCellWithReuseIdentifier: ConvertPropItemCell.cellId)
        return collection
    }()
    private var shadowLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 245, g: 245, b: 245)
        label.text = "PROPS"
        label.font = UIFont.systemFont(ofSize: 32)
        return label
    }()
    private var titLabel: UILabel = {
         let label = UILabel()
         label.textColor = UIColor.black
         label.text = "我的道具"
         label.font = UIFont.boldSystemFont(ofSize: 22)
         return label
     }()
    
    var itemClickHandler:((_ index: Int)->Void)?
    
    var propModels = [PropsModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(shadowLabel)
        addSubview(titLabel)
        addSubview(collectionView)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setModels(_ list: [PropsModel]) {
        propModels = list
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ConvertGiftHeader: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return propModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConvertPropItemCell.cellId, for: indexPath) as! ConvertPropItemCell
        let model = propModels[indexPath.item]
        cell.propImg.kfSetVerticalImageWithUrl(model.props_img)
        cell.numberLabel.text = "\(model.user_props_number ?? 0)个"
        let index = (model.props_id ?? 0)%4
        cell.propImg.backgroundColor = ConvertGiftsController.bgColors[index]
    
        return cell
    }
    
}

// MARK: - Layout
private extension ConvertGiftHeader {
    func layoutPageSubviews() {
        layoutShadowLabel()
        layoutTitLabel()
        layoutCollection()
    }
    func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titLabel.snp.bottom).offset(18)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    func layoutShadowLabel() {
        shadowLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-10)
            make.top.equalTo(15)
            make.height.equalTo(30)
        }
    }
    func layoutTitLabel() {
        titLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(30)
            make.trailing.equalTo(-10)
            make.height.equalTo(24)
        }
    }
}


class ConvertPropItemCell: UICollectionViewCell {
    
    static let cellId = "ConvertPropItemView"
    
    let propImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.layer.cornerRadius = 4.0
        img.layer.masksToBounds = true
        return img
    }()
    let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor(r: 255, g: 72, b: 57)
        label.textAlignment = .center
        label.text = "0个"
        return label
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        loadUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func loadUI() {
        backgroundColor = UIColor.clear
        addSubview(propImg)
        addSubview(numberLabel)
        layoutPageSubviews()
    }
  
    
}

private extension ConvertPropItemCell {
    func layoutPageSubviews() {
        layoutNumberPart()
    }
    func layoutNumberPart() {
        propImg.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalToSuperview()
            make.bottom.equalTo(-25)
        }
        numberLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(-5)
            make.height.equalTo(20)
        }
    }
    
}
