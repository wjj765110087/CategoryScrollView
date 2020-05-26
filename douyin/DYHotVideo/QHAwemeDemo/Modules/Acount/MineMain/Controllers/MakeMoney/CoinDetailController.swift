//
//  CoinDetailController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/19.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import MJRefresh
import NicooNetwork

class CoinDetailController: QHBaseViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "金币明细"
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
        table.rowHeight = BalanceDetailCell.cellHeight
        table.separatorStyle = .none
        table.mj_header = refreshView
        table.mj_footer = loadMoreView
        table.register(UINib(nibName: "BalanceDetailCell", bundle: Bundle.main), forCellReuseIdentifier: BalanceDetailCell.cellId)
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
    
    private lazy var coinDetailApi: UserCoinsDetailApi = {
        let api = UserCoinsDetailApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    
    var models: [CoinDetailModel] = [CoinDetailModel]()
    var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(navBar)
        view.addSubview(tableView)
        layoutPageSubviews()
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: safeAreaBottomHeight + 50, right: 0)
        loadData()
    }
    
    func loadData() {
        NicooErrorView.removeErrorMeesageFrom(view)
        let _ = coinDetailApi.loadData()
    }
    
    func loadNextpage() {
        let _ = coinDetailApi.loadNextPage()
    }
    
    private func endRefreshing() {
        refreshView.endRefreshing()
        loadMoreView.endRefreshing()
    }
}

extension CoinDetailController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BalanceDetailCell.cellId, for: indexPath) as! BalanceDetailCell
        if models.count > indexPath.row {
            cell.setCoinDetailModel(model: models[indexPath.row])
        }
        return cell
    }
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension CoinDetailController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        XSProgressHUD.showCustomAnimation(msg: "", onView: view, imageNames: nil, animated: true)
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if  manager is UserCoinsDetailApi {
            if let coinDetailList = manager.fetchJSONData(UserReformer()) as? CoinDetailListModel {
                if let models = coinDetailList.data, let currentPage = coinDetailList.current_page {
                    if currentPage == 1 {
                        self.models = models
                        if models.count == 0 {
                            NicooErrorView.showErrorMessage(.noData, on: view, topMargin: safeAreaTopHeight + 100) {
                                self.loadData()
                            }
                        }
                    } else {
                        self.models.append(contentsOf: models)
                    }
                    loadMoreView.isHidden = models.count < UserCoinsDetailApi.kDefaultCount
                }
                tableView.reloadData()
                self.endRefreshing()
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserCoinsDetailApi {
            NicooErrorView.showErrorMessage(.noNetwork, on: view) {
                self.loadData()
            }
        }
    }
}


// MARK: - QHNavigationBarDelegate
extension CoinDetailController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Description
private extension CoinDetailController {
    
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
