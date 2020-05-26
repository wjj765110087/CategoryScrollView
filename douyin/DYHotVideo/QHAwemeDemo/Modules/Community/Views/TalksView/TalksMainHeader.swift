//
//  TalksMainHeader.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/1.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class TalksMainHeader: UIView {

    let introlLab: CustomLabel = {
        let label = CustomLabel()
        label.textColor = UIColor.white
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 13)
        label.verticalAlignment = .bottom
        return label
    }()
    let moreImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "moreIntrol"))
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(moreButtonClick), for: .touchUpInside)
        return button
    }()
    
    var moreIntroClickHandler:(()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(introlLab)
        addSubview(moreImage)
        addSubview(moreButton)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func moreButtonClick() {
        moreIntroClickHandler?()
    }

}

// MARK: - Layout
private extension TalksMainHeader {
    func layoutPageSubviews() {
        layoutIntrolLab()
        layoutMoreButton()
        layoutMoreImage()
    }
    func layoutMoreImage() {
        moreImage.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10)
            make.bottom.equalTo(-15)
            make.width.equalTo(6)
            make.height.equalTo(10)
        }
    }
    func layoutIntrolLab() {
        introlLab.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.bottom.equalTo(-15)
            make.trailing.equalTo(moreImage.snp.leading).offset(-10)
        }
    }
    func layoutMoreButton() {
        moreButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
