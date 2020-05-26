//
//  AcountVideoCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class AcountVideoCell: UICollectionViewCell {
    
    static let cellId = "AcountVideoCell"
    
    var coverPath: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.isUserInteractionEnabled = true
        return img
    }()
    var collectionBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "zanNormal"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    }()
    var coinLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 10)
        lable.textColor = UIColor.white
        lable.textAlignment = .center
        lable.backgroundColor = UIColor(r: 255, g: 42, b: 49)
        lable.layer.cornerRadius = 3
        lable.layer.masksToBounds = true
        return lable
    }()
    let progressCover: UILabel = {
        let label = UILabel()
        label.textColor = ConstValue.kTitleYelloColor
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.isHidden = true
        return label
    }()
    var statuImage: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.isHidden = true
        img.contentMode = .scaleAspectFit
        img.isUserInteractionEnabled = true
        img.image = UIImage(named: "shenhezhong")
        return img
    }()
    lazy var deleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "deleteWorkBtn"), for: .normal)
        button.addTarget(self, action: #selector(deleteWork), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    var deleteActionHandler:(() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.black
        contentView.addSubview(coverPath)
        contentView.addSubview(progressCover)
        contentView.addSubview(collectionBtn)
        contentView.addSubview(statuImage)
        contentView.addSubview(deleButton)
        contentView.addSubview(coinLable)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func deleteWork() {
        deleteActionHandler?()
    }
    
    func setProgress(_ progress: Double) {
        progressCover.snp.updateConstraints { (make) in
            make.height.equalTo(WorkVideosController.videoItemHieght * CGFloat(progress))
        }
        progressCover.text = String(format: "上传中%.f%@", Float(progress * 100.0), "%")
    }
    
    func setCoverMsg(_ msg: String) {
        progressCover.snp.updateConstraints { (make) in
            make.height.equalTo(WorkVideosController.videoItemHieght)
        }
        progressCover.text = "\(msg)"
    }
    
    func setVideoWordsSuccess(_ isSucceedWork: Bool) {
        collectionBtn.isHidden = !isSucceedWork
    }
    func showCoinTips(_ isCoinVideo: Bool) {
        coinLable.isHidden = !isCoinVideo
    }
    
}

// MARK: - Layout
private extension AcountVideoCell {
    
    func layoutPageSubviews() {
        layoutCoverPath()
        layoutCoverProgress()
        layoutCollectionBtn()
        layoutDeleteBtn()
        layoutStatuImage()
        layoutCoinLabel()
    }
    
    func layoutCoverPath() {
        coverPath.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func layoutCoverProgress() {
        progressCover.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(coverPath)
            make.height.equalTo(0)
        }
    }
    
    func layoutCollectionBtn() {
        collectionBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(5)
            make.bottom.equalTo(-5)
            make.height.equalTo(20)
        }
    }
    
    func layoutStatuImage() {
        statuImage.snp.makeConstraints { (make) in
            make.trailing.equalTo(-8)
            make.top.equalTo(8)
            make.width.height.equalTo(20)
        }
    }
    
    func layoutDeleteBtn() {
        deleButton.snp.makeConstraints { (make) in
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
    }
    func layoutCoinLabel() {
        coinLable.snp.makeConstraints { (make) in
            make.trailing.equalTo(-5)
            make.top.equalTo(5)
            make.height.equalTo(18)
            make.width.equalTo(40)
        }
    }
    
}
