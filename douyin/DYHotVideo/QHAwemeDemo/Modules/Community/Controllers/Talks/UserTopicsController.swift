//
//  UserTopicsController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/5.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import MJRefresh

class UserTopicsController: QHBaseViewController {

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
    
    var lastContentOffset: CGFloat = 0
    var headerHeight: CGFloat = 345.0
    
    var topicTotalHandler:((_ total: Int)->Void)?
    var scrollDownToTopHandler:((_ canScroll: Bool)->Void)?
    
    var userId: Int?
    var isAcount: Bool = false
    private var dataSource = [TopicModel]()
    private var pageNumber: Int = 0
    private let viewModel = CommunityViewModel()
    /// 当前操作的index
    private var favorIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(topButton)
        layoutPageSubviews()
        let bottomMX: CGFloat = isAcount ? 83 : 34
        let bottomMNormal: CGFloat = isAcount ? 68 : 34
        tableView.contentInset = UIEdgeInsets(top: UIDevice.current.isiPhoneXSeriesDevices() ? 20 : 10, left: 0, bottom: UIDevice.current.isiPhoneXSeriesDevices() ? bottomMX : bottomMNormal, right: 0)
        addViewModelCallBack()
        //loadTopicListData()
         headerHeight = isAcount ? 345.0 : 260.0
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTopicListData()
    }
    @objc func gotoTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
}

// MARK: - Private - Funcs
private extension UserTopicsController {
    
    func loadTopicListData() {
        NicooErrorView.removeErrorMeesageFrom(self.view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        var params: [String: Any] = [UserTopicListApi.kIs_recommend: 0, UserTopicListApi.kIs_attention: 0]
        if !isAcount {
            params[UserTopicListApi.kUserId] = userId
        }
        viewModel.loadUserTopicList(params)
    }
    func loadFirstPage() {
        var params: [String: Any] = [UserTopicListApi.kIs_recommend: 0, UserTopicListApi.kIs_attention: 0]
        if !isAcount {
            params[UserTopicListApi.kUserId] = userId
        }
        viewModel.loadUserTopicList(params)
    }
    func loadNextPage() {
        var params: [String: Any] = [UserTopicListApi.kIs_recommend: 0, UserTopicListApi.kIs_attention: 0]
        if !isAcount {
            params[UserTopicListApi.kUserId] = userId
        }
        viewModel.loadUserTopicListNextPage(params)
    }
    func endRefreshing() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
    
    /// 数据接口回调
    func addViewModelCallBack() {
        viewModel.topicListApiSuccess = { [weak self] (topiclist, pageNumber, total) in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for:strongSelf.view, animated: false)
            strongSelf.pageNumber = pageNumber
            strongSelf.loadListSuccess(topiclist)
            if pageNumber == 1 {
                strongSelf.topicTotalHandler?(total ?? 0)
            }
        }
        viewModel.topicListApiApiFail = { [weak self] in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for:strongSelf.view, animated: false)
            strongSelf.endRefreshing()
            if strongSelf.pageNumber == 0 {
                NicooErrorView.showErrorMessage(.noNetwork, on: strongSelf.view, topMargin: 0, clickHandler: {
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
            strongSelf.tableView.reloadSections([strongSelf.favorIndex], with: .automatic)
        }
        viewModel.topicDeleteApiSuccess = { [weak self] in
            self?.loadTopicListData()
        }
        viewModel.topicDeleteApiFailed = { (msg) in
            XSAlert.show(type: .error, text: msg)
        }
    }
    func loadListSuccess(_ listModels: [TopicModel]?) {
        endRefreshing()
        if let dataList = listModels {
            if pageNumber == 1 {
                dataSource = dataList
                if dataList.count == 0 {
                    //加载无数据占位
                    NicooErrorView.showErrorMessage(.noData, isAcount ? "你还没有动态\n快去发布吧" : "这家伙很懒\n还没有发布动态", on: view) {
                        self.loadTopicListData()
                    }
                }
            } else {
                dataSource.append(contentsOf: dataList)
            }
            loadMoreView.isHidden = (dataList.count < TalksListApi.kDefaultCount)
            tableView.reloadData()
        }
    }
    func getCurrentVC() -> UIViewController? {
        var next = view.superview
        if isAcount {
            while (next != nil) {
                let nextResponder = next?.next
                if (nextResponder is AcountNewController) {
                    return nextResponder as? AcountNewController
                }
                next = next?.superview
            }
        } else {
            while (next != nil) {
                let nextResponder = next?.next
                if (nextResponder is UserMCenterController) {
                    return nextResponder as? UserMCenterController
                }
                next = next?.superview
            }
        }
        return nil
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension UserTopicsController: UITableViewDataSource, UITableViewDelegate {
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
                    cell.setModel(model, isAcount ? .acountCnter : .userCenter)
                    cell.userViewActionHandler = { [weak self] actionId in
                        self?.userActions(actionId, indexPath.section)
                    }
                    cell.bottomActionHandler = { [weak self] actionId in
                        self?.bottomAction(actionId, indexPath.section)
                    }
                    return cell
                } else if imageResource.count == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CommunitySinglePictureCell.cellId, for: indexPath) as! CommunitySinglePictureCell
                    cell.setModel(model, isAcount ? .acountCnter : .userCenter)
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
                    cell.setModel(model, isAcount ? .acountCnter : .userCenter)
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
            cell.setModel(model, isAcount ? .acountCnter : .userCenter)
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: TopicCellLineFooter.footerId) as! TopicCellLineFooter
        return footer
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
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
private extension UserTopicsController {
    
    /// 删除动态
    func alertForTopicInfo(_ msg: String, _ title: String? = nil) {
        let alertContro = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        let  okAction = UIAlertAction(title: "删除", style: .default) { (action) in
            // 调用删除接口
            self.viewModel.loadTopicDelApi([TopicDeleteApi.kTopicId: self.dataSource[self.favorIndex].id ?? 0])
        }
        alertContro.addAction(okAction)
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
        }
        alertContro.addAction(cancleAction)
        alertContro.modalPresentationStyle = .fullScreen
        self.present(alertContro, animated: true, completion: nil)
    }
    
    //1. 用户点击 2.删除动态 3.对用户添加关注
    func userActions(_ actionId: Int, _ index: Int) {
        let topicModel = dataSource[index]
        if actionId == 2 { // 删除
            if isAcount {
                favorIndex = index
                alertForTopicInfo("是否删除动态？", nil)
            }
        } else if actionId == 4 { // 审核提示
            if isAcount {
                if let checkStatu = topicModel.check {
                    if checkStatu == 0 {
                        favorIndex = index
                        alertForTopicInfo("\r 审核通过后可查看，是否删除？", "审核中...")
                    } else if checkStatu == -1 {
                        favorIndex = index
                        alertForTopicInfo("\r 动态审核未通过，是否删除？", "审核未通过")
                    }
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
        let model = dataSource[index]
        if let checkStatu = model.check { // 未通过
            if checkStatu == 0 {
                alertForTopicInfo("审核通过后可查看，是否删除？", "审核中...")
                 return
            } else if checkStatu == -1 {
                alertForTopicInfo("动态审核未通过，是否删除？", "审核未通过")
                 return
            }
        }
        let controller = CommunityPlayController()
        controller.canGoNext = false
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
        if let vc = getCurrentVC() {
             vc.present(nav, animated: false, completion: nil)
        } else {
            self.present(nav, animated: false, completion: nil)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension UserTopicsController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let height = scrollView.frame.size.height
        let distanceFormBottm = scrollView.contentSize.height - offsetY
        let offset = offsetY - lastContentOffset
        lastContentOffset = offsetY
        if offset > 0 && offsetY > -20 {
            //print("上拉行为 == \(offsetY) == \(height)")
            if offsetY > headerHeight {
                scrollDownToTopHandler?(false)
            }
        }
        if offset < 0 && distanceFormBottm > height {
            //print("下拉行为 == \(offsetY)")
            if offsetY <= headerHeight {
                scrollDownToTopHandler?(true)
            }
        }
    }
}

// MARK: - Layout
private extension UserTopicsController {
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
        let bottomMarX: CGFloat = isAcount ? -160 : -100
        let bottomMarN: CGFloat = isAcount ? -120 : -70
        topButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-15)
            make.bottom.equalTo(UIDevice.current.isXSeriesDevices() ? bottomMarX : bottomMarN)
            make.width.height.equalTo(60)
        }
    }
}
