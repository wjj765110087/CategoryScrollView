//
//  CollectedLsController.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/25.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import UIKit
import NicooNetwork

class CollectedLsController: BaseViewController {

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = true
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(UINib(nibName: "CollectedVideoCell", bundle: Bundle.main), forCellReuseIdentifier: CollectedVideoCell.cellId)
        table.mj_header = refreshView
        table.mj_footer = loadMoreView
        return table
    }()
    private lazy var hisLsApi: HistoryApi = {
        let api = HistoryApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var collectedApi: CollectedLsApi = {
        let api = CollectedLsApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    var isHistory: Bool = false
    
    var currentPage = 0
    var videoLsModel = VideoListModel()
    var videoModels = [VideoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        layoutTableView()
        navConfig()
        loadData()
    }
    
    override func loadFirstPage() {
        if isHistory {
            _ = hisLsApi.loadData()
        } else {
            _ = collectedApi.loadData()
        }
    }
    override func loadNextPage() {
        if isHistory {
            _ = hisLsApi.loadNextPage()
        } else {
            _ = collectedApi.loadNextPage()
        }
    }
    override func rightButtonClick(_ sender: UIButton) {
        if videoModels.count == 0 { return }
        let editVc = HisEditeController()
        var cellModels = [CellModel]()
        for model in videoModels{
            let model = CellModel.init(model: model, isSelected: false)
            cellModels.append(model)
        }
        editVc.dataSource = cellModels
        editVc.isHistory = self.isHistory
        editVc.backActionHandler = {
            self.loadData()
        }
        present(editVc, animated: false, completion: nil)
    }
    
    private func navConfig() {
        rightBtn.isHidden = false
        rightBtn.setTitle("编辑", for: .normal)
        navBar.titleLabel.text = isHistory ? "观看历史" : "我的收藏"
        view.bringSubviewToFront(navBar)
    }
    
    // 数据请求
    func loadData() {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: self.view, imageNames: nil, bgColor: UIColor.clear, animated: false)
        NicooErrorView.removeErrorMeesageFrom(view)
        if isHistory {
            _ = hisLsApi.loadData()
        } else {
            _ = collectedApi.loadData()
        }
    }
  
    private func loadHistoryDataSuccess(_ model: VideoListModel) {
        if let models = model.data {
            if hisLsApi.pageNumber == 1 {
                videoModels = models
                if videoModels.count == 0 {
                    NicooErrorView.showErrorMessage(.noData, on: view, topMargin: statusBarHeight + 94, clickHandler: nil)
                }
            } else {
                videoModels.append(contentsOf: models)
            }
            endFreshing()
            loadMoreView.isHidden = models.count < HistoryApi.kDefaultCount
            currentPage = hisLsApi.pageNumber
            tableView.reloadData()
        }
    }
    
    private func loadCollectedDataSuccess(_ model: VideoListModel) {
        if let models = model.data {
            if collectedApi.pageNumber == 1 {
                videoModels = models
                if videoModels.count == 0 {
                    NicooErrorView.showErrorMessage(.noData, on: view, topMargin: statusBarHeight + 94, clickHandler: nil)
                }
            } else {
                videoModels.append(contentsOf: models)
            }
            endFreshing()
            loadMoreView.isHidden = models.count < CollectedLsApi.kDefaultCount
            currentPage = collectedApi.pageNumber
            tableView.reloadData()
        }
    }
    private func endFreshing() {
        refreshView.endRefreshing()
        loadMoreView.endRefreshing()
    }
    
    private func goDetail(_ model: VideoModel) {
        let detailVC = VideoDetailViewController()
        detailVC.model = model
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CollectedLsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 170*9/16 + 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return videoModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectedVideoCell.cellId, for: indexPath) as! CollectedVideoCell
        let model = videoModels[indexPath.row]
        cell.setModdel(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        goDetail(videoModels[indexPath.row])
    }
    
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension CollectedLsController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
       return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is HistoryApi {
            if let modules = manager.fetchJSONData(HotReformer()) as? VideoListModel {
                videoLsModel = modules
                loadHistoryDataSuccess(modules)
            }
        }
        if manager is CollectedLsApi {
            if let modules = manager.fetchJSONData(HotReformer()) as? VideoListModel {
                videoLsModel = modules
                loadCollectedDataSuccess(modules)
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if currentPage == 0 {
            NicooErrorView.showErrorMessage(.noNetwork, on: view, topMargin: safeAreaTopHeight) {
                self.loadData()
            }
        }
    }
}

// MARK: - Layout
private extension CollectedLsController {
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(0)
            }
        }
        
    }
}
