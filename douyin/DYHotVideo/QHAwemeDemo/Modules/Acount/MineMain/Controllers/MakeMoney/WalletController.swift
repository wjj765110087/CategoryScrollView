//
//  WalletMainController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/12.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

class WalletController: QHBaseViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "钱包"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.init(r: 30, g: 31, b: 50)
        bar.lineView.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    private let headerView: WalletHeaderView = {
        let view = WalletHeaderView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 170))
        view.backgroundColor = UIColor.init(r: 30, g: 31, b: 50)
        return view
    }()
    private lazy var recordBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("明细", for: .normal)
        button.setTitleColor(UIColor(r: 0, g: 123, b: 255), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(recordBtnClick(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = true
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.rowHeight = 70.0
        table.register(UINib(nibName: "WalletMainCell", bundle: Bundle.main), forCellReuseIdentifier: WalletMainCell.cellId)
        return table
    }()
    
    private lazy var walletApi: UserWalletApi = {
        let api = UserWalletApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    var walletModel = WalletInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
        configUserHeader()
        loadData()
    }
    
    private func setUpSubviews() {
        view.addSubview(navBar)
        view.addSubview(tableView)
        navBar.navBarView.addSubview(recordBtn)
        tableView.tableHeaderView = headerView
        layoutPageSubviews()
    }
    
    private func loadData() {
        let _ = walletApi.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func configUserHeader() {
        headerView.moneyLabel.text = "\(walletModel.money ?? "0.00")"
    }
    
    @objc private func recordBtnClick(_ sender: UIButton) {
        let vc = MoneyDetailController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - QHNavigationBarDelegate
extension WalletController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension WalletController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WalletMainCell.cellId, for: indexPath) as! WalletMainCell
        if indexPath.section == 0 {
            cell.imageView?.image = UIImage(named: "walletCash")
            cell.titleLab?.text = "余额提现"
        } else {
            cell.imageView?.image = UIImage(named: "coinImage")
            cell.titleLab?.text = "购买金币/会员"
        }
        cell.titleLab.font = UIFont.systemFont(ofSize: 14)
        cell.titleLab.textColor = UIColor.white
        cell.subLab.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let drawvc = DrawCashController()
            drawvc.allMoney = walletModel.money ?? "0.00"
            navigationController?.pushViewController(drawvc, animated: true)
        } else {
            let investVC = InvestController()
            investVC.currentIndex = 0
            navigationController?.pushViewController(investVC, animated: true)
        }
    }
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension WalletController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if  manager is UserWalletApi {
            if let wallet = manager.fetchJSONData(UserReformer()) as? WalletInfo {
                walletModel = wallet
                configUserHeader()
                tableView.reloadData()
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserWalletApi {
//            XSAlert.show(type: .error, text: manager.errorMessage)
        }
    }
}


// MARK: - Description
private extension WalletController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutRecordBtn()
        layoutTableView()
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom).offset(0)
        }
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    func layoutRecordBtn() {
        recordBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(35)
        }
    }
}
