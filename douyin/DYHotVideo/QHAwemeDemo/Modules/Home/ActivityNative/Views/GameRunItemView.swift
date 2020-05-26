//
//  GameRunItemView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019-12-20.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class GameRunItemView: UIButton {

    let lightImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "game_RunHLItem")
        image.isHidden = true
        return image
    }()
    let pictureBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "babyGame"), for: .normal)
        return button
    }()
    let beiLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.text = "X2"
        return label
    }()
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    func initUI() {
        backgroundColor = UIColor.clear
        addSubview(lightImage)
        addSubview(pictureBtn)
        addSubview(beiLabel)
        layoutPageSubviews()
    }
    
    func layoutPageSubviews() {
        lightImage.snp.makeConstraints { (make) in
            make.leading.equalTo(-2)
            make.trailing.equalTo(2)
            make.top.equalTo(-2)
            make.bottom.equalTo(2)
        }
        pictureBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(5)
            make.trailing.equalTo(-5)
            make.top.equalTo(5)
            make.bottom.equalTo(-16)
        }
        beiLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-3)
            make.top.equalTo(pictureBtn.snp.bottom).offset(-3)
        }
    }
    
}

