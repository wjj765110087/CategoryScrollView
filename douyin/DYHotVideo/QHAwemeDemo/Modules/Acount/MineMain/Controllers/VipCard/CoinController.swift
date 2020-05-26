//
//  CoinController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/18.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

class CoinController: QHBaseViewController {
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = true
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(CoinSelectCell.classForCoder(), forCellReuseIdentifier: CoinSelectCell.cellId)
        table.register(InvestCell.classForCoder(), forCellReuseIdentifier: InvestCell.cellId)
        table.register(ChangeVipItemCell.classForCoder(), forCellReuseIdentifier: ChangeVipItemCell.cellId)
        table.register(PayTypeItemCell.classForCoder(), forCellReuseIdentifier: PayTypeItemCell.cellId)
        return table
    }()
    private lazy var coinApi: CoinListApi = {
        let api = CoinListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var payTypeApi: UserPayTypeListApi = {
        let api = UserPayTypeListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var orderAddApi: UserOrderAddApi = {
        let api = UserOrderAddApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    var coinList = CoinListModel()
    var selectedIndex: Int = 0
    var payTypeCurrentIndex: Int = 0
    
    var payTypes = [PayTypeModel]()
    
    var currentPayType: PayTypeModel?
    
    var bottomViewCoinHandler:((_ paytypeId: Int, _ coinModel:CoinModel)->())?
    
    var noticeMsg: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(tableView)
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        tableView.contentInset = UIEdgeInsets(top: UIDevice.current.isiPhoneXSeriesDevices() ? 110 : 100, left: 0, bottom: UIDevice.current.isiPhoneXSeriesDevices() ? 128 : 88, right: 0)
        
        layoutPageSubviews()
        loadCoinsData()
    }
    
    private func loadCoinsData() {
        NicooErrorView.removeErrorMeesageFrom(view)
        let _ = coinApi.loadData()
    }
    private func loadPayTypes() {
        let _ = payTypeApi.loadData()
    }
    func payAction() {
        if currentPayType == nil {
            XSAlert.show(type: .error, text: "请选择支付方式")
            return
        }
        XSProgressHUD.showCustomAnimation(msg: "提交订单...", onView: view, imageNames: nil, bgColor: nil, animated: false)
        let _ = orderAddApi.loadData()
    }
    /// 支付
    private func goAlipay(_ playUrl: String) {
        let alipayVc = AdvertWebController()
        alipayVc.urlString = playUrl
        alipayVc.title = "支付"
        getInvestVC()?.navigationController?.pushViewController(alipayVc, animated: true)
    }
    /// 充值系统繁忙提示
    private func showServerWarningAlert(msg: String) {
        let alert = UIAlertController(title: "支付提示", message: "\r\(msg)", preferredStyle: .alert)
        let cancle = UIAlertAction(title: "好的", style: .cancel, handler: nil)
        alert.addAction(cancle)
        alert.modalPresentationStyle = .fullScreen
        self.present(alert, animated: true, completion: nil)
    }
    /// 联系管理员充值
    private func goToServerVerb() {
        if let url = URL(string: AppInfo.share().potato_invite_link ?? "") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CoinController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return VipCardsContentCell.cellHeight
        } else if indexPath.section == 1 {
            if let notice = coinList.coins_message, !notice.isEmpty {
                return InvestCell.cellHeight
            }
            return 0.0001
        } else if indexPath.section == 2 {
            return 55
        } else if indexPath.section == 3 {
            return 60.0
        }
        return 0.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 || section == 2 {
            return 1
        } else if section == 3 {
            return payTypes.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CoinSelectCell.cellId, for: indexPath) as! CoinSelectCell
            if let coins = coinList.coins, coins.count > indexPath.row {
                 cell.setModels(coins)
                cell.itemClickHandler = { [weak self] index in
                    guard let strongSelf = self else { return }
                    strongSelf.selectedIndex = index
                    ///获取支付通道
                    strongSelf.loadPayTypes()
                    strongSelf.bottomViewCoinHandler?(2, coins[strongSelf.selectedIndex])
                }
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: InvestCell.cellId, for: indexPath) as! InvestCell
            cell.setDatas([noticeMsg])
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ChangeVipItemCell.cellId, for: indexPath) as! ChangeVipItemCell
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PayTypeItemCell.cellId, for: indexPath) as! PayTypeItemCell
            if payTypes.count > indexPath.row {
                cell.setModel(payTypes[indexPath.row])
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 3 && payTypes.count > indexPath.row {
            if payTypes[indexPath.row].status?.allowPay ?? false {  /// 通道可用，才可选
                payTypes[payTypeCurrentIndex].selected = false
                payTypes[indexPath.row].selected = true
                payTypeCurrentIndex = indexPath.row
                currentPayType = payTypes[payTypeCurrentIndex]
                tableView.reloadSections([3], with: .none)
            }
        } else if indexPath.section == 2 {
            let exVc = ExchangeController()
            getInvestVC()?.navigationController?.pushViewController(exVc, animated: true)
        }
    }
    
    func getInvestVC() -> InvestController? {
        var next = view.superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is InvestController) {
                return nextResponder as? InvestController
            }
            next = next?.superview
        }
        return nil
    }
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension CoinController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        if manager is UserPayTypeListApi {
            if let coins = coinList.coins, coins.count > 0 {
                   let model = coins[selectedIndex]
                   return [UserPayTypeListApi.kAmount: Float(model.price ?? "0.00") ?? 0.00]
            }
        }
        if manager is UserOrderAddApi {
            var params = [String: Any]()
            params[UserOrderAddApi.kOrder_type] = 3
            params[UserOrderAddApi.kDevice_type] = "ios"
            params[UserOrderAddApi.kDevice_code] = UIDevice.current.getIdfv()
            if let coins = coinList.coins, coins.count > 0 {
                params[UserOrderAddApi.kVc_id] = coins[selectedIndex].id
            }
            if currentPayType != nil {
                params[UserOrderAddApi.kPay_type] = currentPayType!.key ?? ""
            }
            return params
        }
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)

        if manager is CoinListApi {
            if let coinList = manager.fetchJSONData(UserReformer()) as? CoinListModel {
                self.coinList = coinList
                self.noticeMsg = coinList.coins_message ?? ""
                ///获取支付通道
                loadPayTypes()
                ///默认选中第0个
                if let coins = coinList.coins, coins.count > 0 {
                    bottomViewCoinHandler?(2, coins[0])
                }
                tableView.reloadData()
            }
        }
        
        if  manager is UserPayTypeListApi {
            if let pays = manager.fetchJSONData(UserReformer()) as? [PayTypeModel] {
                if pays.count > 0 {
                    payTypes = pays
                    tableView.reloadSections([3], with: .automatic)
                }
            }
        }
        if manager is UserOrderAddApi {
            if let orderModel = manager.fetchJSONData(UserReformer()) as? OrderAddModel {
                if (orderModel.target?.allowPay ?? false) {
                    if orderModel.payUrl != nil {
                        goAlipay(orderModel.payUrl!)
                    }
                } else {
                    if let payUrl = orderModel.payUrl, payUrl.isEmpty {      ///余额支付
                        tableView.reloadData()
                        XSAlert.show(type: .success, text: "充值成功")
                        getInvestVC()?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is CoinListApi {
            NicooErrorView.showErrorMessage(.noData, on: view) {
                self.loadCoinsData()
            }
        }
        if manager is UserOrderAddApi {
            showServerWarningAlert(msg: manager.errorMessage)
        }
    }
}

// MARK: - Layout
private extension CoinController {
    
    func layoutPageSubviews() {
        layoutTableView()
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(0)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(0)
            }
        }
    }
}


