//
//  MessageMainCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/2.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class MessageMainCell: UITableViewCell {
    
    static let cellId = "MessageMainCell"
    static let cellHeight: CGFloat = 96.0
    
    lazy var icomImageView: UIImageView = {
        let image = UIImageView()
        image.image = ConstValue.kDefaultHeader
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 25
        image.layer.masksToBounds = true
       return image
    }()
    
    lazy var titleLab: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor  = UIColor.white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var subLab: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor  = UIColor.init(r: 153, g: 153, b: 153)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
     lazy var timeLab: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor  = UIColor.init(r: 153, g: 153, b: 153)
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
     lazy var dotView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor.init(r: 41, g: 126, b: 247)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.clear
        contentView.addSubview(icomImageView)
        contentView.addSubview(titleLab)
        contentView.addSubview(subLab)
        contentView.addSubview(timeLab)
        contentView.addSubview(dotView)
        layoutPageViews()
    }
    
    func setModel(model: SystemMessageModel) {
        icomImageView.image = UIImage(named: "app")
        titleLab.text = "系统消息"
        if let type = model.type {
            if type == .imageText {
                subLab.text = model.alter?.title ?? ""
            } else if type == .video {
                if let videoModel = model.alter?.video_model {
                    subLab.text = videoModel.title ?? ""
                }
            }
        }
        timeLab.text = model.created_at ?? ""
        dotView.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - layout
extension MessageMainCell {
    
    private func layoutPageViews() {
        layoutIconImageView()
        layoutSubLab()
        layoutTitleLabel()
       
        layoutTimeLab()
        layoutDotView()
    }
    
    
    private func layoutIconImageView() {
        icomImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(18)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(50)
        }
    }
    
    private func layoutTitleLabel() {
        titleLab.snp.makeConstraints { (make) in
            make.leading.equalTo(icomImageView.snp.trailing).offset(19)
            make.bottom.equalTo(subLab.snp.top).offset(-9)
//            make.top.equalTo(28)
        }
    }
    
    private func layoutSubLab() {
        subLab.snp.makeConstraints { (make) in
            make.leading.equalTo(icomImageView.snp.trailing).offset(19)
            make.bottom.equalTo(icomImageView.snp.bottom).offset(-7)
//            make.top.equalTo(titleLab.snp.bottom).offset(11.5)
        }
    }
    
    private func layoutTimeLab() {
        timeLab.snp.makeConstraints { (make) in
            make.trailing.equalTo(-19.5)
            make.top.equalTo(34)
        }
    }
    
    private func layoutDotView() {
        dotView.snp.makeConstraints { (make) in
            make.trailing.equalTo(-21)
            make.size.equalTo(CGSize(width: 6, height: 6))
            make.centerY.equalTo(subLab.snp.centerY)
        }
    }
}
