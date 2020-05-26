//
//  CoinChangeMoneyController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/20.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

class CoinChangeMoneyController: QHBaseViewController {

    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "金币兑换余额"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.init(r: 30, g: 31, b: 50)
        bar.lineView.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    
    private lazy var headerView: ChangeMoneyHeaderView = {
        guard var header = Bundle.main.loadNibNamed("ChangeMoneyHeaderView", owner: nil, options: nil)?.last as? ChangeMoneyHeaderView else { return ChangeMoneyHeaderView()}
        return header
    }()
    
    private lazy var textLab: UILabel = {
       let label = UILabel()
       label.text = "兑换成余额后，可用于购买会员、金币或提现，提现将收取提现服务费，请对资金做合理安排。"
       label.font = UIFont.systemFont(ofSize: 12)
       label.textColor = UIColor.init(r: 153, g: 153, b: 153)
       label.textAlignment = .left
       label.numberOfLines = 0
       return label
    }()
    
    private lazy var exchangeBtn: UIButton = {
       let button = UIButton()
        button.setTitle("确认兑换", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true
        button.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.init(r: 30, g: 31, b: 50), size: CGSize.init(width: 1, height: 1)), for: .disabled)
        button.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.init(r: 0, g: 123, b: 255), size: CGSize.init(width: 1, height: 1)), for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(didClickExchage), for: .touchUpInside)
        return button
    }()
    
    private lazy var exchangeApi: CoinChangeMoneyApi = {
        let api = CoinChangeMoneyApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    
    var walletInfo = WalletInfo()
    
    var coins: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(navBar)
        view.addSubview(headerView)
        view.addSubview(textLab)
        view.addSubview(exchangeBtn)
        layoutPageSubviews()
        addHeaderViewCallBack()
        setHeaderUI()
    }
    
    func loadData() {
        let _ = exchangeApi.loadData()
    }
    
    func addHeaderViewCallBack() {
        headerView.textFieldHandler = { [weak self] coins in
            guard let strongSelf = self else {return}
            strongSelf.coins = coins
            if let coin = strongSelf.walletInfo.coins {
                if strongSelf.coins == 0 {
                    strongSelf.exchangeBtn.isEnabled = false
                } else {
                    strongSelf.exchangeBtn.isEnabled = true
                }
                if strongSelf.coins > coin {        ///如果输入金币大于自己的金币
                    strongSelf.exchangeBtn.isEnabled = false
                }
            }
        }
    }
    
    func setHeaderUI() {
        headerView.setModel(model: walletInfo)
    }
    
    @objc func didClickExchage() {
        headerView.textFeild.resignFirstResponder()
        if let coin = walletInfo.coins {
            if self.coins > coin {
                XSAlert.show(type: .error
                    , text:"兑换数量超限")
                return
            }
            
            if self.coins == 0 {
                XSAlert.show(type: .error, text: "兑换金币数量最少为1个")
                return
            }
        }
        loadData()
    }
}

extension CoinChangeMoneyController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        let params = [CoinChangeMoneyApi.kCoins: self.coins]
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        return params
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if  manager is CoinChangeMoneyApi {
            XSAlert.show(type: .success, text: "兑换余额成功，请在余额查看")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is CoinChangeMoneyApi {
            XSAlert.show(type: .error, text: manager.errorMessage)
        }
    }
}

// MARK: - QHNavigationBarDelegate
extension CoinChangeMoneyController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension CoinChangeMoneyController {
    func layoutPageSubviews() {
        layoutNavBar()
        layoutHeaderView()
        layoutTextLab()
        layoutExchangeBtn()
    }

    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    
    func layoutHeaderView() {
        headerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            make.height.equalTo(180)
        }
    }
    
    func layoutTextLab() {
        textLab.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(headerView.snp.bottom).offset(32)
            make.height.equalTo(30)
        }
    }
    
    func layoutExchangeBtn() {
        exchangeBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(18)
            make.trailing.equalTo(-18)
            make.height.equalTo(48)
            make.top.equalTo(textLab.snp.bottom).offset(33)
        }
    }
}
