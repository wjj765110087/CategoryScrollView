//
//  CateChoseItemView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/2.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class CateChoseItemView: UIView {
    
    var lineTop: UIView = {
        let view = UIView()
        view.backgroundColor = ConstValue.kAppSepLineColor
        return view
    }()
    var lineBottom: UIView = {
        let view = UIView()
        view.backgroundColor = ConstValue.kAppSepLineColor
        return view
    }()
    var iconImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "PushTipsIcon")
        image.isUserInteractionEnabled = true
        return image
    }()
    var arrowImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "PusharrowRight")
        image.isUserInteractionEnabled = true
        return image
    }()
    let titleLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.text = "选择分类"
        return lable
    }()
    let tipsLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor(r: 59, g: 57, b: 73)
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.text = "参与话题,让更多人看到"
        return lable
    }()
    lazy var fakeChoseBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.imageFromColor(UIColor(red: 56/255.0, green: 59/255.0, blue: 71/255.0, alpha: 0.99), frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 48)), for: .highlighted)
        button.addTarget(self, action: #selector(choseActionClick), for: .touchUpInside)
        return button
    }()
    
    var itemClickHandler:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(lineTop)
        addSubview(lineBottom)
        addSubview(fakeChoseBtn)
        addSubview(iconImage)
        addSubview(titleLable)
        addSubview(arrowImage)
        addSubview(tipsLable)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func choseActionClick() {
        itemClickHandler?()
    }

}

// MARK: - layout
private extension CateChoseItemView {
    func layoutPageSubviews() {
        layoutTopBottomLine()
        layoutImageIcon()
        layoutTitleLabel()
        layoutRightArrowImage()
        layoutTipsLabel()
        layoutFakeBUtton()
    }
    func layoutImageIcon() {
        iconImage.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(15)
        }
    }
    func layoutTitleLabel() {
        titleLable.snp.makeConstraints { (make) in
            make.leading.equalTo(iconImage.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }
    func layoutRightArrowImage() {
        arrowImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-15)
            make.width.equalTo(6)
            make.height.equalTo(10)
        }
    }
    func layoutTipsLabel() {
        tipsLable.snp.makeConstraints { (make) in
            make.trailing.equalTo(arrowImage.snp.leading).offset(-5)
            make.centerY.equalToSuperview()
        }
    }
    func layoutFakeBUtton() {
        fakeChoseBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    func layoutTopBottomLine() {
        lineTop.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        lineBottom.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}


class PushVideoLicenceView: UIView {

    let tipsLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor(white: 153/255, alpha: 1)
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.numberOfLines = 0
        let title = "\r1.何为原创视频（符合一条即可）\r   (1) 视频内带有抖阴、5dy.me等字样写在卡片、纸张上\r   (2) 视频内带有抖阴官方手势（中指叠在食指上）\r2.金币收入支持提现（支付宝、银行转账)"
        let attributedString = NSMutableAttributedString(string: title, attributes: [
            .font: UIFont(name: "PingFang-SC-Medium", size: 13.0)!,
            .foregroundColor: UIColor.init(r: 153, g: 153, b: 153)
            ])
        let paragraphStye = NSMutableParagraphStyle()
        //调整行间距
        paragraphStye.lineSpacing = 5.0
        let rang = NSMakeRange(0, CFStringGetLength(title as CFString?))
        attributedString.addAttribute(.paragraphStyle, value: paragraphStye, range: rang)
        attributedString.addAttribute(.foregroundColor, value: ConstValue.kTitleYelloColor, range: NSRange(location: 69, length: 9))
        lable.attributedText = attributedString
//        lable.attributedText = TextSpaceManager.getAttributeStringWithString("金币收费视频必须为原创视频，否则一律改为非付费视频发布后请在作品查看审核进度，审核通过后才能被别人看到", lineSpace: 5)
        return lable
    }()
    lazy var licenseChoseBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "shareItemUnS"), for: .normal)
        button.setImage(UIImage(named: "shareItemS"), for: .selected)
        button.addTarget(self, action: #selector(choseActionClick), for: .touchUpInside)
        button.isSelected = true
        return button
    }()
    lazy var licenseBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setAttributedTitle(NSAttributedString.init(string: "已经阅读并同意《抖阴视频上传规则》", attributes: [NSAttributedString.Key.underlineColor: ConstValue.kTitleYelloColor, NSAttributedString.Key.underlineStyle: 1, NSAttributedString.Key.foregroundColor: ConstValue.kTitleYelloColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]), for: .normal)
        button.addTarget(self, action: #selector(choseActionClick), for: .touchUpInside)
        return button
    }()
    
    var gestureImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "gesture")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var licenseClickHandler:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(tipsLable)
        addSubview(licenseChoseBtn)
        addSubview(licenseBtn)
        addSubview(gestureImage)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func choseActionClick(_ sender: UIButton) {
        if sender == licenseChoseBtn {
            sender.isSelected = !sender.isSelected
        } else {
             licenseClickHandler?()
        }
    }
    
}

// MARK: - layout
private extension PushVideoLicenceView {
    func layoutPageSubviews() {
        layoutLicenseChosetton()
        layoutLicenseButton()
        layoutTipsLabel()
        layoutGestureImageView()
    }
    func layoutTipsLabel() {
        tipsLable.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.bottom.equalTo(licenseChoseBtn.snp.top).offset(-5)
        }
    }
    func layoutLicenseChosetton() {
        licenseChoseBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.width.height.equalTo(20)
            make.bottom.equalTo(-10)
        }
    }
    func layoutLicenseButton() {
        licenseBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(licenseChoseBtn)
            make.leading.equalTo(licenseChoseBtn.snp.trailing).offset(5)
        }
    }
    func layoutGestureImageView() {
        gestureImage.snp.makeConstraints { (make) in
            make.bottom.equalTo(tipsLable.snp.bottom)
            make.trailing.equalTo(-35)
            make.height.equalTo(38)
            make.width.equalTo(25)
        }
    }
}
