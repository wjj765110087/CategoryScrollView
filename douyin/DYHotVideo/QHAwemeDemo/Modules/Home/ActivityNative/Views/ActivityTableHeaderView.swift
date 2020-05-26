//
//  ActivityTableHeaderView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/6.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class ActivityTableHeaderView: UIView {
    
    static let height: CGFloat = 145 + (screenWidth - 20)*0.4
    
    //    /// 懒加载 倒计时
    lazy var countdownTimer: WMCountDown = {
        return WMCountDown()
    }()//    /// 懒加载 倒计
    let topImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "activityPlaceHoder")
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy var timeContView: ActivityCountDownView = {
        guard let activityCountDownView = Bundle.main.loadNibNamed("ActivityCountDownView", owner: nil, options: nil)?.last as? ActivityCountDownView else {return ActivityCountDownView()}
        return activityCountDownView
    }()
    let desLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.text = "抖友们！争夺大神名号的机会来了！不仅有现金奖励,还有社区动态贴置顶特权哦！来不及多说了快上车！"
        return label
    }()
    lazy var allButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(ConstValue.kTitleYelloColor, for: .normal)
        button.setTitle("更多内容 >", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(moreButtonClick), for: .touchUpInside)
        return button
    }()
    
    var moreClick:(() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        addSubview(topImage)
        addSubview(timeContView)
        addSubview(desLabel)
        addSubview(allButton)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func moreButtonClick() {
        moreClick?()
    }
    
    func setModel(_ activity: ActivityModel) {
        topImage.kfSetHeaderImageWithUrl(activity.banner, placeHolder: UIImage(named: "activityPlaceHoder"))

        print("startime == \(activity.startDate ?? "") == \(activity.endDate ?? "")")
        if let startTime = activity.startDate {
            let isStart = !Date.isExpired(time: startTime)
            if isStart {
                //已开始
                if let endTime = activity.endDate {
                    let isFinish = !Date.isExpired(time: endTime)
                    if isFinish {
                        allButton.setTitle("获奖名单 >", for: .normal)
                        timeContView.isFinished()
                    } else {
                        countdownTimer.stop()
                        timeContView.countdownTimer = countdownTimer
                        timeContView.beiginCountDown(fromTime: nil, endTime: endTime)
                    }
                }
            } else {
                 timeContView.notBegin()
            }
        }
       
        if let descStr = activity.rules_desc {
             desLabel.text = descStr
        }
    }
}

// MARK: - Layout
private extension ActivityTableHeaderView {
    func layoutPageSubviews() {
        layoutTopImage()
        layoutTimeCountView()
        layoutDeslabel()
        layoutAllButton()
    }
    func layoutTopImage() {
        topImage.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
            make.top.equalTo(10)
            make.height.equalTo((screenWidth-24)*0.4)
        }
    }
    func layoutTimeCountView() {
        timeContView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(topImage)
            make.top.equalTo(topImage.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
    }
    func layoutDeslabel() {
        desLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(timeContView)
            make.top.equalTo(timeContView.snp.bottom).offset(10)
        }
    }
    func layoutAllButton() {
        allButton.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
            make.top.equalTo(desLabel.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
    }
}
