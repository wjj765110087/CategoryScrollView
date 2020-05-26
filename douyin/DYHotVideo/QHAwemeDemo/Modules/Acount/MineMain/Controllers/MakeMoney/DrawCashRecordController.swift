//
//  DrawCashRecordController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/6/1.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork
import MJRefresh

class DrawCashRecordController: UIViewController {

    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "明细"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = ConstValue.kViewLightColor
        bar.lineView.backgroundColor = ConstValue.kVcViewColor
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
        table.separatorStyle = .none
        table.register(UINib(nibName: "MoneyRecordCell", bundle: Bundle.main), forCellReuseIdentifier: MoneyRecordCell.cellId)
        table.mj_header = refreshView
        table.mj_footer = loadMoreView
        return table
    }()
    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadMore = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.loadNextpage()
        })
        loadMore?.setTitle("", for: .idle)
        loadMore?.setTitle("加载中...", for: .refreshing)
        loadMore?.setTitle("啊，已经到底了", for: .noMoreData)
        loadMore?.stateLabel.font = ConstValue.kRefreshLableFont
        return loadMore!
    }()
    lazy private var refreshView: MJRefreshGifHeader = {
        weak var weakSelf = self
        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
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
    private lazy var recordsApi: UserWalletRecordsApi = {
        let api = UserWalletRecordsApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    var waletRecords = [WalletRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
        loadData()
    }
    
    private func setUpSubviews() {
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(navBar)
        view.addSubview(tableView)
        layoutPageSubviews()
    }

    private func loadData() {
        NicooErrorView.removeErrorMeesageFrom(view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        let _ = recordsApi.loadData()
    }
    
    private func loadNextpage() {
        let _ = recordsApi.loadNextPage()
    }
    
    private func loadDataSuccess(_ model: WalletRecordLs) {
        endRefreshing()
        if let waletLs = model.data, let page = model.current_page {
            if page == 1 {
                waletRecords = waletLs
                if waletRecords.count == 0 {
                    NicooErrorView.showErrorMessage("暂无记录", on: view, customerTopMargin: safeAreaTopHeight + 60) {
                        self.loadData()
                    }
                }
            } else {
                waletRecords.append(contentsOf: waletLs)
            }
            tableView.reloadData()
        }
    }
    
    private func endRefreshing() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
    
}

// MARK: - QHNavigationBarDelegate
extension DrawCashRecordController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DrawCashRecordController: UITableViewDataSource, UITableViewDelegate {
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waletRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoneyRecordCell.cellId, for: indexPath) as! MoneyRecordCell
        let model = waletRecords[indexPath.row]
        cell.titlelab.text = model.record_type_label ??  ""
        cell.timeLab.text = model.created_at ?? ""
        cell.countlab.text = "\(model.money ?? "0.00")"
        if let money = model.money {
            if money.hasPrefix("-") {
                cell.countlab.textColor = UIColor.init(r: 215, g: 58, b: 45)
            } else {
                cell.countlab.textColor = UIColor.init(r: 40, g: 125, b: 246)
            }
        }
        return cell
    }
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension DrawCashRecordController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if  manager is UserWalletRecordsApi {
            if let wallet = manager.fetchJSONData(UserReformer()) as? WalletRecordLs {
                loadDataSuccess(wallet)
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserWalletRecordsApi {
            NicooErrorView.showErrorMessage(.noNetwork, on: view) {
                self.loadData()
            }
        }
    }
}


// MARK: - Description
private extension DrawCashRecordController {
    
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
