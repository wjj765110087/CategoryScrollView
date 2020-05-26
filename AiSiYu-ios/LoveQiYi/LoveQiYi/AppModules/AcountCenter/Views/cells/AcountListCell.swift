//
//  AcountListCell.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import UIKit

class AcountListCell: UITableViewCell {

    static let cellId = "AcountListCell"
    
    let imageIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    let titleLab: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)
        self.selectedBackgroundView = view
        self.accessoryType = .disclosureIndicator
        contentView.addSubview(imageIcon)
        contentView.addSubview(titleLab)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Layout
private extension AcountListCell {
    
    func layoutPageSubviews() {
        layoutImageIcon()
        layoutTitleLabel()
    }
    func layoutImageIcon() {
        imageIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(34)
        }
    }
    func layoutTitleLabel() {
        titleLab.snp.makeConstraints { (make) in
            make.leading.equalTo(imageIcon.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }
}
