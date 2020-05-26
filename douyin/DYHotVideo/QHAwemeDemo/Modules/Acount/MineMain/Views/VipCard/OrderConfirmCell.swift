//
//  OrderConfirmCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

/// 订单确认列表cell
class OrderConfirmCell: UITableViewCell {
   
    static let cellId = "OrderConfirmCell"
    
    let titleLab: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = UIColor(white: 0.8, alpha: 1.0)
        return lable
    }()
    
    let priceLab: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.textColor = UIColor(red: 235/255.0, green: 217/255.0, blue: 3/255.0, alpha: 1)
        lable.textAlignment = .right
        return lable
    }()
    let cardTipsLab: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 10)
        lable.textColor = UIColor.white
        lable.textAlignment = .center
        lable.backgroundColor = UIColor(red: 235/255.0 , green: 94/255.0, blue: 71/255.0, alpha: 0.9)
        lable.layer.cornerRadius = 5
        lable.layer.masksToBounds = true
        lable.isHidden = true
        return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        setUpSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpSubviews() {
        contentView.addSubview(titleLab)
        contentView.addSubview(priceLab)
        contentView.addSubview(cardTipsLab)

        layoutPageSubviews()
    }

}


// MARK: - Layout
private extension OrderConfirmCell {
    
    func layoutPageSubviews() {
        layoutTitleLable()
        layoutPriceLable()
        layoutCardTipsLable()
    }
    
    func layoutTitleLable() {
        titleLab.snp.makeConstraints { (make) in
            make.leading.equalTo(25)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
    }
    
    func layoutPriceLable() {
        priceLab.snp.makeConstraints { (make) in
            make.trailing.equalTo(-25)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
    }
    
    func layoutCardTipsLable() {
        cardTipsLab.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLab.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(48)
            make.height.equalTo(18)
        }
    }
    
}



/// 订单确认订单说明cell
class OrderExplainCell: UITableViewCell {
    
    static let cellId = "OrderExplainCell"
    static let explainMsg = "1、观影卡购买后可在观影卡有效期内，无限次观看所有视频内容。\n2、为保证交易公平，确保观影卡可正常使用，观影卡一经售出，不可退款。\n3、观影卡可重复购买，重复购买后观影卡有效时间将累计计算，用户页只展示最高级观影卡。\n4、分享邀请好友注册可延长观影卡有效时间，邀请越多，时间奖励越多。\n5、若交易失败，你的福利卡暂时锁定，请您等待3分钟可继续使用。"
    
    let msgLable: UILabel = {
        let lable = UILabel() //141 144 153
        lable.textColor = UIColor(red: 141/255.0, green: 144/255.0, blue: 153/255.0, alpha: 1)
        lable.textAlignment = .left
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.numberOfLines = 0
        lable.attributedText = TextSpaceManager.getAttributeStringWithString(OrderExplainCell.explainMsg, lineSpace: 7)
        return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        selectionStyle = .none
        setUpSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpSubviews() {
        contentView.addSubview(msgLable)
        layoutMsgLable()
    }
    
    private func layoutMsgLable() {
        msgLable.snp.makeConstraints { (make) in
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.top.equalTo(12)
            make.bottom.equalTo(-10)
        }
    }
    
}
