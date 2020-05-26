//
//  DiscoverTopicController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/7.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  搜索话题

import UIKit
import MJRefresh
import NicooNetwork

class DiscoverTopicController: QHBaseViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = true
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(CommunityRecommandCell.classForCoder(), forCellReuseIdentifier: CommunityRecommandCell.cellId)
        table.register(SearchOtherNoDataHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: SearchOtherNoDataHeader.reuseId)
        table.mj_header = refreshView
        table.mj_footer = loadMoreView
        //table.bounces = false
        return table
    }()
    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadmore = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.loadNextpage()
            weakSelf?.loadRecommandTopicNextPage()
        })
        loadmore?.setTitle("", for: .idle)
        loadmore?.setTitle("已经到底了", for: .noMoreData)
        loadmore?.stateLabel.font = ConstValue.kRefreshLableFont
        loadmore?.isHidden = true
        return loadmore!
    }()
    
    lazy private var refreshView: MJRefreshGifHeader = {
        weak var weakSelf = self
        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
            weakSelf?.firstRefresh()
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
    
    private lazy var recommandToicApi: RecommandTopicApi = {
        let api = RecommandTopicApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    
    private let viewModel = CommunityViewModel()
    private var pageNumber: Int = 0
    private var dataSource = [TalksModel]()
    private var actionIndex: Int = 0
    
    var searchKey: String?
    
    var isSearchHasResult: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(tableView)
        layoutPageSubviews()
        tableView.contentInset = UIEdgeInsets(top: UIDevice.current.isXSeriesDevices() ? safeAreaTopHeight: 44 , left: 0, bottom: UIDevice.current.isXSeriesDevices() ? 83 : 49, right: 0)
        addViewModelCallback()
        loadTopicSearch()
    }

    private func loadTopicSearch() {
        NicooErrorView.removeErrorMeesageFrom(view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        viewModel.loadTalksSearchList([TalksSearchListApi.kTitle : searchKey ?? ""])
    }
    private func firstRefresh() {
        viewModel.loadTalksSearchList([TalksSearchListApi.kTitle : searchKey ?? ""])
    }
    private func loadNextpage() {
        viewModel.loadTalksSearchNextPage([TalksSearchListApi.kTitle : searchKey ?? ""])
    }
    /// 加关注
    private func addFollow(_ topicId: Int) {
        let params: [String: Any] = [TalksAddFollowApi.kTalkId: topicId]
        viewModel.loadTalksAddFollow(params)
    }
    /// 取消关注
    private func deleteFollow(_ topicId: Int) {
        let params: [String: Any] = [TalksAddFollowApi.kTalkId: topicId]
        viewModel.loadTalksDelFollow(params)
    }
    
    private func endRefreshing() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
    
    ///精彩推荐
    private func loadRecommandTopicData() {
        let _ = recommandToicApi.loadData()
    }
    
    private func loadRecommandTopicNextPage() {
        let _ = recommandToicApi.loadNextPage()
    }
}

// MARK: - Privite Funs
private extension DiscoverTopicController {
    
    func addViewModelCallback() {
        viewModel.talksListApiSuccess = { [weak self] (models, pageNumber) in
            self?.pageNumber = pageNumber
            self?.loadDataSuccess(models)
        }
        viewModel.talksListApiApiFail = { [weak self] in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for:strongSelf.view, animated: false)
            strongSelf.endRefreshing()
            if strongSelf.pageNumber == 0 {
                NicooErrorView.showErrorMessage(.noNetwork, on: strongSelf.view, topMargin: safeAreaTopHeight, clickHandler: {
                    strongSelf.loadTopicSearch()
                })
            }
        }
        viewModel.talksAddOrDelFollowSuccess = { [weak self] isAdd in
            guard let strongSelf = self else { return }
            strongSelf.dataSource[strongSelf.actionIndex].has_count = isAdd ? .follow : .noFollow
            strongSelf.tableView.reloadRows(at: [IndexPath(row: strongSelf.actionIndex, section: 0)], with: .automatic)
        }
        viewModel.talksAddOrDelFollowFail = { (msg, isAdd) in
            XSAlert.show(type: .error, text: msg)
        }
    }
    func loadDataSuccess(_ listModels: [TalksModel]?) {
        endRefreshing()
        XSProgressHUD.hide(for:view, animated: false)
        if let dataList = listModels {
            if pageNumber == 1 {
                dataSource = dataList
                if dataList.count == 0 {
                    loadRecommandTopicData()
                    //加载无数据占位
//                    NicooErrorView.showErrorMessage(.noData, "暂未搜索到相关话题", on: view) {
//                        self.loadTopicSearch()
//                    }
                }
            } else {
                dataSource.append(contentsOf: dataList)
            }
            
            if dataList.count == 0 {
                ///获取推荐话题的列表
                loadRecommandTopicData()
                isSearchHasResult = false
            } else {
                isSearchHasResult = true
            }
            
            loadMoreView.isHidden = (dataList.count < TalksListApi.kDefaultCount)
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DiscoverTopicController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CommunityRecommandCell.cellHeight
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommunityRecommandCell.cellId, for: indexPath) as! CommunityRecommandCell
        let model = dataSource[indexPath.item]
        cell.setModel(model)
        cell.addTalksClickHandler = { [weak self] in
            self?.actionIndex = indexPath.row
            if model.has_count == nil { return }
            if model.id == nil { return }
            if model.has_count! == .follow {
                self?.deleteFollow(model.id!)
            } else {
                self?.addFollow(model.id!)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchOtherNoDataHeader.reuseId) as! SearchOtherNoDataHeader
        header.label.text = "未搜索到任何相关内容"
        if dataSource.count >= 0  {
            if isSearchHasResult {
                header.recommentlabel.text = ""
            } else {
                header.recommentlabel.text = "精彩推荐"
            }
        } else {
            header.recommentlabel.text = "精彩推荐"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if dataSource.count >= 0 {
            if isSearchHasResult {
                return 0.0001
            }
            return SearchOtherNoDataHeader.headerHeight
        }
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let talkVc = TalksMainController()
        talkVc.talksModel = dataSource[indexPath.item]
        getCurrentVC()?.navigationController?.pushViewController(talkVc, animated: true)
        talkVc.addFollowOrDelCallBack = {
            self.tableView.reloadData()
        }
    }
    
    func getCurrentVC() -> DiscoverSearchResultController? {
        var next = view.superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is DiscoverSearchResultController) {
                return nextResponder as? DiscoverSearchResultController
            }
            next = next?.superview
        }
        return nil
    }
}

extension DiscoverTopicController: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is RecommandTopicApi {
            if let topicSearchList = manager.fetchJSONData(SearchReformer()) as? TalksListModel {
                if let data = topicSearchList.data, let current_page = topicSearchList.current_page {
                    if current_page == 1 {
                        dataSource = data
                        if data.count == 0 {
                            
                        }
                    } else {
                        dataSource.append(contentsOf: data)
                    }
                    endRefreshing()
                    tableView.reloadData()
                }
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        endRefreshing()
        if manager is RecommandTopicApi  {
            
        }
    }
}



// MARK: - Layout
private extension DiscoverTopicController {
    
    func layoutPageSubviews() {
        layoutTableView()
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
            make.leading.trailing.top.equalToSuperview()
        }
    }
}
