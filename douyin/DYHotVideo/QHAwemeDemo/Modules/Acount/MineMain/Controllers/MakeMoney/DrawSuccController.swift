//
//  DrawSuccController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/6/1.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class DrawSuccController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private let successImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "cardConvertSucceed")
        return img
    }()
    private let titleLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.white
        lab.text = "提现成功"
        lab.font = UIFont.systemFont(ofSize: 21)
        lab.textAlignment = .center
        return lab
    }()
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.white
        lab.text = "预计 1～2 日到账"
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.textAlignment = .center
        return lab
    }()
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.white
        lab.text = "￥0.00"
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.textAlignment = .center
        return lab
    }()
    private lazy var backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("返回首页", for: .normal)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        return btn
    }()
    
    var money = "0.00"
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 90, g: 210, b: 144)
        view.addSubview(successImg)
        view.addSubview(titleLab)
        view.addSubview(timeLab)
        view.addSubview(moneyLab)
        view.addSubview(backBtn)
        layoutPageSubviews()
        moneyLab.text = "￥\(money)"

    }
    @objc func back() {
        navigationController?.popToRootViewController(animated: true)
    }
    

}


private extension DrawSuccController {
    
    func layoutPageSubviews() {
        successImg.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(110 + safeAreaTopHeight)
            make.width.height.equalTo(100)
        }
        titleLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(successImg.snp.bottom).offset(25)
            make.height.equalTo(30)
        }
        timeLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        moneyLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLab.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        backBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-(safeAreaBottomHeight + 20))
            } else {
                make.bottom.equalToSuperview().offset(-(safeAreaBottomHeight + 20))
            }
            make.height.equalTo(40)
            
        }
    }
}
