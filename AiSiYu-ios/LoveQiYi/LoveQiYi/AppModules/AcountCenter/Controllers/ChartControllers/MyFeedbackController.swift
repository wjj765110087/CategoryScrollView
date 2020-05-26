//
//  MyFeedbackController.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/6/7.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit
import NicooNetwork

class MyFeedbackController: BaseViewController {

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = true
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(UINib.init(nibName: "MyFeedCell", bundle: Bundle.main), forCellReuseIdentifier: MyFeedCell.cellId)
        table.mj_header = refreshView
        table.mj_footer = loadMoreView
        return table
    }()
    
    private lazy var feedlsApi: UserFeedLsApi = {
        let api = UserFeedLsApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    var feedModels = [FeedModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.titleLabel.text = "我的反馈"
        view.addSubview(tableView)
        layoutPageSubviews()
        loadData()
        view.bringSubviewToFront(navBar)
    }
    
    private func loadData() {
        NicooErrorView.removeErrorMeesageFrom(view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        let _  = feedlsApi.loadData()
    }
    
    override func loadFirstPage() {
        let _  = feedlsApi.loadData()
    }
    
    override func loadNextPage() {
        
    }
    
    private func loadDataSuccess(_ model: FeedLsModel) {
        if let models = model.data, let currentPage = model.current_page {
            if currentPage == 1 {
                feedModels = models
            } else {
                feedModels.append(contentsOf: models)
            }
            loadMoreView.isHidden = models.count < UserFeedLsApi.kDefaultCount
        }
        endRefreshing()
        tableView.reloadData()
    }
    
    func endRefreshing() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension MyFeedbackController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyFeedCell.cellId, for: indexPath) as! MyFeedCell
        let model = feedModels[indexPath.row]
        cell.titlelab.text = model.remark ?? ""
        cell.timelab.text = model.created_at ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let chartvc = ChartController()
        chartvc.feedModel = feedModels[indexPath.row]
        navigationController?.pushViewController(chartvc, animated: true)
    }
    
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension MyFeedbackController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserFeedLsApi {
            if let lsModel = manager.fetchJSONData(UserReformer()) as? FeedLsModel {
                loadDataSuccess(lsModel)
            }
        }
       
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserFeedLsApi {
            NicooErrorView.showErrorMessage(.noNetwork, on: view, topMargin: screenHeight/2 - 30) {
                self.loadData()
            }
        }
    }
}


// MARK: - Description
private extension MyFeedbackController {
    func layoutPageSubviews() {
        layoutTableView()
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    
}
