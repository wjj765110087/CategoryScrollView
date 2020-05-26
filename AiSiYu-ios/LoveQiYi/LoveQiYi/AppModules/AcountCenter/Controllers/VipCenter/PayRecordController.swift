//
//  PayRecordController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork
import MJRefresh

class PayRecordController: BaseViewController {

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = false
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(UINib(nibName: "PayRecordCell", bundle: Bundle.main), forCellReuseIdentifier: PayRecordCell.cellId)
        table.mj_footer = loadMoreView
        table.mj_header = refreshView
        return table
    }()
    private lazy var payRecordApi: UserOrderListApi = {
        let api = UserOrderListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    var currentPage = 0
    var orderList = [OrderInfoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(navBar)
        view.addSubview(tableView)
        layoutPageSubviews()
        navConfig()
        loadData()
    }
    
    private func loadData() {
        NicooErrorView.removeErrorMeesageFrom(self.view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        let _ = payRecordApi.loadData()
    }
    
    override func loadNextPage() {
        let _ = payRecordApi.loadNextPage()
    }
    
    override func loadFirstPage() {
        let _ = payRecordApi.loadData()
    }
    
    private func orderListSuccess(_ listModel: OrderListModel) {
        if let models = listModel.data  {
            if payRecordApi.pageNumber ==  1 {
                orderList = models
                if orderList.count == 0 {
                    NicooErrorView.showErrorMessage(.noData, on: view, topMargin: safeAreaTopHeight + 5, clickHandler: nil)
                }
            } else {
                orderList.append(contentsOf: models)
            }
            currentPage = payRecordApi.pageNumber
            loadMoreView.isHidden = models.count < UserOrderListApi.kDefaultCount
        }
        endRefreshing()
        tableView.reloadData()
    }
    
    private func  endRefreshing() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
    
    private func navConfig() {
        navBar.titleLabel.text = "购买记录"
        view.bringSubviewToFront(navBar)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PayRecordController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PayRecordCell.cellId, for: indexPath) as! PayRecordCell
        let orderModel = orderList[indexPath.row]
        cell.cardNameLab.text = orderModel.recharge_title ?? ""
        cell.payStatuImg.image = UIImage(named: (orderModel.pay_status ?? 0) == 1 ? "paySuccessTips" :"payFailedTips")
        cell.priceLab.text = "¥" + "\(orderModel.price ?? "0.00")"
        cell.daysLable.text = "使用天数: \(orderModel.recharge_title ?? "")"
        cell.orderNumber.text = "订单编号: \(orderModel.order_no ?? "暂无")"
        cell.payTimeLab.text = "交易时间: \(orderModel.paid_at ?? "--")"
        return cell
    }
    
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension PayRecordController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserOrderListApi {
            if let orderList = manager.fetchJSONData(UserReformer()) as? OrderListModel {
                orderListSuccess(orderList)
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserOrderListApi {
            if currentPage == 0  {
                NicooErrorView.showErrorMessage(.noNetwork, on: view, topMargin: safeAreaTopHeight + 10) {
                    self.loadData()
                }
            } else {
                endRefreshing()
                XSAlert.show(type: .error, text: manager.errorMessage)
            }
        }
    }
}


// MARK: - Layout
private extension PayRecordController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutTableView()
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(statusBarHeight + 44)
        }
    }
    
    
}
