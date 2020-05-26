//
//  PhotoBrowerCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/5/16.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class PhotoBrowerCell: UICollectionViewCell {
    
    static let cellId = "PhotoBrowerCell"
    
    var imageV: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.backgroundColor = UIColor.clear
        img.image = UIImage(named: "inviteImageBg.png")
        return img
    }()
    var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    lazy var downLoadBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "download_N"), for: .normal)
        button.addTarget(self, action: #selector(longPress(_:)), for: .touchUpInside)
        return button
    }()
    var imageLongPressAction:(() -> ())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(imageV)
        contentView.addSubview(countLabel)
        contentView.addSubview(downLoadBtn)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func longPress(_ sender: UIButton) {
        imageLongPressAction?()
    }
    
}

private extension PhotoBrowerCell {
    
    func layoutPageSubviews() {
        layoutImg()
        layoutCountlab()
        layoutDownLoadBtn()
    }
    
    func layoutImg() {
        imageV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func layoutCountlab() {
        countLabel.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(30)
            } else {
                make.top.equalTo(30)
            }
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    func layoutDownLoadBtn() {
        downLoadBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-25)
            make.centerY.equalTo(countLabel)
            make.height.width.equalTo(40)
        }
    }
}
