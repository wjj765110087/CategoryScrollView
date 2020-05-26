//
//  CommunityRecommandCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/2.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class CommunityRecommandCell: UITableViewCell {
    
    static let cellId = "CommunityRecommandCell"
    static let cellHeight: CGFloat = 93.0
    
    let itemBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 26.5
        view.layer.borderColor = UIColor(r: 0, g: 123, b: 255).cgColor
        view.layer.borderWidth = 1.0
        return view
    }()
    let itemImage: UIImageView = {
        let image = UIImageView()
        image.image = ConstValue.kDefaultHeader
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20.5
        image.layer.masksToBounds = true
        return image
    }()
    lazy var titleLab: UILabel = {
        let label = UILabel()
        label.text = "#巨乳合集"
        label.textColor  = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    lazy var subLab: UILabel = {
        let label = UILabel()
        label.text = "22698条新内容"
        label.textColor  = UIColor.init(r: 153, g: 153, b: 153)
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    lazy var joinButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("+加入", for: .normal)
        button.setTitle("已加入", for: .selected)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor(r: 153, g: 153, b: 153), for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.layer.cornerRadius = 13
        button.layer.masksToBounds = true
        button.layer.borderWidth = 0.5
        button.setBackgroundImage(UIImage.imageFromColor(ConstValue.kViewLightColor, frame: CGRect(x: 0, y: 0, width: 60, height: 27)), for: .selected)
        button.setBackgroundImage(UIImage.imageFromColor(ConstValue.kVcViewColor, frame: CGRect(x: 0, y: 0, width: 60, height: 27)), for: .normal)
        button.addTarget(self, action: #selector(addTalks), for: .touchUpInside)
        return button
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = ConstValue.kVcViewColor
        return view
    }()
    var addTalksClickHandler:(()->Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        contentView.addSubview(itemBgView)
        itemBgView.addSubview(itemImage)
        contentView.addSubview(titleLab)
        contentView.addSubview(subLab)
        contentView.addSubview(joinButton)
        contentView.addSubview(lineView)
        layoutPageSubViews()
        let view = UIView()
        view.backgroundColor =  ConstValue.kViewLightColor
        selectedBackgroundView = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func addTalks() {
        addTalksClickHandler?()
    }
    func setModel(_ talkModel: TalksModel) {
        itemImage.kfSetVerticalImageWithUrl(talkModel.cover_url)
        titleLab.text = "#\(talkModel.title ?? "#----")"
        subLab.text = "\(talkModel.total_count ?? 0)条新内容"
        joinButton.isSelected = (talkModel.has_count ?? .noFollow) == .follow
        joinButton.layer.borderColor = (talkModel.has_count ?? .noFollow) == .follow ? UIColor(r: 18, g: 19, b: 37).cgColor : UIColor(r: 0, g: 123, b: 255).cgColor
    }
    func setAddModel(_ talkModel: TalksModel) {
        itemImage.kfSetVerticalImageWithUrl(talkModel.cover_url)
        titleLab.text = "#\(talkModel.title ?? "#----")"
        subLab.text = "\(talkModel.total_count ?? 0)条新内容"
        //joinButton.isSelected = (talkModel.is_has_count ?? .noFollow) == .follow
        joinButton.layer.borderColor =  UIColor(r: 0, g: 123, b: 255).cgColor
    }
}

// MARK: - layout
extension CommunityRecommandCell {
    
    private func layoutPageSubViews() {
        layoutItemBgView()
        layoutIconImageView()
        layoutTitleLabel()
        layoutSubLab()
        layoutJoinButton()
        layoutLineView()
    }
    
    func layoutItemBgView() {
        itemBgView.snp.makeConstraints { (make) in
            make.leading.equalTo(18)
            make.top.equalTo(20)
            make.height.width.equalTo(53)
        }
    }
    
    private func layoutIconImageView() {
        itemImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 41, height: 41))
        }
    }
    
    private func layoutTitleLabel() {
        titleLab.snp.makeConstraints { (make) in
            make.leading.equalTo(itemBgView.snp.trailing).offset(19)
            make.top.equalTo(28)
        }
    }
    
    private func layoutSubLab() {
        subLab.snp.makeConstraints { (make) in
            make.leading.equalTo(itemBgView.snp.trailing).offset(19)
            make.top.equalTo(titleLab.snp.bottom).offset(11.5)
        }
    }
    
    private func layoutJoinButton() {
        joinButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 60, height: 27))
            make.trailing.equalTo(-19.5)
        }
    }
    
    private func layoutLineView() {
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(18)
            make.trailing.equalTo(-18)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
    }
}
