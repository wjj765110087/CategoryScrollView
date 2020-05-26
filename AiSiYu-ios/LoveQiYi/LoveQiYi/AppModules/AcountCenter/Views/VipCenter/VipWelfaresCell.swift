//
//  VipWelfaresCell.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/18.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import UIKit

class VipWelfaresCell: UITableViewCell {

    static let cellId = "VipWelfaresCell"
    
    let tipsLabel: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.darkText
        lable.font = UIFont.boldSystemFont(ofSize: 17)
        lable.text = "会员特权"
        return lable
    }()
    private let flayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = VipWelfareItemCell.itemSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: self.bounds, collectionViewLayout: flayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.allowsSelection = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(VipWelfareItemCell.classForCoder(), forCellWithReuseIdentifier: VipWelfareItemCell.cellId)
        return collection
    }()
    
    var itemClickHandler:((_ index: Int) -> ())?
    var welfares: [VIPWelfareMune]?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(tipsLabel)
        contentView.addSubview(collectionView)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModels(_ models: [VIPWelfareMune]) {
        welfares = models
        collectionView.reloadData()
    }
    
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension VipWelfaresCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return welfares?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VipWelfareItemCell.cellId, for: indexPath) as! VipWelfareItemCell
        if let models = welfares, models.count > indexPath.item {
            let model = models[indexPath.item]
            cell.iconBtn.kfSetHeaderImageWithUrl(model.icon, placeHolder: UIImage(named: "PV"))
            cell.titlabel.text = "\(model.title ?? "")"
            cell.tipLabel.text = "\(model.sub_title ?? "")"
        }
        
        return cell
    }
    
}

// MARK: - Layout
private extension VipWelfaresCell {
    
    func layoutPageSubviews() {
        layoutTipsLabel()
        layoutCollection()
    }
    
    func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(tipsLabel.snp.bottom)
            make.bottom.equalTo(8)
        }
    }
    func layoutTipsLabel() {
        tipsLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-8)
            make.top.equalToSuperview()
            make.height.equalTo(40)
        }
    }
}


/// 会员特权 item
class VipWelfareItemCell: UICollectionViewCell {
    
    static let cellId = "VipWelfareItemCell"
    static let itemSize = CGSize(width: (screenWidth-40)/4, height: 100)
    
    let iconBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "PIc"), for: .normal)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 22.5
        button.layer.masksToBounds = true
        return button
    }()
    let titlabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.text = "专属线路"
        return label
    }()
    let tipLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = "5次/周"
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconBtn)
        contentView.addSubview(titlabel)
        contentView.addSubview(tipLabel)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - layout
private extension VipWelfareItemCell {
    
    func layoutPageSubviews() {
        layoutIconBtn()
        layoutTitlabel()
        layoutTipLabel()
    }
    func layoutIconBtn() {
        iconBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(5)
            make.width.height.equalTo(45)
        }
    }
    func layoutTitlabel() {
        titlabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconBtn.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
    }
    func layoutTipLabel() {
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titlabel.snp.bottom)
            make.height.equalTo(20)
        }
    }
}
