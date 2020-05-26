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

class PayRecordController: UIViewController {

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "充值记录"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.init(r: 30, g: 31, b: 50)
        bar.delegate = self
        return bar
    }()
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
    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadmore = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.loadNextPage()
        })
        loadmore?.stateLabel.font = ConstValue.kRefreshLableFont
        loadmore?.setTitle("", for: .idle)
        loadmore?.setTitle("已经到底了", for: .noMoreData)
        loadmore?.isHidden = true
        return loadmore!
    }()
    lazy private var refreshView: MJRefreshGifHeader = {
        weak var weakSelf = self
        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
            weakSelf?.isRefreshOperation = true
            weakSelf?.loadData()
        })
        var gifImages = [UIImage]()
        for string in ConstValue.refreshImageNames {
            gifImages.append(UIImage(named: string)!)
        }
        mjRefreshHeader?.setImages(gifImages, for: .refreshing)
        mjRefreshHeader?.setImages(gifImages, for: .idle)
        mjRefreshHeader?.stateLabel.font = ConstValue.kRefreshLableFont
        mjRefreshHeader?.lastUpdatedTimeLabel.font = ConstValue.kRefreshLableFont
        return mjRefreshHeader!
    }()
    
    /// 是否是下拉刷新操作
    private var isRefreshOperation = false
    private lazy var payRecordApi: UserOrderListApi = {
        let api = UserOrderListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    var orderList = [OrderInfoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 22/255.0, green: 24/255.0, blue: 36/255.0, alpha: 0.99)
        view.addSubview(navBar)
        view.addSubview(tableView)
        layoutPageSubviews()
        loadMoreView.isHidden = true
        loadData()
        
    }
    
    private func loadData() {
        NicooErrorView.removeErrorMeesageFrom(self.view)
        if !isRefreshOperation {
            XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        } else {
            isRefreshOperation = false
        }
        let _ = payRecordApi.loadData()
    }
    
    private func loadNextPage() {
        let _ = payRecordApi.loadNextPage()
    }
    
    private func orderListSuccess(_ listModel: OrderListModel) {
        if let models = listModel.data, let currentPage = listModel.current_page {
            if currentPage ==  1 {
                orderList = models
                if orderList.count == 0 {
                    NicooErrorView.showErrorMessage("你还没有消费记录，快去购买会员卡吧～", on: view, customerTopMargin: nil, clickHandler: nil)
                }
                if orderList.count == UserOrderListApi.kDefaultCount {
                    loadMoreView.isHidden = false
                } else {
                     loadMoreView.isHidden = true
                }
            } else {
                orderList.append(contentsOf: models)
                if models.count == UserOrderListApi.kDefaultCount {
                    loadMoreView.isHidden = false
                } else {
                    loadMoreView.isHidden = true
                }
            }
        }
        endRefreshing()
        tableView.reloadData()
    }
    private func orderListFailed() {
        NicooErrorView.showErrorMessage(.noNetwork, on: view) {
            self.loadData()
        }
    }
    
    private func  endRefreshing() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
}

// MARK: - QHNavigationBarDelegate
extension PayRecordController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
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
        cell.cardNameLab.text = orderModel.vc_title ?? ""
        cell.payStatuImg.image = UIImage(named: (orderModel.pay_status ?? 0) == 1 ? "paySuccessTips" :"payFailedTips")
        cell.priceLab.text = "¥" + "\(orderModel.price_current ?? "0.00")"
        cell.daysLable.text = "使用天数: \(orderModel.vc_daily_until ?? 0)"
        cell.orderNumber.text = "订单编号: \(orderModel.order_no ?? "暂无")"
        cell.payTimeLab.text = "交易时间: \(orderModel.paid_at ?? "0")"
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension PayRecordController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
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
            NicooErrorView.showErrorMessage(.noNetwork, on: view) {
                self.loadData()
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
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    
    
}
