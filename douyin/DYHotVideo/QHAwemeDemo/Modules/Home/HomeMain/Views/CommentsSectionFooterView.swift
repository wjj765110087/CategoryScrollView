//
//  CommentsSectionFooterView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  评论组尾

import UIKit

class CommentsSectionFooterView: UITableViewHeaderFooterView {

    static let reuseId = "CommentsSectionFooterView"
    static let footerHeight: CGFloat = 30.0

    private let shotLineView: UIView = {
       let view = UIView()
       view.backgroundColor = UIColor.init(r: 153, g: 153, b: 153)
       return view
    }()
    let spreadOutLabel: UILabel = {
       let label = UILabel()
       label.text = "展示更多回复"
       label.textColor = UIColor.init(r: 153, g: 153, b: 153)
       label.font = UIFont.systemFont(ofSize: 11)
       return label
    }()
    
    let downButton: UIButton = {
       let button = UIButton()
       button.setImage(UIImage(named: "CommentDown"), for: .normal)
       button.setImage(UIImage(named: "mainLineArrow_S"), for: .selected)
       return button
    }()
    
    private lazy var eventButton: UIButton = {
       let button = UIButton()
       button.addTarget(self, action: #selector(didClick), for: .touchUpInside)
       return button
    }()
    
    var buttonClickHandler: (()->())?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(red: 16/255.0, green: 13/255.0, blue: 31/255.0, alpha: 0.92)
        contentView.backgroundColor = UIColor(red: 16/255.0, green: 13/255.0, blue: 31/255.0, alpha: 0.92)
        contentView.addSubview(shotLineView)
        contentView.addSubview(spreadOutLabel)
        contentView.addSubview(downButton)
        contentView.addSubview(eventButton)
        layoutPageViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didClick() {
        buttonClickHandler?()
    }
}

// MARK: - Layout
private extension CommentsSectionFooterView {
    
    func layoutPageViews() {
        layoutShotLineView()
        layoutSpreadOutLabel()
        layoutDownButton()
        layoutEventButton()
    }
    
    func layoutShotLineView() {
        shotLineView.snp.makeConstraints { (make) in
            make.leading.equalTo(62)
            make.centerY.equalToSuperview()
            make.width.equalTo(15)
            make.height.equalTo(0.5)
        }
    }
    
    func layoutSpreadOutLabel() {
        spreadOutLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(shotLineView.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
        }
    }
    
    func layoutDownButton() {
        downButton.snp.makeConstraints { (make) in
            make.leading.equalTo(spreadOutLabel.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
            make.width.equalTo(6)
            make.height.equalTo(3.5)
        }
    }
    
    func layoutEventButton() {
        eventButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
