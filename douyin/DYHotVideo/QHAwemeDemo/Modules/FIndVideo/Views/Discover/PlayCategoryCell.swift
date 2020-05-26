//
//  PlayCategoryCell.swift
//  YUEPAO
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//  类别cell

import UIKit

class PlayCategoryCell: UICollectionViewCell {
    
    static let cellId = "PlayCategoryCell"
    static let itemSize = CGSize(width: (screenWidth - 25)/2, height: (screenWidth - 25)/2 * 202/162)
    
    private lazy var imgView: UIImageView = {
       let imageView = UIImageView()
       imageView.image = UIImage(named: "PH")
       imageView.contentMode = .scaleAspectFill
       imageView.clipsToBounds = true
       imageView.layer.cornerRadius = 5
       imageView.layer.masksToBounds = true
       imageView.backgroundColor = .red
       return imageView
    }()
    
    private lazy var titleLab: UILabel = {
        let titleLab = UILabel()
        titleLab.text = "----"
        titleLab.font = UIFont.systemFont(ofSize: 14)
        titleLab.textAlignment = .center
        titleLab.textColor = .white
        return titleLab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imgView)
        contentView.addSubview(titleLab)
        layoutPageViews()
    }
    
    func setModel(model: FindVideoModel) {
        titleLab.text = model.keys_title ?? ""
        imgView.kfSetVerticalImageWithUrl(model.keys_cover ?? "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension PlayCategoryCell {
    
    func layoutPageViews() {
        layoutImageView()
        layoutTitleLabel()
    }
   
    func layoutImageView() {
        imgView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.top.equalToSuperview()
        }
    }
    
    func layoutTitleLabel() {
        titleLab.snp.makeConstraints { (make) in
            make.leading.equalTo(14)
            make.bottom.equalTo(-11)
        }
    }
    
}
