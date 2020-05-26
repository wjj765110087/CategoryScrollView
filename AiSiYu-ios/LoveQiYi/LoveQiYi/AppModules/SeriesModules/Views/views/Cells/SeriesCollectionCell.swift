//
//  SeriesCollectionCell.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/18.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

class SeriesCollectionCell: UICollectionViewCell {
    static let cellId = "SeriesCollectionCell"
    static let itemSize = CGSize(width: screenWidth, height: 0.414*(screenWidth-20) + 30)
    
    private let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PH")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let titleLab: UILabel = {
        let label = UILabel()
        label.text = "有她们俩在就无敌 高桥圣子"
        label.textColor = UIColor(r: 71, g: 71, b: 71)
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()

    private let timeLab: UILabel = {
        let label = UILabel()
        label.text = "03:26:22"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutPageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(model: SpecialSerialModel) {
        imgView.kfSetHorizontalImageWithUrl(model.cover_oss_filename)
        titleLab.text = model.title
        if let created_at = model.created_at {
            timeLab.text = String(format: "%@", created_at)
        }
    }
}

private extension SeriesCollectionCell {
    
    private func layoutPageView() {
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(20)
            make.bottom.equalTo(-5)
        }
        
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.bottom.equalTo(titleLab.snp.top).offset(-5)
        }
       
        imgView.addSubview(timeLab)
        timeLab.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10.5)
            make.bottom.equalTo(-11)
        }
    }
}
