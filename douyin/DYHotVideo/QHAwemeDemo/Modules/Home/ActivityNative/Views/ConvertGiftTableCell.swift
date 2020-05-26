//
//  ConvertGiftTableCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019-12-23.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class ConvertGiftTableCell: UITableViewCell {

    static let cellId = "ConvertGiftTableCell"
    static let cellHeight: CGFloat = 70.0
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    let giftIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 4
        image.layer.masksToBounds = true
        return image
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkText
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "5000元现金红包"
        return label
    }()
    let desLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 255, g: 72, b: 57)
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.text = "0个饺子可以兑换"
        return label
    }()
    lazy var convertButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.layer.cornerRadius = 15.0
        button.layer.masksToBounds = true
        button.setTitle("立即兑换", for: .normal)
        button.setTitle("道具不足", for: .disabled)
        button.setBackgroundImage(UIImage.imageFromColor(ConstValue.kTitleYelloColor, frame: CGRect(x: 0, y: 0, width: 75, height: 30)), for: .normal)
        button.setBackgroundImage(UIImage.imageFromColor(UIColor(white: 227/255.0, alpha: 1), frame: CGRect(x: 0, y: 0, width: 75, height: 30)), for: .disabled)
        button.addTarget(self, action: #selector(convertButtonClick), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    var convertActionHandler:(() ->Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(bgView)
        bgView.addSubview(giftIcon)
        bgView.addSubview(nameLabel)
        bgView.addSubview(desLabel)
        bgView.addSubview(convertButton)
        layoutPageSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func convertButtonClick() {
        convertActionHandler?()
    }
    
}


private extension ConvertGiftTableCell {
    func layoutPageSubviews() {
        layoutBgview()
        layoutConvertButton()
        layoutIconImage()
        layoutNamelabel()
        layoutDesLabeel()
    }
    func layoutBgview() {
        bgView.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.bottom.equalToSuperview()
        }
    }
    func layoutConvertButton() {
        convertButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(75)
            make.height.equalTo(30)
        }
    }
    func layoutIconImage() {
        giftIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(45)
        }
    }
    func layoutNamelabel() {
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(giftIcon.snp.trailing).offset(11)
            make.top.equalTo(giftIcon)
            make.height.equalTo(20)
            make.trailing.equalTo(convertButton.snp.leading).offset(-5)
        }
    }
    func layoutDesLabeel() {
        desLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(giftIcon)
            make.leading.equalTo(nameLabel)
            make.height.equalTo(20)
            make.trailing.equalTo(nameLabel)
        }
    }
}
