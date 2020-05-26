//
//  MsgCenterMainCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/15.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class MsgCenterMainCell: UITableViewCell {
    
    static let cellId = "MsgCenterMainCell"
    
    let iconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    let titleLab: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 15)
        return lable
    }()
    let textsLab: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.lightGray
        lable.font = UIFont.systemFont(ofSize: 12)
        return lable
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.accessoryType = .disclosureIndicator
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 80))
        view.backgroundColor = UIColor.darkGray
        selectedBackgroundView = view
        setUpSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpSubViews() {
        contentView.addSubview(iconImage)
        contentView.addSubview(titleLab)
        contentView.addSubview(textsLab)
        layoutPageSubviews()
    }

}

// MARK: - Layout
private extension MsgCenterMainCell {
    
    func layoutPageSubviews() {
        layoutIconImage()
        layoutTitleLable()
        layoutTestsLable()
    }
    
    func layoutIconImage() {
        iconImage.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48)
        }
    }
    
    func layoutTitleLable() {
        titleLab.snp.makeConstraints { (make) in
            make.leading.equalTo(iconImage.snp.trailing).offset(15)
            make.top.equalTo(iconImage)
            make.height.equalTo(20)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    func layoutTestsLable() {
        textsLab.snp.makeConstraints { (make) in
            make.leading.equalTo(iconImage.snp.trailing).offset(15)
            make.bottom.equalTo(iconImage)
            make.height.equalTo(20)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
}
