//
//  HotDetailHeaderView.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/22.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

class HotDetailHeaderView: UIView {
    
    let videoPlayView: UIImageView = {
       let view = UIImageView()
        view.backgroundColor = UIColor.black
       view.isUserInteractionEnabled = true
       return view
    }()
    let authErrorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 11, g: 190, b: 6, a: 0.85)
        view.isHidden = true
        return view
        
    }()
    let authErrorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.text = "开通会员免费看片"
        return label
    }()
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("成为VIP会员", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = UIColor(red: 255/255.0, green: 105/255.0, blue: 27/255.0, alpha: 1)
        button.layer.cornerRadius = 17.5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(chargeButtonClick), for: .touchUpInside)
        return button
    }()

    var chargeActionHandler:(()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        addSubview(videoPlayView)
        addSubview(authErrorView)
        authErrorView.addSubview(authErrorLabel)
        authErrorView.addSubview(payButton)
        layoutPageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func chargeButtonClick() {
        chargeActionHandler?()
    }

    private func layoutPageView() {
        layoutVideoPlayView()
        layoutAuthView()
        layoutAutoLabel()
        layoutChargeButton()
        
    }
    
    private func layoutVideoPlayView() {
        videoPlayView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(statusBarHeight)
            make.height.equalTo(screenWidth*9/16)
        }
    }
    private func layoutAutoLabel() {
        authErrorLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-25)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
        }
    }
    private func layoutAuthView() {
        authErrorView.snp.makeConstraints { (make) in
            make.edges.equalTo(videoPlayView)
        }
    }
    private func layoutChargeButton() {
        payButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.centerY).offset(24)
            make.height.equalTo(35)
            make.width.equalTo(130)
        }
    }
    
}


class HeaderTipsView: UIView {
    private let tipsBgImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        image.image = UIImage(named: "detailTipsBar")
        image.backgroundColor = UIColor.clear
        image.isUserInteractionEnabled = true
        return image
    }()
    let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "新客专项！VIP月卡首月仅6元"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    private lazy var fakeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(adClcik), for: .touchUpInside)
        return button
    }()
    var adClickHandler:(() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview( tipsBgImage)
        addSubview(tipLabel)
        addSubview(fakeButton)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func adClcik() {
        adClickHandler?()
    }
    
    private func layoutPageSubviews() {
        tipsBgImage.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        tipLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(tipsBgImage)
        }
        fakeButton.snp.makeConstraints { (make) in
            make.edges.equalTo(tipsBgImage)
        }
    }
}
