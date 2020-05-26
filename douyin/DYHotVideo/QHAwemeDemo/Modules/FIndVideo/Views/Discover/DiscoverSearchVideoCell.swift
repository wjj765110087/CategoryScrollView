//
//  DiscoverSearchVideoCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/7.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class DiscoverSearchVideoCell: UICollectionViewCell {
    
    static let cellId = "DiscoverSearchVideoCell"
    static let itemSize = CGSize(width: (screenWidth - 30)/2, height: (screenWidth - 30)/2 * 202/172)
    
    private lazy var coinLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = UIColor.init(r: 251, g: 2, b: 36)
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PH")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 3
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var titleLab: UILabel = {
        let titleLab = UILabel()
        titleLab.text = ""
        titleLab.font = UIFont.systemFont(ofSize: 13)
        titleLab.textAlignment = .left
        titleLab.textColor = .white
        return titleLab
    }()
    
    private lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView()
        avatarImage.layer.cornerRadius = 9.5
        avatarImage.layer.masksToBounds = true
        avatarImage.image = ConstValue.kDefaultHeader
        return avatarImage
    }()
    
    private lazy var nickNameLab: UILabel = {
        let titleLab = UILabel()
        titleLab.text = ""
        titleLab.font = UIFont.systemFont(ofSize: 11)
        titleLab.textColor = .white
        return titleLab
    }()
    
    private lazy var zanImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zanNormal")
        return imageView
    }()
    
    private lazy var zanCountLab: UILabel = {
        let titleLab = UILabel()
        titleLab.text = "0"
        titleLab.font = UIFont.systemFont(ofSize: 11)
        titleLab.textColor = .white
        return titleLab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imgView)
        contentView.addSubview(titleLab)
        contentView.addSubview(avatarImage)
        contentView.addSubview(nickNameLab)
        contentView.addSubview(zanImgView)
        contentView.addSubview(zanCountLab)
        contentView.addSubview(coinLabel)
        layoutPageViews()
    }
    
    func setModel(model: VideoModel) {
        if let isCoins = model.is_coins, isCoins == 1 {
            if let coins = model.coins {
                if coins > 0 {
                    coinLabel.text = "\(coins)金币"
                    coinLabel.isHidden = false
                } else if coins == 0 {
                    coinLabel.isHidden = true
                }
            }
        } else {
            coinLabel.isHidden = true
        }
    
        let userDefaultHeader = UserModel.share().getUserHeader(model.user?.id)
        imgView.kfSetVerticalImageWithUrl(model.cover_path)
        titleLab.text = model.title ?? ""
        avatarImage.kfSetHeaderImageWithUrl(model.user?.cover_path, placeHolder: userDefaultHeader)
        nickNameLab.text = model.user?.nikename ?? ""
        zanCountLab.text = getStringWithNumber(model.recommend_count ?? 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: -Layout
private extension DiscoverSearchVideoCell {
    
    func layoutPageViews() {
        layoutImageView()
        layoutAvatarImage()
        layoutNickNameLabel()
        layoutzanCountLab()
        layoutZanImage()
        layoutTitleLabel()
        layoutCoinLabel()
    }
    
    func layoutImageView() {
        imgView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.top.equalToSuperview()
        }
    }
    
    func layoutAvatarImage() {
        avatarImage.snp.makeConstraints { (make) in
            make.leading.equalTo(7)
            make.width.height.equalTo(19)
            make.bottom.equalTo(-8)
        }
    }
    
    func layoutNickNameLabel() {
        nickNameLab.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarImage.snp.trailing).offset(4)
            make.centerY.equalTo(avatarImage.snp.centerY)
        }
    }
    
    func layoutzanCountLab() {
        zanCountLab.snp.makeConstraints { (make) in
            make.trailing.equalTo(-7.5)
            make.centerY.equalTo(avatarImage.snp.centerY)
        }
    }
    
    func layoutZanImage() {
        zanImgView.snp.makeConstraints { (make) in
            make.trailing.equalTo(zanCountLab.snp.leading).offset(-4)
            make.width.height.equalTo(10.5)
            make.centerY.equalTo(avatarImage.snp.centerY)
        }
    }
    
    func layoutTitleLabel() {
        titleLab.snp.makeConstraints { (make) in
            make.leading.equalTo(7)
            make.bottom.equalTo(avatarImage.snp.top).offset(-7)
            make.trailing.equalTo(-7)
        }
    }
    
    func layoutCoinLabel() {
        coinLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(9.5)
            make.bottom.equalTo(titleLab.snp.top).offset(-6)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
    }

}
