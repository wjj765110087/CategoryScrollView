//
//  DiscoverTrendsController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/7.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  搜索动态

import UIKit
import MJRefresh

class DiscoverTrendsController: QHBaseViewController {
    
    lazy var topButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "goTopUp"), for: .normal)
        button.setBackgroundImage(UIImage(named: "goTopUpBG"), for: .normal)
        button.alpha = 0.9
        button.addTarget(self, action: #selector(gotoTop), for: .touchUpInside)
        return button
    }()
    lazy var tableView: CommunityTableView = {
        let tableView = CommunityTableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CommunityTextCell.classForCoder(), forCellReuseIdentifier: CommunityTextCell.cellId)
        tableView.register(CommunitySinglePictureCell.classForCoder(), forCellReuseIdentifier: CommunitySinglePictureCell.cellId)
        tableView.register(CommunityImagesCell.classForCoder(), forCellReuseIdentifier: CommunityImagesCell.cellId)
        tableView.register(CommunityVideoCell.classForCoder(), forCellReuseIdentifier: CommunityVideoCell.cellId)
        tableView.register(TopicCellFooter.classForCoder(), forHeaderFooterViewReuseIdentifier: TopicCellFooter.footerId)
        tableView.register(TopicCellLineFooter.classForCoder(), forHeaderFooterViewReuseIdentifier: TopicCellLineFooter.footerId)
        tableView.mj_header = refreshView
        tableView.mj_footer = loadMoreView
        return tableView
    }()
    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadMore = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.loadNextPage()
            weakSelf?.loadRecommandTrendNextPage()
        })
        loadMore?.isHidden = true
        loadMore?.stateLabel.font = ConstValue.kRefreshLableFont
        return loadMore!
    }()
    lazy private var refreshView: MJRefreshGifHeader = {
        weak var weakSelf = self
        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
            weakSelf?.loadFirstPage()
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
    
    lazy var headerView: SearchOtherNoDataHeaderView = SearchOtherNoDataHeaderView.init(frame: .zero)
    
    var searchKey: String?
    
    private var dataSource = [TopicModel]()
    private var pageNumber: Int = 0
    private var favorIndex: Int = 0
    
    private let viewModel = CommunityViewModel()
    private let userViewModel = UserInfoViewModel()
    
    private let discoverViewModel = DiscoverViewModel()
    
    var isSearchHasResult: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(topButton)
        layoutPageSubviews()
        tableView.contentInset = UIEdgeInsets(top: UIDevice.current.isiPhoneXSeriesDevices() ? safeAreaTopHeight : 44, left: 0, bottom: UIDevice.current.isiPhoneXSeriesDevices() ? 83 : 34, right: 0)
        addViewModelCallBack()
        loadTopicListData()
    }
    
    func loadTopicListData() {
        NicooErrorView.removeErrorMeesageFrom(self.view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        let params: [String: Any] = [TopicSearchListApi.kTitle: searchKey ?? ""]
        viewModel.loadSearchTopicList(params)
    }
    @objc func gotoTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
// MARK: - Private - Funcs
private extension DiscoverTrendsController {
    
    func loadFirstPage() {
        let params: [String: Any] = [TopicSearchListApi.kTitle: searchKey ?? ""]
        viewModel.loadSearchTopicList(params)
    }
    func loadNextPage() {
        let params: [String: Any] = [TopicSearchListApi.kTitle: searchKey ?? ""]
        viewModel.loadSearchTopicListNextPage(params)
    }
    func endRefreshing() {
        loadMoreView.endRefreshing()
        refreshView.endRefreshing()
    }
    
    ///精彩推荐
    func loadRecommandTrendData() {
        discoverViewModel.loadRecommandTrendData(nil)
    }

    func loadRecommandTrendNextPage() {
        discoverViewModel.loadRecommandTrendNextPage(nil)
    }
    
    func addViewModelCallBack() {
        viewModel.topicListApiSuccess = { [weak self] (topiclist, pageNumber, _ ) in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for:strongSelf.view, animated: false)
            strongSelf.pageNumber = pageNumber
            strongSelf.loadListSuccess(topiclist)
        }
        viewModel.topicListApiApiFail = { [weak self] in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for:strongSelf.view, animated: false)
            strongSelf.endRefreshing()
            if strongSelf.pageNumber == 0 {
                NicooErrorView.showErrorMessage(.noNetwork, on: strongSelf.view, topMargin: safeAreaTopHeight, clickHandler: {
                    strongSelf.loadTopicListData()
                })
            }
        }
        viewModel.topicFavorSuccess = { [weak self] in
            guard let strongSelf = self else { return }
            let model = strongSelf.dataSource[strongSelf.favorIndex]
            if (model.is_like ?? .unlike) == .unlike {
                model.is_like = .like
                model.like = (model.like ?? 0) + 1
            } else {
                model.is_like = .unlike
                model.like = (model.like ?? 0) - 1
            }
            strongSelf.tableView.reloadSections([strongSelf.favorIndex], with: .none)
        }
        /// UserInfoViewModel
        userViewModel.followAddOrCancelSuccessHandler = { [weak self] isAdd, _ in
            guard let strongSelf = self else { return }
            let model = strongSelf.dataSource[strongSelf.favorIndex]
            if isAdd {
                model.user?.followed = .focus
                model.is_attention = .recommend
            } else {
                model.user?.followed = .notFocus
                model.is_attention = .noRecommend
            }
            strongSelf.tableView.reloadSections([strongSelf.favorIndex], with: .none)
        }
        userViewModel.followOrCancelFailureHandler = { (isAdd, msg) in
            XSAlert.show(type: .error, text: msg)
        }
        
        discoverViewModel.requestRecommandTrendSuccessHandler = { [weak self] listModel in
            guard let strongSelf = self else { return }
            if let dataList = listModel.data, let pageNumber = listModel.current_page {
                if pageNumber == 1 {
                    strongSelf.dataSource = dataList
                    if dataList.count == 0 {
                      
                    }
                } else {
                    strongSelf.dataSource.append(contentsOf: dataList)
                }
                strongSelf.loadMoreView.isHidden = (dataList.count < RecommandTrendApi.kDefaultCount)
                strongSelf.tableView.reloadData()
            }
        }
        
        discoverViewModel.requestRecommandTrendFailureHandler = { [weak self] msg in
            
        }
    }
    func loadListSuccess(_ listModels: [TopicModel]?) {
        endRefreshing()
        if let dataList = listModels {
            if pageNumber == 1 {
                dataSource = dataList
                if dataSource.count == 0 {
                       ///精彩推荐
                       loadRecommandTrendData()
                       isSearchHasResult = false
                       headerView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 100)
                       tableView.tableHeaderView = headerView
                   } else {
                       isSearchHasResult = true
                       headerView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 0)
                       tableView.tableHeaderView = nil
                   }
            } else {
                dataSource.append(contentsOf: dataList)
            }
            loadMoreView.isHidden = (dataList.count < TopicSearchListApi.kDefaultCount)
            tableView.reloadData()
        }
    }
    private func getCurrentVC() -> DiscoverSearchResultController? {
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

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DiscoverTrendsController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        return tableView.rowHeight
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = dataSource[indexPath.section]
        if model.type == TopicType.imgText {
            if let imageResource = model.resource {
                if imageResource.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTextCell.cellId, for: indexPath) as! CommunityTextCell
                    cell.setModel(model,.topicCenter)
                    cell.userViewActionHandler = { [weak self] actionId in
                        self?.userActions(actionId, indexPath.section)
                    }
                    cell.bottomActionHandler = { [weak self] actionId in
                        self?.bottomAction(actionId, indexPath.section)
                    }
                    return cell
                } else if imageResource.count == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CommunitySinglePictureCell.cellId, for: indexPath) as! CommunitySinglePictureCell
                    cell.setModel(model,.topicCenter)
                    cell.imageClickHandler = { [weak self] in
                        self?.showImages(model.resource, 0)
                    }
                    cell.userViewActionHandler = { [weak self] actionId in
                        self?.userActions(actionId, indexPath.section)
                    }
                    cell.bottomActionHandler = { [weak self] actionId in
                        self?.bottomAction(actionId, indexPath.section)
                    }
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CommunityImagesCell.cellId, for: indexPath) as! CommunityImagesCell
                    cell.setModel(model,.topicCenter)
                    cell.imagesClickHandler = { [weak self] (index) in
                        self?.showImages(model.resource, index)
                    }
                    cell.userViewActionHandler = { [weak self] actionId in
                        self?.userActions(actionId, indexPath.section)
                    }
                    cell.bottomActionHandler = { [weak self] actionId in
                        self?.bottomAction(actionId, indexPath.section)
                    }
                    return cell
                }
            }
            
        } else if model.type == .video {
            let cell = tableView.dequeueReusableCell(withIdentifier: CommunityVideoCell.cellId, for: indexPath) as! CommunityVideoCell
            cell.setModel(model,.topicCenter)
            cell.userViewActionHandler = { [weak self] actionId in
                self?.userActions(actionId, indexPath.section)
            }
            cell.bottomActionHandler = { [weak self] actionId in
                self?.bottomAction(actionId, indexPath.section)
            }
            cell.videoClickHandler = { [weak self] in
                self?.playVideo(indexPath.section)
            }
            return cell
        }
        
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let model = dataSource[section]
        if let comments = model.comments, comments.count > 0 {
            if comments.count < 2 { /// 最多展示3条
                return CGFloat(comments.count + 1) * 35.0 + 30.0
            } else {
                return 135.0
            }
        }
        return 1.0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let model = dataSource[section]
        if let comments = model.comments, comments.count > 0 {
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: TopicCellFooter.footerId) as! TopicCellFooter
            footer.setDatas(comments)
            footer.itemActionHandler = { [weak self] in
                self?.goCommentVc(section)
            }
            return footer
        } else {
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: TopicCellLineFooter.footerId) as! TopicCellLineFooter
            return footer
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataSource[indexPath.section]
        let topicDetail = TopicsDetailController()
        if model.id != nil {
            topicDetail.topicId = model.id!
        }
        getCurrentVC()?.navigationController?.pushViewController(topicDetail, animated: true)
    }
    
}

// MARK: - Cell Actions
private extension DiscoverTrendsController {
    
    //1. 用户点击 2.删除动态 3.对用户添加关注
    func userActions(_ actionId: Int, _ index: Int) {
        let topicModel = dataSource[index]
        if actionId == 1 {
            let userCenter = UserMCenterController()
            userCenter.user = topicModel.user
            getCurrentVC()?.navigationController?.pushViewController(userCenter, animated: true)
        } else if actionId == 3 {
            favorIndex = index
            if let focusStatu = topicModel.is_attention {
                if focusStatu == .recommend {  // 已关注，调用取消
                    userViewModel.loadCancleFollowApi([UserFollowStatuApi.kUserId: topicModel.user?.id ?? 0, UserFollowStatuApi.kSelfId: UserModel.share().userInfo?.id ?? 0])
                } else  { // 未关注，调用关注
                    userViewModel.loadAddFollowApi([UserFollowStatuApi.kUserId: topicModel.user?.id ?? 0, UserFollowStatuApi.kSelfId: UserModel.share().userInfo?.id ?? 0])
                }
            }
        }
    }
    /// actionId : 1.话题点击 2.评论点击 3.分享点击 4.点赞
    func bottomAction(_ actionId: Int, _ index: Int) {
        if actionId == 1 {
            let talksVc = TalksMainController()
            if let talkModel = dataSource[index].topic {
                talksVc.talksModel = talkModel
            }
            getCurrentVC()?.navigationController?.pushViewController(talksVc, animated: true)
        } else if actionId == 2 {
            goCommentVc(index)
        } else if actionId == 3 {
            let model = dataSource[index]
            if model.type == .video {
                if let videos = model.video, videos.count > 0 {
                    let video = videos[0]
                    UserModel.share().shareImageLink = video.cover_path
                }
            } else if model.type == .imgText {
                if let images = model.resource, images.count > 0 {
                    UserModel.share().shareImageLink = images[0]
                }
            }
            UserModel.share().shareText = getShareText(model.topic?.title , model.content)
            let shareVc = ShareContentController()
            shareVc.modalPresentationStyle = .overCurrentContext
            shareVc.definesPresentationContext = true
            shareVc.view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
            getCurrentVC()?.present(shareVc, animated: true, completion: nil)
        } else if actionId == 4 {
            favorIndex = index
            viewModel.loadTopicFavor([TopicFavorApi.kTopicId: dataSource[index].id ?? 0])
        }
    }
    /// 看大图
    func showImages(_ imageSource: [String]?, _ index: Int) {
        guard let images = imageSource else { return }
        // 网图加载器
        let loader = JXKingfisherLoader()
        // 数据源
        let source = JXNetworkingDataSource(photoLoader: loader, numberOfItems: { () -> Int in
            return images.count
        }, placeholder: { index -> UIImage? in
            return UIImage(named: "playCellBg")
        }) { index -> String? in
            return images[index]
        }
        // 视图代理，实现了光点型页码指示器
        let delegate = JXDefaultPageControlDelegate() // 视图代理，实现了光点型页码指示器
        // 转场动画
        let trans = JXPhotoBrowserZoomTransitioning { (browser, index, view) -> UIView? in
            return nil
        }
        // 打开浏览器
        JXPhotoBrowser(dataSource: source, delegate: delegate, transDelegate: trans)
            .show(pageIndex: index)
    }
    func goCommentVc(_ index: Int) {
        let commentVC = TopicCommentController()
        commentVC.topicId = dataSource[index].id ?? 0
        commentVC.userId = dataSource[index].user?.id ?? 0
        commentVC.modalPresentationStyle = .overCurrentContext
        commentVC.definesPresentationContext = true
        commentVC.view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        getCurrentVC()?.present(commentVC, animated: true, completion: nil)
        commentVC.userClickHandler = { [weak self] (user) in
            self?.goUserCenter(user)
            commentVC.dismiss(animated: false, completion: nil)
        }
        commentVC.buyVipClickHandler = {  [weak self] in
            let verb = InvestController()
            verb.currentIndex = 0
            self?.getCurrentVC()?.navigationController?.pushViewController(verb, animated: true)
            commentVC.dismiss(animated: false, completion: nil)
        }
    }
    func goUserCenter(_ user: UserInfoModel?) {
        let userCenter = UserMCenterController()
        userCenter.user = user
        getCurrentVC()?.navigationController?.pushViewController(userCenter, animated: true)
    }
    func playVideo(_ index: Int) {
        let controller = CommunityPlayController()
        let model = dataSource[index]
        controller.topicModels = [model]
        controller.playWorks = (model.user?.id == UserModel.share().userInfo?.id)
        controller.goVerbOrRefreshActionHandler = { [weak self] (isVerb) in
            if isVerb {
                let vipvc = InvestController()
                vipvc.currentIndex = 0
                self?.navigationController?.pushViewController(vipvc, animated: false)
            } else {
                self?.tableView.mj_header.beginRefreshing()
            }
        }
        let nav = QHNavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        getCurrentVC()?.present(nav, animated: false, completion: nil)
    }
}

// MARK: - Layout
private extension DiscoverTrendsController {
    func layoutPageSubviews() {
        layoutTableView()
        layoutTopButton()
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    func layoutTopButton() {
        topButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-15)
            make.bottom.equalTo(UIDevice.current.isXSeriesDevices() ? -150 : -100)
            make.width.height.equalTo(60)
        }
    }
}
