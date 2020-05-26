//
//  ConvertSectionTitleCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019-12-23.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class ConvertSectionTitleCell: UITableViewCell {
    
    static let cellId = "ConvertSectionTitleCell"
    static let headerHeight: CGFloat = 90.0
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    let conrnerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "兑换区"
        return label
    }()
    let shadowLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = UIColor(r: 245, g: 245, b: 245)
        label.text = "PROPS"
        return label
    }()
    let desLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 255, g: 72, b: 57)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "已拥有: 0个"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
       
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(bgView)
        contentView.addSubview(conrnerView)
        bgView.addSubview(shadowLabel)
        bgView.addSubview(titleLabel)
        bgView.addSubview(desLabel)
        layoutPageViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ConvertSectionTitleCell {
    
    func layoutPageViews() {
        layoutBgView()
        layoutShadowLabel()
        layoutTitleLabel()
        layoutDesLabel()
    }
    func layoutBgView() {
        bgView.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.bottom.equalToSuperview()
        }
        conrnerView.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(bgView)
            make.height.equalTo(6)
        }
    }
    
    func layoutTitleLabel() {
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(32.5)
        }
    }

    func layoutDesLabel() {
        desLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
        }
    }
    func layoutShadowLabel() {
        shadowLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-10)
            make.height.equalTo(30)
            make.top.equalTo(18)
        }
    }
    
}


class ConvertSectionFooter: UITableViewHeaderFooterView {
    
    static let reuseId = "ConvertSectionFooter"
    static let footerHeight: CGFloat = 20.0
    
    private let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 4.0
        view.layer.masksToBounds = true
        return view
    }()
     private let conerView: UIView = {
           let view = UIView()
           view.backgroundColor = UIColor.white
        
           return view
       }()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(r: 244, g: 244, b: 244)
        contentView.backgroundColor = UIColor(r: 244, g: 244, b: 244)
        contentView.addSubview(whiteView)
        contentView.addSubview(conerView)
        layoutPageViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Layout
private extension ConvertSectionFooter {
    
    func layoutPageViews() {
        layoutShotLineView()
        layoutSpreadOutLabel()
    }
    
    func layoutShotLineView() {
        whiteView.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalToSuperview()
            make.height.equalTo(10)
            make.trailing.equalTo(-10)
        }
    }
    
    func layoutSpreadOutLabel() {
        conerView.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(whiteView)
            make.top.equalTo(whiteView)
            make.height.equalTo(6)
        }
    }
    
}

