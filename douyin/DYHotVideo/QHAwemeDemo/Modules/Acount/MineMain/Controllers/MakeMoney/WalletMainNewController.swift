//
//  WalletMainNewController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/19.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

class WalletMainNewController: QHBaseViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "钱包"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = ConstValue.kViewLightColor
        bar.lineView.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = true
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 70.0
        table.separatorStyle = .none
        table.register(UINib(nibName: "WalletMainCell", bundle: Bundle.main), forCellReuseIdentifier: WalletMainCell.cellId)
        return table
    }()
    
    var titles: [String] = ["余额", "金币"]
    var icons: [String] = ["balance", "coinImage"]
    
    private lazy var walletApi: UserWalletApi = {
        let api = UserWalletApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    var walletModel = WalletInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(navBar)
        view.addSubview(tableView)
        layoutPageViews()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    
    private func loadData() {
        let _ = walletApi.loadData()
    }
}

extension WalletMainNewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WalletMainCell.cellId, for: indexPath) as! WalletMainCell
        cell.titleLab.text = titles[indexPath.section]
        cell.iconImageView.image = UIImage(named: icons[indexPath.section])
        if indexPath.section == 0 {
            cell.subLab.text = "\(walletModel.money ?? "0.00")元"
        } else {
            cell.subLab.text = "\(walletModel.coins ?? 0)个"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let wallVC = WalletController()
            navigationController?.pushViewController(wallVC, animated: true)
        } else {
            let coinWalletVC = CoinWalletController()
            navigationController?.pushViewController(coinWalletVC, animated: true)
        }
    }
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension WalletMainNewController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if  manager is UserWalletApi {
            if let wallet = manager.fetchJSONData(UserReformer()) as? WalletInfo {
                walletModel = wallet
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

private extension WalletMainNewController {
    
    func layoutPageViews() {
        layoutNavBar()
        layoutTableView()
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(safeAreaTopHeight)
        }
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
}

extension WalletMainNewController: QHNavigationBarDelegate {
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

