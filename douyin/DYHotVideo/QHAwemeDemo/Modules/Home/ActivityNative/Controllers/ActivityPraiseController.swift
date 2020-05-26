//
//  ActivityPraiseController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import MJRefresh
import NicooNetwork

class ActivityPraiseController: QHBaseViewController {
    
    private lazy var tableView: CommunityTableView = {
        let tableView = CommunityTableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.register(UINib(nibName: "RankCell", bundle: Bundle.main), forCellReuseIdentifier: RankCell.cellId)
        tableView.mj_footer = loadMoreView
        return tableView
    }()
    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadmore = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.loadNextpage()
        })
        loadmore?.isHidden = true
        loadmore?.stateLabel.font = ConstValue.kRefreshLableFont
        return loadmore!
    }()
    lazy private var refreshView: MJRefreshGifHeader = {
        weak var weakSelf = self
        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
            weakSelf?.loadFirstpage()
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
    private lazy var rankListApi: ActivityRankListApi = {
        let api = ActivityRankListApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    /// 用于解决滑动跟随问题
    var lastContentOffset: CGFloat = 0
    var headerHeight: CGFloat = screenWidth*0.4 + 160
    var scrollDownToTopHandler:((_ canScroll: Bool)->Void)?

    var topicId: Int = 0
    var key: String = ActivityItemKey.Dynamic_Praise.rawValue
    
    var dataSource = [TopicRankModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.contentInset = UIEdgeInsets(top: UIDevice.current.isiPhoneXSeriesDevices() ? safeAreaTopHeight : safeAreaTopHeight + 10, left: 0, bottom: UIDevice.current.isiPhoneXSeriesDevices() ? 83: 83, right: 0)
        layoutPageViews()
        loadData()
    }
    
    private func loadData() {
        NicooErrorView.removeErrorMeesageFrom(view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        let _ = rankListApi.loadData()
      
    }
    private func loadFirstpage() {
        
    }
    private func loadNextpage() {
        let _ = rankListApi.loadNextPage()
    }
    
    private func endRefreshing() {
        loadMoreView.endRefreshing()
        refreshView.endRefreshing()
        XSProgressHUD.hide(for: view, animated: false)
    }
    
    private func loadTopicListSuccess(_ list: TopicRankLsModel) {
        if let data = list.data {
            if rankListApi.pageNumber == 1 {
                dataSource = data
            } else {
                dataSource.append(contentsOf: data)
            }
            loadMoreView.isHidden = data.count < ActivityRankListApi.kDefaultCount
            if dataSource.count == 0 {
                NicooErrorView.showErrorMessage(.noData
                , "还没有人上榜，快去发布作品吧！", on: view, topMargin: 0) {
                    self.loadData()
                }
            }
        }
        endRefreshing()
        tableView.reloadData()
    }
    
    private func getCurrentVC() -> ActivityMainController? {
        var next = view.superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is ActivityMainController) {
                return nextResponder as? ActivityMainController
            }
            next = next?.superview
        }
        return nil
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension ActivityPraiseController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RankCell.cellId, for: indexPath) as! RankCell
        let keys = ActivityItemKey.init(rawValue: key)
        if keys == .Dynamic_Praise {
            cell.setTopicRankModel(model: dataSource[indexPath.row])
        } else if keys == .Coins_Video {
            cell.setCoinsRankModel(model: dataSource[indexPath.row])
        }
        cell.rankLabel.font = UIFont.systemFont(ofSize: 18)
        cell.rankLabel.textColor = (dataSource[indexPath.row].top ?? 0) < 4 ? ConstValue.kTitleYelloColor : UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RankCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let keys = ActivityItemKey.init(rawValue: key)
        if keys == .Dynamic_Praise {
            let model = dataSource[indexPath.row]
            let topicDetail = TopicsDetailController()
            if model.id != nil {
                topicDetail.topicId = model.id!
            }
            getCurrentVC()?.navigationController?.pushViewController(topicDetail, animated: true)
        } else if keys == .Coins_Video {
            let playVideoVC = SeriesPlayController()
            var videos = [VideoModel]()
            for model in dataSource {
                if let video = model.video_model {
                    videos.append(video)
                } else {
                    videos.append(VideoModel())
                }
            }
            playVideoVC.videos = videos
            playVideoVC.currentIndex = indexPath.row
            playVideoVC.currentPlayIndex = indexPath.row
            playVideoVC.goVerbOrRefreshActionHandler = { [weak self] (isVerb) in
                if isVerb {
                    let vipvc = InvestController()
                    vipvc.currentIndex = 0
                    self?.navigationController?.pushViewController(vipvc, animated: false)
                } else {
                    self?.loadData()
                }
            }
            let nav = UINavigationController(rootViewController: playVideoVC)
            nav.modalPresentationStyle = .fullScreen
            getCurrentVC()?.present(nav, animated: true, completion: nil)
        }
    }
}

// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension ActivityPraiseController: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        return [ActivityRankListApi.kKey: key, ActivityRankListApi.kTopic: topicId]
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if let model = manager.fetchJSONData(CommunityReformer()) as? TopicRankLsModel {
            loadTopicListSuccess(model)
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        
    }
    
    
}

// MARK: - UIScrollViewDelegate
extension ActivityPraiseController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let height = scrollView.frame.size.height
        let distanceFormBottm = scrollView.contentSize.height - offsetY
        let offset = offsetY - lastContentOffset
        lastContentOffset = offsetY
        if offset > 0 && offsetY > -20 {
            if offsetY > headerHeight {
                scrollDownToTopHandler?(false)
            }
        }
        if offset < 0 && distanceFormBottm > height {
            if offsetY <= 350 { /// 这个数字不能太大， 也不太小（理论上越大感觉越流畅）
                scrollDownToTopHandler?(true)
            }
        }
    }
}

//MARK: -Layout
private extension ActivityPraiseController {
    
    func layoutPageViews() {
        layoutTableView()
    }
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.leading.trailing.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                // Fallback on earlier versions
                make.bottom.equalToSuperview()
            }
        }
    }
}
