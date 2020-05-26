//
//  NicooLoadedFailedView.swift
//  NicooPlayer
//
//  Created by 小星星 on 2018/6/19.
//

import UIKit
import SnapKit

class NicooLoadedFailedView: UIView {
    
    fileprivate var loadFailedTitle: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.text = "视频连接失败，请检查网络设置!"
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.textColor = UIColor.white
        lable.numberOfLines = 2
        return lable
    }()
    var retryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("点击重试", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = 17.5
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red: 255/255.0, green: 105/255.0, blue: 27/255.0, alpha: 1)
        button.addTarget(self, action: #selector(retryButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    var retryButtonClickBlock: ((_ sender: UIButton) ->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius  = 5
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.clear
        self.loadUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func loadUI() {
        addSubview(loadFailedTitle)
        addSubview(retryButton)
        layoutAllSubviews()
    }
    @objc func retryButtonClick(_ sender: UIButton) {
        if retryButtonClickBlock != nil {
            retryButtonClickBlock!(sender)
        }
        self.removeFromSuperview()
    }
    fileprivate func layoutAllSubviews() {
        loadFailedTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-25)
            make.height.equalTo(45)
        }
        retryButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(25)
            make.height.equalTo(35)
            make.width.equalTo(130)
        }
    }
    
}

class NicooAuthErrorView: UIView {
    
    var vipTipsTitle: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.text = "该视频仅限VIP用户观看，请充值!"
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.textColor = UIColor.white
        lable.numberOfLines = 2
        return lable
    }()
    var chargeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("成为VIP会员", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = 17.5
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red: 255/255.0, green: 105/255.0, blue: 27/255.0, alpha: 1)
        button.addTarget(self, action: #selector(retryButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    var chargeButtonClickBlock: ((_ sender: UIButton) ->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 11/255.0, green: 190/255.0, blue: 6/255.0, alpha: 0.85)
        self.loadUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func loadUI() {
        addSubview(vipTipsTitle)
        addSubview(chargeButton)
        layoutAllSubviews()
    }
    @objc func retryButtonClick(_ sender: UIButton) {
        chargeButtonClickBlock?(sender)
        //self.removeFromSuperview()
    }
    fileprivate func layoutAllSubviews() {
        vipTipsTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-25)
            make.height.equalTo(45)
        }
        chargeButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(25)
            make.height.equalTo(35)
            make.width.equalTo(130)
        }
    }
    
}
