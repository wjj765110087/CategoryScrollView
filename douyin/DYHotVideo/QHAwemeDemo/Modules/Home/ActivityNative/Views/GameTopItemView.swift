//
//  GameTopItemView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019-12-19.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

/// 顶部操作栏
class GameTopItemView: UIView {

    ///跑马灯
    private let runhouseView: UIRunHouseView = UIRunHouseView()
    private lazy var dailyTaskButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "game_DalyTaskBtn"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 16.0
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(itemButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var myGiftButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "game_giftBtn"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 16.0
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(itemButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var convertButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "game_convertBtn"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 16.0
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(itemButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    var datas: [String] = [""]
    
    var clickHandler:((_ actionId: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(runhouseView)
        runhouseView.dataSourse = self
        runhouseView.backgroundColor = UIColor.clear
        runhouseView.registerClasse(classType: CustomRunHouseView.classForCoder(), reuseIdentifier: "GameRunHouseView")
        runhouseView.registerClasse(classType: ImageTitleView.classForCoder(), reuseIdentifier: "ImageTitleView")
        
        addSubview(dailyTaskButton)
        addSubview(myGiftButton)
        addSubview(convertButton)
        layoutPageViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func itemButtonClick(_ sender: UIButton) {
        if sender == dailyTaskButton {
            clickHandler?(1)
        } else if sender == myGiftButton {
            clickHandler?(2)
        } else if sender == convertButton {
            clickHandler?(3)
        }
    }
    
    func setNotices(_ notices: [String]) {
        datas = notices
        runhouseView.reloadData()
    }
}

extension GameTopItemView: UIRunHouseViewDatasourse {
    //MARK UIRunHouseViewDatasourse 跑马灯数据源
    ///跑马灯有多少个item
    func numberOfItemsInRunHouseView(view: UIRunHouseView) -> Int {
        return datas.count
    }
    func runHouseView(runHouseView: UIRunHouseView, itemForIndex index: Int) -> UIView {
        var view = runHouseView.dequeneItemViewResueIdentity(resueIdentity: "GameRunHouseView") as? CustomRunHouseView
        if view == nil {
            view = CustomRunHouseView()
        }
        view?.label.text = self.datas[index]
        view?.label.textColor = UIColor.white
        view?.label.font = UIFont.systemFont(ofSize: 12)
        return view!
    }
    
    func runHouseView(runHouseView: UIRunHouseView, widthForIndex index: Int) -> CGFloat {
        let str = self.datas[index]
        let font = UIFont.systemFont(ofSize: 12)
        let rect = str.boundingRect(with:CGSize.init(width: CGFloat(MAXFLOAT), height: 50),options: NSStringDrawingOptions.usesLineFragmentOrigin,attributes: [NSAttributedString.Key.font:font],context:nil)
        return rect.size.width + 10
    }

}

private extension GameTopItemView {
    func layoutPageViews() {
        layoutGiftButton()
        layoutDailyTaskButton()
        layoutConvertButton()
        layoutRunHouseView()
    }
    func layoutRunHouseView() {
        runhouseView.snp.makeConstraints { (make) in
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.top.equalTo(10)
            make.height.equalTo(35)
        }
    }
    func layoutGiftButton() {
        myGiftButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(0)
            make.height.equalTo(37)
            make.width.equalTo(85)
        }
    }
    func layoutDailyTaskButton() {
        dailyTaskButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(myGiftButton)
            make.leading.equalTo(30)
            make.height.equalTo(37)
            make.width.equalTo(85)
        }
    }
    func layoutConvertButton() {
        convertButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(myGiftButton)
            make.trailing.equalTo(-25)
            make.height.equalTo(37)
            make.width.equalTo(85)
        }
    }
}
