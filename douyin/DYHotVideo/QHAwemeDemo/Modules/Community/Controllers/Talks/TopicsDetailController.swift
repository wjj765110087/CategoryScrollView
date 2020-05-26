//
//  TopicsDetailController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import MJRefresh
import NicooNetwork
import IQKeyboardManagerSwift

class TopicsDetailController: QHBaseViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "动态详情"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.lineView.isHidden = true
        bar.delegate = self
        return bar
    }()
    private let commentbgView: UIView = {
        let view = UIView()
        view.backgroundColor = ConstValue.kVcViewColor
        return view
    }()
    private lazy var videoCommentView: VideoCommentView = {
        let view = VideoCommentView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 50))
        view.backgroundColor = ConstValue.kVcViewColor
        return view
    }()
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .grouped)
        table.backgroundColor = UIColor.clear
        table.estimatedRowHeight = 100
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.tableFooterView = UIView.init(frame: CGRect.zero)
        table.register(CommentSectionHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: CommentSectionHeaderView.reuseId)
        table.register(CommentsSectionFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: CommentsSectionFooterView.reuseId)
        table.register(CommentCell.classForCoder(), forCellReuseIdentifier: CommentCell.cellId)
        
        table.register(CommunityTextCell.classForCoder(), forCellReuseIdentifier: CommunityTextCell.cellId)
        table.register(CommunitySinglePictureCell.classForCoder(), forCellReuseIdentifier: CommunitySinglePictureCell.cellId)
        table.register(CommunityImagesCell.classForCoder(), forCellReuseIdentifier: CommunityImagesCell.cellId)
        table.register(CommunityVideoCell.classForCoder(), forCellReuseIdentifier: CommunityVideoCell.cellId)
        
        table.mj_footer = loadMoreView
        return table
    }()
    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadMore =  MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.loadNextPage()
        })
        loadMore?.isHidden = true
        loadMore?.stateLabel.font = ConstValue.kRefreshLableFont
        return loadMore!
    }()
    var userClickHandler:((_ user: UserInfoModel?)->Void)?
    
    var topicId: Int = 0
    var userId: Int?
    var commentMsg = ""
    
    var viewModel = CommentViewModel()
    
    var videoComents = [VideoCommentModel]()
    
    private let communityViewModel = CommunityViewModel()
    private let userViewModel = UserInfoViewModel()
    
    var topicModel = TopicModel()
    
    var currentModel: VideoCommentModel?
    var currentSection: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        view.addSubview(navBar)
        view.addSubview(commentbgView)
        commentbgView.addSubview(videoCommentView)
        layoutPageSubviews()
        addCommentViewCallBackHandler()
        addViewModelCallBack()
        loadData()
        loadTopicInfo()
    }
    
    private func endRefreshing() {
        tableView.mj_footer.endRefreshing()
    }
}

// MARK: - QHNavigationBarDelegate
extension TopicsDetailController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - 网络请求
extension TopicsDetailController {
    
    private func loadTopicInfo() {
        communityViewModel.loadTopicDetail([TopicDetailApi.kTopicId: topicId])
    }
    ///用户视频评论列表
    private func loadData() {
        NicooErrorView.removeErrorMeesageFrom(self.view)
        let params = [TopicCommentListApi.kTopic_Id: topicId]
        viewModel.loadTopicCommentListApi(params: params)
    }
    private func loadFirstPage() {
        let params = [TopicCommentListApi.kTopic_Id: topicId]
        viewModel.loadTopicCommentListApi(params: params)
    }
    private func loadNextPage() {
        let params = [TopicCommentListApi.kTopic_Id: topicId]
        viewModel.loadTopicCommentListNextPage(params: params)
    }
    
    ///用户评论视频
    private func commentVideo(content: String, topicId: Int) {
        let params: [String : Any] = [TopicCommentApi.kTopic_Id: topicId, TopicCommentApi.kContent: content]
        viewModel.loadTopicCommentApi(params: params)
    }
    /// 用户回复评论
    private func answerComment(content: String, commentId: Int) {
        let params: [String : Any] = [TopicCommentApi.kTopic_Id: topicId, TopicCommentApi.kComment_id: commentId,TopicCommentApi.kContent: content]
        viewModel.loadTopicCommentApi(params: params)
    }
    
    ///用户视频子评论列表
    private func loadCommnetSonData(_ commentModel: VideoCommentModel?) {
        let params = [TopicSonCommentListApi.kTopic_Id: topicId, TopicSonCommentListApi.kComment_id: videoComents[currentSection-1].id ?? 0, TopicSonCommentListApi.kPageNumber: 1]
        viewModel.loadTopicSonCommentListApi(params: params)
    }
    
    private func loadCommnetSonNextPage(_ commentModel: VideoCommentModel?) {
        let params = [TopicSonCommentListApi.kTopic_Id: topicId, TopicSonCommentListApi.kComment_id: commentModel?.id ?? 0,TopicSonCommentListApi.kPageNumber: commentModel?.answerPageNumber ?? 1]
        viewModel.loadTopicSonCommentListNextPage(params: params)
    }
    
    ///用户视频评论点赞
    private func commentLike(commentId: Int) {
        let params = [TopicCommentLikeApi.kComment_id: commentId]
        viewModel.loadTopicCommentLikeData(params: params)
    }
    /// 提示
    private func showTipAlert(_ msg: String, _ title: String?) {
        let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        let actionCancle = UIAlertAction.init(title: "好哒", style: .default, handler: nil)
        let verb = UIAlertAction.init(title: "充值VIP", style: .default) { (action) in
            let vipcarVc = InvestController()
            vipcarVc.currentIndex = 0
            self.navigationController?.pushViewController(vipcarVc, animated: true)
        }
        alert.addAction(actionCancle)
        alert.addAction(verb)
        alert.modalPresentationStyle = .fullScreen
        self.present(alert, animated: true, completion: nil)
    }
    @objc private func reloadData() {
        tableView.reloadData()
    }
    
}

// MARK: - 数据回调
extension TopicsDetailController {
    
    func addViewModelCallBack() {
        communityViewModel.topicDetailApiSuccess = { [weak self] topicModel in
            guard let strongSelf = self else { return }
            strongSelf.topicModel = topicModel
            strongSelf.tableView.reloadSections([0], with: .none)
        }
        communityViewModel.topicDetailApiApiFail = { [weak self] in
            guard let strongSelf = self else { return }
            NicooErrorView.showErrorMessage(.noNetwork, on: strongSelf.view, clickHandler: {
                strongSelf.loadTopicInfo()
            })
        }
        communityViewModel.topicFavorSuccess = { [weak self] in
            guard let strongSelf = self else { return }
            if (strongSelf.topicModel.is_like ?? .unlike) == .unlike {
                strongSelf.topicModel.is_like = .like
                strongSelf.topicModel.like = (strongSelf.topicModel.like ?? 0) + 1
            } else {
                strongSelf.topicModel.is_like = .unlike
                strongSelf.topicModel.like = (strongSelf.topicModel.like ?? 0) - 1
            }
            strongSelf.tableView.reloadSections([0], with: .none)
        }
        /// UserInfoViewModel
        userViewModel.followAddOrCancelSuccessHandler = { [weak self] isAdd, _ in
            guard let strongSelf = self else { return }
            if isAdd {
                strongSelf.topicModel.user?.followed = .focus
                strongSelf.topicModel.is_attention = .recommend
            } else {
                strongSelf.topicModel.user?.followed = .notFocus
                strongSelf.topicModel.is_attention = .noRecommend
            }
            strongSelf.tableView.reloadSections([0], with: .none)
        }
        userViewModel.followOrCancelFailureHandler = { (isAdd, msg) in
            XSAlert.show(type: .error, text: msg)
        }
        
        viewModel.videoCommentListSuccessHandler = { [weak self] commentList in
            guard let strongSelf = self else {return}
            if let data = commentList.data, let currentPage = commentList.current_page {
                if currentPage == 1 {
                    strongSelf.videoComents = data
                    strongSelf.perform(#selector(strongSelf.reloadData), with: nil, afterDelay: 0.5)
                }  else {
                    strongSelf.videoComents.append(contentsOf: data)
                }
                strongSelf.loadMoreView.isHidden = data.count < VideoCommentListApi.kDefaultCount
            }
            strongSelf.endRefreshing()
            strongSelf.tableView.reloadData()
        }
        
        viewModel.videoCommentListFailureHandelr = { [weak self] errorMsg in
            guard let strongSelf = self else {return}
            NicooErrorView.showErrorMessage(.noNetwork, on: strongSelf.view, topMargin: ConstValue.kScreenHeight * 0.35, clickHandler: {
                strongSelf.loadData()
            })
        }
        /// 评论成功回调
        viewModel.videoCommentSuccessHandler = { [weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.videoCommentView.textInputView.text = ""
            if strongSelf.currentModel != nil {
                strongSelf.loadCommnetSonData(strongSelf.currentModel)
            } else {
                strongSelf.loadData()
                XSProgressHUD.showSuccess(msg: "评论成功", onView: strongSelf.view, animated: true)
            }
            strongSelf.currentModel = nil
        }
        
        viewModel.videoCommentFailureHandelr = { [weak self] errorMsg in
            self?.showTipAlert("\r \(errorMsg)", nil)
        }
        
        /// 回复列表
        viewModel.videoCommentSonListSuccessHandler = { [weak self] answerList in
            guard let strongSelf = self else {return}
            strongSelf.loadSonCommentListSuccess(answerList)
        }
        
        viewModel.videoCommentLikeSuccessHandler = { [weak self]  in
            guard let strongSelf = self else { return }
            let model = strongSelf.videoComents[strongSelf.currentSection-1]
            if (model.is_like ?? 0) == 1 {
                model.is_like = 0
                model.like = (model.like ?? 0) - 1
            } else {
                model.is_like = 1
                model.like = (model.like ?? 0) + 1
            }
            strongSelf.tableView.reloadSections([strongSelf.currentSection-1], with: .automatic)
        }
    }
    func loadSonCommentListSuccess(_ listModel: CommentAnswerListModel) {
        let commentModel = videoComents[currentSection-1]
        if let datas = listModel.data ,let currentPage = listModel.current_page {
            if currentPage == 1 {
                commentModel.comment = datas
                if commentModel.isOpen ?? false {  // 打开了，页码 +1
                    commentModel.answerPageNumber = currentPage + 1
                    commentModel.isAllAnswers = datas.count < VideoSonCommentListApi.kDefaultCount
                } else {  // 刚收起，重置页码
                    commentModel.answerPageNumber = 1
                }
            } else {
                commentModel.comment?.append(contentsOf: datas)
                commentModel.isAllAnswers = datas.count < TopicSonCommentListApi.kDefaultCount
                commentModel.answerPageNumber = currentPage + 1
            }
            
            tableView.reloadSections([currentSection], with: .automatic)
        }
        
    }
    
}

// MARK: -点击事件
extension TopicsDetailController {
    
    /// 添加评论栏点击回调
    func addCommentViewCallBackHandler() {
        videoCommentView.sendCommentTextHandler = { [weak self] (text) in
            guard let strongSelf = self else { return }
            strongSelf.commentMsg = text
            if let commentId = strongSelf.currentModel?.id {
                let answer = text.replacingOccurrences(of: "@\(strongSelf.currentModel?.user?.nikename ?? ""): ", with: "")
                strongSelf.answerComment(content: answer, commentId: commentId)
            } else {
                strongSelf.commentVideo(content: text, topicId: strongSelf.topicId)
            }
        }
    }
    
    @objc func closeBtnAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func goUserCenter(_ user: UserInfoModel?) {
        let userCenter = UserMCenterController()
        userCenter.user = user
        navigationController?.pushViewController(userCenter, animated: true)
    }
   
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TopicsDetailController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120.0
        return tableView.rowHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return videoComents.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            let model = videoComents[section - 1]
            if let sonComment = model.comment {
                if sonComment.count > 0  {
                    if model.isOpen ?? false {
                        return sonComment.count
                    } else {
                        return 1
                    }
                }
            }
        }
       
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if topicModel.type == TopicType.imgText {
                if let imageResource = topicModel.resource {
                    if imageResource.count == 0 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTextCell.cellId, for: indexPath) as! CommunityTextCell
                        cell.setModel(topicModel,.recomment)
                        cell.userView.addFollowButton.isHidden = true
                        cell.userViewActionHandler = { [weak self] actionId in
                             self?.userActions(actionId)
                        }
                        cell.bottomActionHandler = { [weak self] actionId in
                            self?.bottomAction(actionId)
                        }
                        return cell
                    } else if imageResource.count == 1 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: CommunitySinglePictureCell.cellId, for: indexPath) as! CommunitySinglePictureCell
                        cell.setModel(topicModel,.recomment)
                        cell.userView.addFollowButton.isHidden = true
                        cell.imageClickHandler = { [weak self] in
                            self?.showImages(0)
                        }
                        cell.userViewActionHandler = { [weak self] actionId in
                            self?.userActions(actionId)
                        }
                        cell.bottomActionHandler = { [weak self] actionId in
                            self?.bottomAction(actionId)
                        }
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: CommunityImagesCell.cellId, for: indexPath) as! CommunityImagesCell
                        cell.setModel(topicModel, .recomment)
                        cell.userView.addFollowButton.isHidden = true
                        cell.imagesClickHandler = { [weak self] (index) in
                            self?.showImages(index)
                        }
                        cell.userViewActionHandler = { [weak self] actionId in
                            self?.userActions(actionId)
                        }
                        cell.bottomActionHandler = { [weak self] actionId in
                            self?.bottomAction(actionId)
                        }
                        return cell
                    }
                }
                
            } else if topicModel.type == .video {
                let cell = tableView.dequeueReusableCell(withIdentifier: CommunityVideoCell.cellId, for: indexPath) as! CommunityVideoCell
                cell.setModel(topicModel, .recomment)
                cell.userView.addFollowButton.isHidden = true
                cell.userViewActionHandler = { [weak self] actionId in
                    self?.userActions(actionId)
                }
                cell.bottomActionHandler = { [weak self] actionId in
                    self?.bottomAction(actionId)
                }
                cell.videoClickHandler = { [weak self] in
                    self?.playVideo()
                }
                return cell
            }
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.cellId, for: indexPath) as! CommentCell
            let commentModel = videoComents[indexPath.section - 1]
            if let sonComments = commentModel.comment {
                let sonModel = sonComments[indexPath.row]
                if sonModel.user_id != nil {
                    sonModel.isZZ = sonModel.user_id == userId
                }
                cell.setModel(model: sonModel)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommentSectionHeaderView.reuseId) as! CommentSectionHeaderView
            let model = videoComents[section-1]
            header.setModel(model: model)
            header.buttonClickHandler = { [weak self] index in
                guard let strongSelf = self else {return}
                if index == 102 {
                    strongSelf.goUserCenter(model.user)
                } else if index == 101 {
                    ///视频评论点赞
                    strongSelf.currentModel = model
                    strongSelf.currentSection = section
                    strongSelf.commentLike(commentId: model.id ?? 0)
                } else if index == 103 {  ///对该评论进行评论
                    strongSelf.videoCommentView.textInputView.becomeFirstResponder()
                    strongSelf.videoCommentView.textInputView.text = "@\(model.user?.nikename ?? ""): "
                    strongSelf.currentSection = section
                    strongSelf.currentModel = model
                }
            }
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != 0 {
            let commentModel = videoComents[section - 1]
            if let sonComments = commentModel.comment, sonComments.count > 1 {
                let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommentsSectionFooterView.reuseId) as! CommentsSectionFooterView
                if commentModel.isAllAnswers == true  { /// 已经展开所有回复
                    footer.spreadOutLabel.text = "收起回复"
                } else { // 还可以继续展开
                    footer.spreadOutLabel.text = "展示更多回复"
                }
                footer.downButton.isSelected = commentModel.isAllAnswers ?? false
                footer.buttonClickHandler = { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.currentSection = section
                    if commentModel.isAllAnswers == true { /// 已经展开所有回复
                        commentModel.isOpen = false
                        commentModel.isAllAnswers = false
                        commentModel.answerPageNumber = 1
                        //                    strongSelf.viewModel.resetCommentAnswersApiPage()
                        strongSelf.loadCommnetSonData(commentModel)
                        
                    } else { // 还可以继续展开
                        commentModel.isOpen = true
                        if commentModel.answerPageNumber == 1 {
                            strongSelf.loadCommnetSonData(commentModel)
                        } else {
                            strongSelf.loadCommnetSonNextPage(commentModel)
                        }
                        
                    }
                }
                return footer
            } else {
                return nil
            }
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 2))
        view.backgroundColor =  ConstValue.kViewLightColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.001
        } else {
            tableView.sectionHeaderHeight = UITableView.automaticDimension
            tableView.estimatedSectionHeaderHeight = CommentSectionHeaderView.headerHeight
            return tableView.sectionHeaderHeight
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 { return 0.5 }
        if let sonComments = videoComents[section - 1].comment, sonComments.count > 1 {
            return CommentsSectionFooterView.footerHeight
        } else {
            return 10.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Action for TopicInfoCell
private extension TopicsDetailController {
    
    //1. 用户点击 2.删除动态 3.对用户添加关注
    func userActions(_ actionId: Int) {
        if actionId == 1 {
            let userCenter = UserMCenterController()
            userCenter.user = topicModel.user
            navigationController?.pushViewController(userCenter, animated: true)
        } else if actionId == 3 {
            if let focusStatu = topicModel.is_attention {
                if focusStatu == .recommend {  // 已关注，调用取消
                    userViewModel.loadCancleFollowApi([UserFollowStatuApi.kUserId: topicModel.user?.id ?? 0, UserFollowStatuApi.kSelfId: UserModel.share().userInfo?.id ?? 0])
                } else  { // 未关注，调用关注
                    userViewModel.loadAddFollowApi([UserFollowStatuApi.kUserId: topicModel.user?.id ?? 0, UserFollowStatuApi.kSelfId: UserModel.share().userInfo?.id ?? 0])
                }
            }
        }
    }
    /// 看大图
    func showImages(_ index: Int) {
        guard let images = topicModel.resource else { return }
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
    func playVideo() {
        let controller = CommunityPlayController()
        controller.topicModels = [topicModel]
        controller.playWorks = (topicModel.user?.id == UserModel.share().userInfo?.id)
        controller.goVerbOrRefreshActionHandler = { [weak self] (isVerb) in
            if isVerb {
                let vipvc = InvestController()
                vipvc.currentIndex = 0
                self?.navigationController?.pushViewController(vipvc, animated: false)
            }
        }
        let nav = QHNavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false, completion: nil)
    }
    /// actionId : 1.话题点击 2.评论点击 3.分享点击 4.点赞
    func bottomAction(_ actionId: Int) {
        if actionId == 1 {
            let talksVc = TalksMainController()
            if let talkModel = topicModel.topic {
                talksVc.talksModel = talkModel
                navigationController?.pushViewController(talksVc, animated: true)
            }
        } else if actionId == 3 {
            if topicModel.type == .video {
                if let videos = topicModel.video, videos.count > 0 {
                    let video = videos[0]
                    UserModel.share().shareImageLink = video.cover_path
                }
            } else if topicModel.type == .imgText {
                if let images = topicModel.resource, images.count > 0 {
                    UserModel.share().shareImageLink = images[0]
                }
            }
            UserModel.share().shareText = getShareText(topicModel.topic?.title , topicModel.content)
            let shareVc = ShareContentController()
            shareVc.modalPresentationStyle = .overCurrentContext
            shareVc.definesPresentationContext = true
            shareVc.view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
            present(shareVc, animated: true, completion: nil)
        } else if actionId == 4 {
            communityViewModel.loadTopicFavor([TopicFavorApi.kTopicId: topicModel.id ?? 0])
        }
    }
}


// MARK: - Layout
private extension TopicsDetailController {
    
    func layoutPageSubviews() {
        layoutCommentBgView()
        layoutCommentView()
        layoutNavBar()
        layoutTableView()
       
    }
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(videoCommentView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
    }
    func layoutCommentBgView() {
        commentbgView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(UIDevice.current.isiPhoneXSeriesDevices() ? 83 : 49)
        }
    }
    func layoutCommentView() {
        videoCommentView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(49)
        }
    }
}
