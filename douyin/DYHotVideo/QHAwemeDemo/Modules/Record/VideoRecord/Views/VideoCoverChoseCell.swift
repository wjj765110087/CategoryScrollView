//
//  VideoCoverChoseCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/25.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class VideoCoverChoseCell: UICollectionViewCell {
    static let cellId = "VideoCoverChoseCell"
    let imageCover: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.layer.cornerRadius = 3
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        return image
    }()
    lazy var fakeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage.imageFromColor(UIColor(white: 0.0, alpha: 0.6), frame: CGRect(x: 0, y: 0, width: 90, height:160)), for: .normal)
        button.setBackgroundImage(UIImage.imageFromColor(UIColor.clear, frame: CGRect(x: 0, y: 0, width: 90, height:160)), for: .selected)
        button.addTarget(self, action: #selector(justThisCover(_:)), for: .touchUpInside)
        return button
    }()
    
    var coverClickHandler:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(imageCover)
        contentView.addSubview(fakeButton)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func justThisCover(_ sender: UIButton) {
        coverClickHandler?()
    }
    
}

// MARK: - Layout
private extension VideoCoverChoseCell {
    
    func layoutPageSubviews() {
        layoutImageCover()
        layoutFakeButton()
    }
    
    func layoutImageCover() {
        imageCover.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(2.5)
            make.trailing.equalTo(-2.5)
        }
    }
    
    func layoutFakeButton() {
        fakeButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(2.5)
            make.trailing.equalTo(-2.5)
        }
    }
}
