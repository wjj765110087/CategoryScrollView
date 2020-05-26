//
//  MessageFansCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class MessageFansCell: UITableViewCell {

    static let cellId = "MessageFansCell"
    static let cellHeight: CGFloat = 93.0
    
    private lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.image = ConstValue.kDefaultHeader
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 25
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var titleLab: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor  = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var timeLab: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor  = UIColor.init(r: 153, g: 153, b: 153)
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    private lazy var attentionBtn: UIButton = {
       let button = UIButton()
       button.setTitle("关注", for: .normal)
       button.setTitleColor(UIColor.white, for: .normal)
       button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
       button.setBackgroundImage(UIImage.imageFromColor(UIColor.init(r: 0, g: 123, b: 255), frame: CGRect(x: 0, y: 0, width: 1, height: 1)), for: .normal)
       button.setBackgroundImage(UIImage.imageFromColor(ConstValue.kVcViewColor, frame: CGRect(x: 0, y: 0, width: 1, height: 1)), for: .selected)
        button.addTarget(self, action: #selector(didClickButton), for: .touchUpInside)
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
       return button
    }()
    
    var didClickAttentionHandler: (()->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = ConstValue.kVcViewColor
        contentView.addSubview(iconImage)
        contentView.addSubview(titleLab)
        contentView.addSubview(timeLab)
        contentView.addSubview(attentionBtn)
        layoutPageViews()
    }
    
    func setModel(model: FansMessageModel) {
        let defaltHeader = UserModel.share().getUserHeader(model.user?.id)
        iconImage.kfSetHeaderImageWithUrl(model.user?.cover_path, placeHolder: defaltHeader)
        titleLab.text = model.user?.nikename ?? ""
        timeLab.text = model.created_at ?? ""
        
        if model.id == UserModel.share().userInfo?.id {
            attentionBtn.setBackgroundImage(UIImage.imageFromColor(UIColor.init(r: 35, g: 38, b: 53), frame: CGRect(x: 0, y: 0, width: 1, height: 1)), for: .normal)
            attentionBtn.setTitle("自己", for: .normal)
        } else {
            if let fag = model._realation?.flag {
                switch fag {
                case .notRelate, .follwMe:
                    attentionBtn.setBackgroundImage(UIImage.imageFromColor(UIColor.init(r: 0, g: 123, b: 255), frame: CGRect(x: 0, y: 0, width: 1, height: 1)), for: .normal)
                    attentionBtn.setTitle("关注", for: .normal)
                    break
                case .followEachOther:
                    attentionBtn.setBackgroundImage(UIImage.imageFromColor(UIColor.init(r: 35, g: 38, b: 53), frame: CGRect(x: 0, y: 0, width: 1, height: 1)), for: .normal)
                    attentionBtn.setTitle("相互关注", for: .normal)
                    break
                case .myFollow:
                    attentionBtn.setBackgroundImage(UIImage.imageFromColor(UIColor.init(r: 35, g: 38, b: 53), frame: CGRect(x: 0, y: 0, width: 1, height: 1)), for: .normal)
                    attentionBtn.setTitle("已关注", for: .normal)
                    break
                case .isMySelf:
                    break
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: -Event
extension MessageFansCell {
    
    @objc func didClickButton() {
        didClickAttentionHandler?()
    }
}


// MARK: - layout
extension MessageFansCell {
    
    private func layoutPageViews() {
        layoutIconImageView()
        layoutTitleLabel()
        layoutTimeLab()
        layoutAttentionButton()
    }
    
    private func layoutIconImageView() {
        iconImage.snp.makeConstraints { (make) in
            make.leading.equalTo(18)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(50)
        }
    }
    
    private func layoutTitleLabel() {
        titleLab.snp.makeConstraints { (make) in
            make.leading.equalTo(iconImage.snp.trailing).offset(19)
            make.top.equalTo(28)
        }
    }
    
    private func layoutTimeLab() {
        timeLab.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLab.snp.leading)
            make.top.equalTo(timeLab.snp.bottom).offset(12)
        }
    }
    
    private func layoutAttentionButton() {
        attentionBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-25)
            make.centerY.equalTo(iconImage.snp.centerY)
            make.size.equalTo(CGSize(width: 71, height: 28))
        }
    }
}
