//
//  QHHomeViewController.swift
//  QHAwemeDemo
//
//  Created by Anakin chen on 2017/10/16.
//  Copyright © 2017年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh
import DouYPlayer
import AVFoundation
import NicooNetwork
import AssetsLibrary
import Photos

class QHHomeViewController: QHBaseViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
   
    var currentIndex:Int = 0
    var currentPlayIndex: Int = 0
    //var sourceCount: Int = 0
    
    private var topSegView: HomeTopSegView = {
        guard let view = Bundle.main.loadNibNamed("HomeTopSegView", owner: nil, options: nil)?[0] as? HomeTopSegView else { return HomeTopSegView() }
        return view
    }()
    
    private let adTimerlabel: UILabel = {
        let lab = UILabel()
        lab.text = "广告时间，3秒后可操作"
        lab.textColor = UIColor.white
        lab.font = UIFont.systemFont(ofSize: 15)
        lab.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        lab.layer.cornerRadius = 15
        lab.layer.masksToBounds = true
        lab.textAlignment = .center
        lab.isHidden = true
        return lab
    }()
    lazy var playerView: NicooPlayerView = {
        let player = NicooPlayerView(frame: view.bounds, bothSidesTimelable: true)
        player.videoLayerGravity = .resizeAspect
        player.videoNameShowOnlyFullScreen = true
        player.delegate = self
        player.customViewDelegate = self
        return player
    }()
    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadmore = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.viewModel.loadNextPage()
        })
        loadmore?.setTitle("", for: .idle)
        loadmore?.setTitle("", for: .pulling)
        loadmore?.setTitle("", for: .noMoreData)
        return loadmore!
    }()
    
    private lazy var activityView: ActivityView = {
        let view = ActivityView()
        view.isHidden = true
        return view
    }()
   
    private let viewModel = VideoViewModel()
    private let userInfoViewModel = UserInfoViewModel()
    private let registerViewModel = RegisterLoginViewModel()
    private var activityModel = ActivityModel()
    
    var isRefreshOperation = false
    var isRecoment = true
    /// 是否关注过别人
    var isAttentionPeople = true
    
    var isFirstIn = true
    
    var timer: Timer!
    var timer1: Timer?
    var adtime: Int = 3
    
    @IBOutlet weak var mainCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        NotificationCenter.default.addObserver(self, selector: #selector(didUserBeenKickedOut), name: Notification.Name.kUserBeenKickedOutNotification, object: nil)
        setUpUI()
        addViewModelCallBack()
        addSegActionHandler()
        loadData(isRecomment: isRecoment)
        loadAdInfoApi()
        /// 延迟三秒弹起。版本更新框
        perform(#selector(checkAppVersionInfo), with: nil, afterDelay: 3)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationResignActivity(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        UIApplication.shared.isIdleTimerDisabled = true
        viewModel.loadActivityData()
        
        activityView.activityHandler = { [weak self] in
            guard let strongSelf = self else {return}
            if (strongSelf.activityModel.type ?? .link) == .link {
                if let redirect_url = strongSelf.activityModel.redirect_url {
                    let activityVC = AAViewController(url:URL(string:redirect_url)!)
                    strongSelf.navigationController?.pushViewController(activityVC, animated: true)
                }
            } else {
                if (strongSelf.activityModel.redirect_position ?? .ACT_DETAIL) == .ACT_DETAIL {
                    let activityNative = ActivityMainController()
                    activityNative.activityModel = strongSelf.activityModel
                    if let topicModels = strongSelf.activityModel.topics, topicModels.count > 0 {
                        activityNative.activityTalks = topicModels
                    }
                    if let itemsModel = strongSelf.activityModel.childs, itemsModel.count > 0 {
                        activityNative.activityItems = itemsModel
                    }
                    strongSelf.navigationController?.pushViewController(activityNative, animated: true)
                } else if (strongSelf.activityModel.redirect_position ?? .ACT_DETAIL) == .GAME_TIGER {
                    let gameVc = GamingMainController()
                    strongSelf.navigationController?.pushViewController(gameVc, animated: true)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playerView.playerStatu = PlayerStatus.Playing
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerView.playerStatu = PlayerStatus.Pause
    }
    
    // 掉线提
    @objc private func didUserBeenKickedOut() {
        DLog("didUserBeenKickedOut  ===== Main")
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.window?.rootViewController?.showDialog(title: "被挤掉提示", message: XSAlertMessages.kNotAvailTokenAlertMsg, okTitle: "确认", cancelTitle: "取消", okHandler: {
                self.goAndUpdate(ConstValue.kAppDownLoadLoadUrl)
            }, cancelHandler: nil)
        }
    }
    
    @objc func applicationResignActivity(_ sender: NSNotification) {
        if let controller = UIViewController.currentViewController(), controller is GestureViewController {
            DLog("已经弹出 GestureViewController")
            return
        }
        if GYCircleConst.getGestureWithKey(gestureFinalSaveKey) != nil {
            let gestureVC = GestureViewController()
            // 登录成功， 进入抖音
            gestureVC.lockLoginSuccess = {
                gestureVC.dismiss(animated: false, completion: nil)
            }
            gestureVC.type = GestureViewControllerType.login
            gestureVC.navBarHiden = true
            gestureVC.modalPresentationStyle = .fullScreen
            UIViewController.currentViewController()?.present(gestureVC, animated: false, completion: nil)
        }
    }
    
    //MARK: Private Funcs
    private func setUpUI() {
        //固定设置layut，或者通过UICollectionViewDelegateFlowLayout设置，这样可以动态调整
        if let layout = mainCV.collectionViewLayout as? UICollectionViewFlowLayout {
            //每个Item之间最小的间距
            layout.minimumInteritemSpacing = 0
            //每行之间最小的间距
            layout.minimumLineSpacing = 0
        }
        if #available(iOS 11.0, *) {
            mainCV.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        mainCV.scrollsToTop = false
        mainCV.isScrollEnabled = false
        mainCV.allowsSelection = true
        mainCV.mj_footer = loadMoreView
        view.addSubview(adTimerlabel)
        view.addSubview(topSegView)
        view.addSubview(activityView)
        layoutPageSubviews()
    }
    
    /// 跳转到系列列表页面
    private func p_showDetails() {
        let currentModel = viewModel.homeModels[currentIndex]
        if (currentModel.type ?? .videoType) == .videoType {
            let currentModel = self.viewModel.getHomeList()[self.currentIndex]
            if (currentModel.type ?? .videoType) == .videoType {
                let videoModel = currentModel.video
                let user = videoModel?.user
                let userCenter = UserMCenterController()
                userCenter.user = user
                userCenter.followOrCancelBackHandler = { (focusStatu) in
                    self.reloadCurrentIndexFocusStatu(focusStatu)
                }
                self.navigationController?.pushViewController(userCenter, animated: true)
            }
        } else {
            /// 跳转到广告页面
            DLog("跳转到广告页面 === \(currentModel.ad?.redirect_url ?? "")")
            goAndUpdate(currentModel.ad?.redirect_url ?? "")
        }
    }
    
    private func getCurrentVC() -> QHRootScrollViewController? {
        var next = view.superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is QHRootScrollViewController) {
                return nextResponder as? QHRootScrollViewController
            }
            next = next?.superview
        }
        return nil
    }
    
    /// 是否禁用滑动跳转到系列
    private func isPanGuestureEnable(_ enable: Bool) {
        (self.navigationController as! QHNavigationController).pan?.isEnabled = enable
    }
    
}

//MARK: - 获取网络数据
extension QHHomeViewController {
    func reloadCurrentIndexFocusStatu(_ statu: FocusVideoUploader) {
        if let cell = mainCV.cellForItem(at: IndexPath.init(item: currentIndex, section: 0)) as? QHHomeCollectionViewCell {
            cell.seriesAddButton.isHidden = statu == .focus
            viewModel.homeModels[currentIndex].video!.user?.followed = statu
            fixModelFollowStatu(statu, userId: viewModel.homeModels[currentIndex].video!.user?.id ?? 0, datas: viewModel.homeModels)
        }
    }
}

 //MARK: - UICollectionViewDataSource
extension QHHomeViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getHomeList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : QHHomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: QHHomeCollectionViewCell.cellId, for: indexPath) as! QHHomeCollectionViewCell
        cell.delegate = self
        let homeModels = viewModel.getHomeList()
        let homeModel = homeModels[indexPath.row]
        let isVideo = (homeModel.type ?? .videoType) == .videoType
        if isVideo {  /// 视频类型
            let videoModel = homeModel.video
            cell.bgImage.kfSetHeaderImageWithUrl(videoModel?.cover_path, placeHolder: nil)
            cell.introLable.attributedText = TextSpaceManager.getAttributeStringWithString(videoModel?.title ?? "", lineSpace: 5)
            cell.commentItem.msgLable.text = getStringWithNumber(videoModel?.comment_count ?? 0)
            cell.favorItem.title = getStringWithNumber(videoModel?.recommend_count ?? 0)
            cell.setFavorStatu((videoModel?.recommend?.isFavor ?? false))
            if let videoM = videoModel {
                cell.videoModel = videoM
            }
            cell.setKeys(videoModel?.keys, videoModel?.topic?.topic)
            if let userModel = videoModel?.user {
                let userDefaultHeader = UserModel.share().getUserHeader(userModel.id)
                cell.seriesButton.kfSetHeaderImageWithUrl(userModel.cover_path, placeHolder: userDefaultHeader)
                cell.seriesButton.setTitle("", for: .normal)
                cell.nameLable.text = "@\(userModel.nikename ?? "老湿")"
                if let follow = userModel.followed {
                   cell.seriesAddButton.isHidden = follow == .focus
                } else {
                    cell.seriesAddButton.isHidden = true
                }
            }
            if let coins = videoModel?.coins, let iscoins = videoModel?.is_coins {
                if coins > 0 && iscoins == 1 {
                    cell.coinLable.isHidden = false
                    cell.coinLable.text = "\(coins)金币"
                } else {
                    cell.coinLable.isHidden = true
                }
            } else {
                cell.coinLable.isHidden = true
            }
            cell.adClickButton.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            cell.setUIHidenOrNot(false)
            cell.adClickButton.isHidden = true
            cell.adCoverTap.isHidden = true
        } else { /// 广告
            let adModel = homeModel.ad
            cell.bgImage.kfSetHeaderImageWithUrl(adModel?.cover_path, placeHolder: nil)
            cell.nameLable.text = adModel?.title ?? ""
            cell.introLable.attributedText = TextSpaceManager.getAttributeStringWithString(adModel?.remark ?? "", lineSpace: 5)
            cell.commentItem.msgLable.text = getStringWithNumber(adModel?.comment_count ?? 0)
            cell.favorItem.title = getStringWithNumber(adModel?.recommend_count ?? 0)
            cell.setFavorStatu((adModel?.recommend?.isFavor ?? false))
            cell.seriesButton.setTitle("广告", for: .normal)
            cell.seriesButton.setImage(UIImage(), for: .normal)
            cell.seriesAddButton.isHidden = true
            cell.adClickButton.snp.updateConstraints { (make) in
                make.height.equalTo(35)
            }
            cell.setUIHidenOrNot(true)
            cell.adClickButton.isHidden = false
            cell.adCoverTap.isHidden = false
            cell.coinLable.isHidden = true
        }
        
        /// 第一次进入，播放第一条
        if indexPath.row == 0 && isFirstIn {
            self.playVideo(homeModel: homeModels[0], cell: cell, indexPath: indexPath)
        }
        cell.adTapActionHandler = { [weak self] in
            let isAd = (homeModel.type ?? .videoType) == .adType
            if isAd {
                self?.goAndUpdate(homeModel.ad?.redirect_url ?? "")
            }
        }
        cell.commentItemClick = { [weak self] in
            let commentVC = CommentsMController()
            if isVideo {
                commentVC.videoId = homeModel.video?.id ?? 0
                commentVC.userId = homeModel.video?.user?.id ?? 0
            }
            commentVC.modalPresentationStyle = .overCurrentContext
            commentVC.definesPresentationContext = true
            commentVC.view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
            self?.present(commentVC, animated: true, completion: nil)
            commentVC.userClickHandler = { [weak self] user in
                self?.goUserCenter(user)
                commentVC.dismiss(animated: false, completion: nil)
            }
            commentVC.buyVipClickHandler = {
                let verb = InvestController()
                verb.currentIndex = 0
                self?.navigationController?.pushViewController(verb, animated: true)
                commentVC.dismiss(animated: false, completion: nil)
            }
        }
        cell.shareItemClick = { [weak self] in
            let textShare = self?.viewModel.getHomeList()[indexPath.item].video?.title
            let topicShare = self?.viewModel.getHomeList()[indexPath.item].video?.topic?.topic?.title
            UserModel.share().shareImageLink = self?.viewModel.getHomeList()[indexPath.item].video?.cover_path
            UserModel.share().shareText = self?.getShareText(topicShare , textShare)
            let shareVc = ShareContentController()
            shareVc.modalPresentationStyle = .overCurrentContext
            shareVc.definesPresentationContext = true
            shareVc.view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
            self?.present(shareVc, animated: false, completion: nil)
        }
        cell.videoFavorItemClick = { [weak self] (isFavor) in
            guard let strongSelf = self else { return  0 }
            if isVideo {
                strongSelf.userInfoViewModel.addVideoFavor([UserFavorAddApi.kVideo_id: homeModel.video?.id ?? 0, UserFavorAddApi.kStatus: isFavor ? 0 : 1, UserFavorAddApi.kAction: UserFavorAddApi.kDefaultAction])
                if let appraiseCount = strongSelf.viewModel.getHomeList()[indexPath.row].video?.recommend_count {
                    let favorCount = isFavor ?  appraiseCount - 1 : appraiseCount + 1
                    strongSelf.viewModel.homeModels[indexPath.row].video?.recommend_count = favorCount
                    strongSelf.viewModel.homeModels[indexPath.row].video?.recommend = Recommend(rawValue: isFavor ? 0 : 1)
                    return favorCount
                }
            } else {
                strongSelf.userInfoViewModel.addAdFavor([UserAdFavorAddApi.kAd_id: homeModel.ad?.id ?? 0, UserAdFavorAddApi.kStatus: isFavor ? 0 : 1, UserAdFavorAddApi.kAction: UserAdFavorAddApi.kDefaultAction])
                if let appraiseCount = strongSelf.viewModel.getHomeList()[indexPath.row].ad?.recommend_count {
                    let favorCount = isFavor ?  appraiseCount - 1 : appraiseCount + 1
                    strongSelf.viewModel.homeModels[indexPath.row].ad?.recommend_count = favorCount
                    strongSelf.viewModel.homeModels[indexPath.row].ad?.recommend = Recommend(rawValue: isFavor ? 0 : 1)
                    return favorCount
                }
            }
            return 0
        }
        cell.talksKeyClickHandler = { [weak self] in
            guard let strongSelf = self else { return }
            let currentModel = strongSelf.viewModel.getHomeList()[strongSelf.currentIndex]
            if (currentModel.type ?? .videoType) == .videoType {
                if let model = currentModel.video?.topic?.topic {
                    let topicVC = TalksMainController()
                    topicVC.talksModel = model
                    strongSelf.navigationController?.pushViewController(topicVC, animated: true)
                }
            }
        }
        cell.clickTypeKeyCellHandler = { [weak self] videoKey in
            guard let strongSelf = self else { return }
            let currentModel = strongSelf.viewModel.getHomeList()[strongSelf.currentIndex]
            if (currentModel.type ?? .videoType) == .videoType {
                let keyMainVc = SeriesKeyMainController()
                keyMainVc.keyMode = videoKey
                strongSelf.navigationController?.pushViewController(keyMainVc, animated: true)
            }
        }
        
        cell.addFollowHandler = { [weak self] videoModel in
            guard let strongSelf = self else { return }
            let currentModel = strongSelf.viewModel.getHomeList()[strongSelf.currentIndex]
            if (currentModel.type ?? .videoType) == .videoType {
                if videoModel.id == currentModel.video?.id {
                   strongSelf.userInfoViewModel.loadAddFollowApi([UserFollowStatuApi.kUserId: videoModel.user?.id ?? 0, UserFollowStatuApi.kSelfId: UserModel.share().userInfo?.id ?? 0])
                }
            }
        }
        return cell
    }
    
    //MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - Show Alerts
private extension QHHomeViewController {
    /// 系统公告
    func showSystemMsgAlert() {
        if let message = SystemMsg.share().systemMsgs, message.count > 0 {
            let controller = AlertManagerController(system: message)
            controller.modalPresentationStyle = .overCurrentContext
            self.modalPresentationStyle = .currentContext
            self.present(controller, animated: true, completion: nil)
        } 
    }
    
    func goUserCenter(_ user: UserInfoModel?) {
        let userCenter = UserMCenterController()
        userCenter.user = user
        navigationController?.pushViewController(userCenter, animated: true)
    }
}

// MARK: - LoadData
private extension QHHomeViewController {
    
    /// 请求视频列表
    func loadData(isRecomment: Bool) {
        NicooErrorView.removeErrorMeesageFrom(view)
        if !viewModel.isRefreshOperation {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                XSProgressHUD.showCustomAnimation(msg: nil, onView: delegate.window!, imageNames: nil, bgColor: nil, animated: false)
            }
        } else {
            viewModel.isRefreshOperation = false
        }
        viewModel.loadHomeData(isRecomment)
    }
    
    /// 请求并下载开屏广告
    func loadAdInfoApi() {
        registerViewModel.loadAdInfo()
    }
    
    /// 添加viewModel 数据请求回调
    func addViewModelCallBack() {
        viewModel.requestListSuccessHandle = { [weak self] in
            guard let strongSelf = self else { return }
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                XSProgressHUD.hide(for: delegate.window!, animated: true)
            }
            NicooErrorView.removeErrorMeesageFrom(strongSelf.view)
            if strongSelf.currentIndex != 0 {
                strongSelf.mainCV.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .top, animated: false)
            }
            strongSelf.isFirstIn = true
            strongSelf.currentIndex = 0
            strongSelf.currentPlayIndex = 0
            strongSelf.mainCV.mj_footer.endRefreshing()
            if strongSelf.viewModel.sourceCount > 0 {
                strongSelf.mainCV.isScrollEnabled = true
            }
            if !strongSelf.viewModel.isRecomment && strongSelf.viewModel.getHomeList().count == 0 {
                NicooErrorView.showErrorMessage("您还没有关注过别人，快去关注吧~", on: strongSelf.view, customerTopMargin: screenHeight/2 - 40, clickHandler: nil)
            } 
            strongSelf.mainCV.reloadData()
        }
        viewModel.requestFailedHandle = { [weak self] (msg) in
            guard let strongSelf = self else { return }
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
               XSProgressHUD.hide(for: delegate.window!, animated: true)
            }
            NicooErrorView.showErrorMessage(.noNetwork, on: strongSelf.view, clickHandler: {
                strongSelf.loadData(isRecomment: strongSelf.isRecoment)
            })
        }
        userInfoViewModel.followAddOrCancelSuccessHandler = {[weak self]  isAdd, followOrCancelModel in
             guard let strongSelf = self else { return }
            if strongSelf.viewModel.homeModels[strongSelf.currentIndex].video != nil {
                strongSelf.viewModel.homeModels[strongSelf.currentIndex].video!.user?.followed = isAdd ? .focus : .notFocus
                let models = strongSelf.fixModelFollowStatu(isAdd ? .focus : .notFocus, userId: strongSelf.viewModel.homeModels[strongSelf.currentIndex].video?.user?.id ?? 0, datas: strongSelf.viewModel.homeModels)
                strongSelf.viewModel.homeModels = models
            }
            if let cell = strongSelf.mainCV.cellForItem(at: IndexPath.init(item: strongSelf.currentIndex, section: 0)) as? QHHomeCollectionViewCell {
                cell.seriesAddButton.setImage(UIImage(named: "followSuccess"), for: .normal)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                    cell.seriesAddButton.setImage(UIImage(named: "VideoSeriesAdd"), for: .normal)
                    cell.seriesAddButton.isHidden = isAdd
                })
            }
        }
        userInfoViewModel.followOrCancelFailureHandler = { (isAdd, msg) in
            XSAlert.show(type: .error, text: msg)
        }
        
        viewModel.activitySuccessHandler = { [weak self]  activityModel  in
            guard let strongSelf = self else { return }
            strongSelf.activityModel = activityModel
            if let activityType = activityModel.type, activityType == .native { // 原生页面
                strongSelf.activityView.isHidden = false
                strongSelf.activityView.setActivityModel(strongSelf.activityModel)
            } else {
                if let redirect_Url = activityModel.redirect_url {
                    if redirect_Url.isEmpty {
                        strongSelf.activityView.isHidden = true
                    } else {
                        strongSelf.activityView.isHidden = false
                        strongSelf.activityView.setActivityModel(strongSelf.activityModel)
                    }
                } else {
                    strongSelf.activityView.isHidden = true
                }
            }
            strongSelf.showActivityAlert()
        }
        viewModel.activityFailedHandler = { [weak self] errorMsg in
            guard let strongSelf = self else { return }
            strongSelf.activityView.isHidden = true
            strongSelf.showSystemMsgAlert()
        }
    }
    
    
    ///MARK: -推荐，关注，搜索的回调
    func addSegActionHandler() {
        topSegView.actionHandler = { [weak self] (tag) in
            guard let strongSelf = self else { return }
            if tag == 1 {
                DLog("load recomment Data")
                strongSelf.isRecoment = true
                strongSelf.loadData(isRecomment: true)
            } else if tag == 2 {
                DLog("load attention Data")
                strongSelf.isRecoment = false
                if strongSelf.isAttentionPeople {
                    strongSelf.loadData(isRecomment: false)
                } else {
                    /// 没有关注的人，点击后直接重置到 推荐
                    strongSelf.topSegView.segBtnClick(strongSelf.topSegView.reconmentBtn)
                    XSAlert.show(type: .error, text: "您还没有关注过别人，快去关注吧")
                }
                
            } else if tag == 3 {
                let searchVC = SearchMainController()
                let nav = QHNavigationController(rootViewController: searchVC)
                nav.modalPresentationStyle = .fullScreen
                self?.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    /// 活动弹框
    func showActivityAlert() {
        let controller = ActivityAlertController(activityIcon: activityModel.sk_icon ?? "")
        controller.modalPresentationStyle = .overCurrentContext
        self.modalPresentationStyle = .currentContext
        self.present(controller, animated: false, completion: nil)
        controller.actionClcick = { actionId in
            if actionId == 1 {  // 点击活动
                self.goActivityItemPath(self.activityModel)
                controller.dismiss(animated: false, completion: nil)
            } else {
                controller.dismiss(animated: false) {
                    /// 系统公告
                    self.showSystemMsgAlert()
                }
            }
        }
    }
    
    /// 活动
    func goActivityItemPath(_ model: ActivityModel) {
        if let redirect_position = model.redirect_position {
            if redirect_position == .MEMBER_RECHARGE_DETAIL { /// 会员中心
                ///跳转到会员中心
                let vip = InvestController()
                vip.currentIndex = 0
                navigationController?.pushViewController(vip, animated: true)
            } else if redirect_position == .DY_WALLET { ///我的钱包
                let walletvc =  WalletMainNewController()
                navigationController?.pushViewController(walletvc, animated: true)
            } else if redirect_position == .ACT_DETAIL {
                let activityNative = ActivityMainController()
                activityNative.activityModel = activityModel
                if let topicModels = activityModel.topics, topicModels.count > 0 {
                    activityNative.activityTalks = topicModels
                }
                if let itemsModel = activityModel.childs, itemsModel.count > 0 {
                    activityNative.activityItems = itemsModel
                }
                navigationController?.pushViewController(activityNative, animated: true)
            }
        }
    }
}

// MARK: - Show AppUpdateInfo
private extension QHHomeViewController {
    
    @objc func checkAppVersionInfo() {
        let appInfo = AppInfo.share()
        guard let versionNew = appInfo.version_code else { return }
        guard let numVersionNew = versionNew.removeAllPoints() else { return }
        guard let numVersionCurrent = getCurrentAppVersion().removeAllPoints() else { return }
        if Int(numVersionNew) != nil && Int(numVersionCurrent) != nil && Int(numVersionNew)! > Int(numVersionCurrent)! {
            (self.navigationController as! QHNavigationController).pan?.isEnabled = false
            let controller = AlertManagerController()
             controller.alertType = .updateInfo
            controller.modalPresentationStyle = .overCurrentContext
            controller.commitActionHandler = { [weak self] in
                self?.goAndUpdate(String(format: "%@", appInfo.package_path ?? ConstValue.kAppDownLoadLoadUrl))
            }
            controller.cancleActionHandler = { [weak self] in
                self?.goAndUpdate(String(format: "%@", appInfo.official_url ?? ConstValue.kAppDownLoadLoadUrl))
            }
            controller.closeActionHandler = {
                (self.navigationController as! QHNavigationController).pan?.isEnabled = true
            }
            self.modalPresentationStyle = .currentContext
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func getCurrentAppVersion() -> String {
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: filePath!)
        return dictionary!["CFBundleShortVersionString"] as! String
    }
    
    func goAndUpdate(_ downLoadUrl: String?) {
        if let urlstring = downLoadUrl {
            let downUrl = String(format: "%@", urlstring)
            if let url = URL(string: downUrl) {
                DLog(downUrl)
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: {
                                                (success) in
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    /// 从相册选择视频
    func choseVideoFromLibrary() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Thumbnail", bundle: nil)
        let vc: ThumbnailViewController = storyboard.instantiateViewController(withIdentifier: "Thumbnail") as! ThumbnailViewController
        let nav = QHNavigationController(rootViewController: vc)
        vc.videoChoseHandler = { (asset) in
            DLog("videoChoseHandler.asset= \(asset)")
            self.libraryVideoEditor(asset: asset)
        }
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    /// 选择视频编辑
    private func libraryVideoEditor(asset: PHAsset) {
        switch asset.mediaType {
        case .video:
            let storyboard: UIStoryboard = UIStoryboard(name: "VT", bundle: nil)
            let vc: VTViewController = storyboard.instantiateViewController(withIdentifier: "VT") as! VTViewController
            vc.asset = asset
            vc.sourceType = .Source_Library
            //vc.camareVideoPath = FileManager.videoExportURL
            self.navigationController?.pushViewController(vc, animated: false)
        default:
            break
        }
    }
}

// MARK: - play video
extension QHHomeViewController {
    
    private func playVideo(homeModel: HomeVideoModel, cell: QHHomeCollectionViewCell, indexPath: IndexPath) {
        if (homeModel.type ?? .videoType) == .videoType {
            guard let videoModel = homeModel.video else {
                videoTypeConfig(video: nil, cell: cell)
                return
            }
            if (videoModel.is_coins ?? 0) == 1 {                // 金币视频
                if UserModel.share().userInfo?.id == videoModel.user?.id {  /// 自己的作品
                    playerView.timeProgressEnabled(true)
                    playerView.setCoinsVideoValues(isCoin: (videoModel.is_coins ?? 0) == 1, coinsCount: 0, coinsUser: UserModel.share().wallet?.coins ?? 0, userNickName: videoModel.user?.nikename ?? "")
                    playWithVideo(videoModel, cell)
                } else {
                    playerView.timeProgressEnabled((videoModel.coins ?? 0) <= 0)  // 已购买才能拖进度条
                    coinsVideoConfig(video: videoModel, cell: cell)
                }
            } else {                                             // 非金币视频
                /// 这里让那个播放器的进度条可以操作
                self.playerView.timeProgressEnabled(true)
                //isPanGuestureEnable(true)
                let video = homeModel.video
                playerView.setCoinsVideoValues(isCoin: false, coinsCount: 0, coinsUser: UserModel.share().wallet?.coins ?? 0, userNickName: video?.user?.nikename ?? "")
                videoTypeConfig(video: video, cell: cell)
            }
        } else {
            self.playerView.timeProgressEnabled(false)
            let adModel = homeModel.ad
            playerView.setCoinsVideoValues(isCoin: false, coinsCount: 0, coinsUser: 0, userNickName: adModel?.title ?? "")
            adTypeConfig(adModel: adModel, cell: cell)
        }
    }
    
    private func videoTypeConfig(video: VideoModel?, cell: QHHomeCollectionViewCell) {
        viewModel.loadVideoAuthData(params: [VideoAuthApi.kVideo_id: video?.id ?? 0], succeedHandler: { [weak self] in
            guard let strongSelf = self else { return }
            cell.startLoadingPlayItemAnim(true)
            strongSelf.playWithVideo(video, cell)
        }) { [weak self] (errorMsg) in
            guard let strongSelf = self else { return }
            cell.startLoadingPlayItemAnim(true)
            if errorMsg == "403" {
                strongSelf.playerView.isNotPermission = true
                strongSelf.playerView.playVideo(URL(string: "http://123.mp4"), "", cell.bgImage)
                strongSelf.playerView.showLoadedFailedView("noPermission", nil)
            } else {
                strongSelf.playerView.isNotPermission = false
                strongSelf.playerView.playVideo(URL(string: "http://123.mp4"), "", cell.bgImage)
            }
            strongSelf.isFirstIn = false
            strongSelf.currentPlayIndex = strongSelf.currentIndex
        }
    }
    private func coinsVideoConfig(video: VideoModel, cell: QHHomeCollectionViewCell) {
        userInfoViewModel.loadWalletInfo(params: nil, succeedHandler: { [weak self] in
            guard let strongSelf = self else { return }
            /// 对金币视频赋值
            strongSelf.playerView.setCoinsVideoValues(isCoin: (video.is_coins ?? 0) == 1, coinsCount: video.coins ?? 0, coinsUser: UserModel.share().wallet?.coins ?? 0, userNickName: video.user?.nikename ?? "")
            /// 金币视频无需鉴权
            strongSelf.playWithVideo(video, cell)
            
        }) { [weak self] in
            guard let strongSelf = self else { return }
            /// 对金币视频赋值
            strongSelf.playerView.setCoinsVideoValues(isCoin: (video.is_coins ?? 0) == 1, coinsCount: video.coins ?? 0, coinsUser: UserModel.share().wallet?.coins ?? 0, userNickName: video.user?.nikename ?? "")
            /// 金币视频无需鉴权
            strongSelf.playWithVideo(video, cell)
        }
    }
    
    private func playWithVideo(_ video: VideoModel?, _ cell: QHHomeCollectionViewCell) {
        let urlstrMp4 = video?.play_url_mp4
        if let urlStrM3u8 = video?.play_url_m3u8, !urlStrM3u8.isEmpty {
            guard let url = URL(string: urlStrM3u8) else {
                XSAlert.show(type: .error, text: "视频转码失败")
                return
            }
            playerView.video_id = video?.id
            playerView.isNotPermission = false
            playerView.playVideo(url, "", cell.bgImage)
        } else {
            guard let url = URL(string: urlstrMp4 ?? "") else {
                XSAlert.show(type: .error, text: "视频转码失败")
                return
            }
            playerView.video_id = video?.id
            playerView.isNotPermission = false
            playerView.playVideo(url, "", cell.bgImage)
        }
        isFirstIn = false
        currentPlayIndex = currentIndex
    }
    
    private func buyVideoRePlay() {
        guard let video = viewModel.getHomeList()[currentPlayIndex].video else { return }
        viewModel.getHomeList()[currentPlayIndex].video?.coins = 0
        let indexPath = IndexPath(row: currentIndex, section: 0)
        if let cell = mainCV.cellForItem(at: indexPath) as? QHHomeCollectionViewCell {
            /// 对金币视频赋值
            playerView.setCoinsVideoValues(isCoin: (video.is_coins ?? 0) == 1, coinsCount: 0, coinsUser: UserModel.share().wallet?.coins ?? 0, userNickName: video.user?.nikename ?? "")
            // 已购买 解锁进度条
            playerView.timeProgressEnabled(true)
            /// 金币视频无需鉴权
            playWithVideo(video, cell)
        }
    }
    
    private func adTypeConfig(adModel: AdvertiseModel?, cell: QHHomeCollectionViewCell) {
        cell.startLoadingPlayItemAnim(true)
        mainCV.isScrollEnabled = false
        DLog("看广告了")
        adTimerlabel.isHidden = false
        timer = Timer.new(after: 3.seconds) { [weak self] in
            DLog("可以开始滑了")
            self?.mainCV.isScrollEnabled = true
            self?.timer1?.invalidate()
            self?.adTimerlabel.isHidden = true
            self?.adtime = 3
            self?.adTimerlabel.text = "广告时间，\(self?.adtime ?? 3 )秒后可操作"
        }
        timer1 = Timer.every(1.0.seconds) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.adtime = strongSelf.adtime - 1
            self?.adTimerlabel.text = "广告时间，\(strongSelf.adtime)秒后可操作"
        }
       
        RunLoop.current.add(timer, forMode: .default)
        if let urlStrM3u8 = adModel?.play_url_m3u8, !urlStrM3u8.isEmpty {
            let url = URL(string: urlStrM3u8)
            self.playerView.isNotPermission = false
            self.playerView.playVideo(url, "", cell.bgImage)
        } else {
            self.playerView.isNotPermission = false
            self.playerView.playVideo(URL(string: "http://123.mp4"), "", cell.bgImage)
        }
        self.isFirstIn = false
        self.currentPlayIndex = self.currentIndex
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension QHHomeViewController: UIGestureRecognizerDelegate {
    
    func showDetails(_ view: QHHomeCollectionViewCell) {
        /// 如果要让广告的滑动不起效， 可以在这里拦截掉， 不走 p_showDetails
        if viewModel.getHomeList().count > 0 {
             p_showDetails()
        }
    }
}

// MARK: - QHHomeCollectionViewCellDelegate
extension QHHomeViewController: QHHomeCollectionViewCellDelegate {
    func sliderTouch(_ isTouch: Bool) {
        if let vc = getCurrentVC() {
            vc.mainScrollV.isScrollEnabled = false
            (self.navigationController as! QHNavigationController).pan?.isEnabled = !isTouch
        }
    }
    
    func showDetails() {
        if viewModel.getHomeList().count > 0 {
            
            p_showDetails()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension QHHomeViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        activityView.isHidden = true
        DLog("开始拖地")
        let touchPoint = scrollView.panGestureRecognizer.location(in: self.view)
        let tapAreaY = screenHeight - 95 - (UIDevice.current.isXSeriesDevices() ? 34 : 0)
        if touchPoint.y > tapAreaY {
            scrollView.panGestureRecognizer.isEnabled = false
        } else {
            scrollView.panGestureRecognizer.isEnabled = true
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.async {
            ///如果只有没有数据或者只有一条数据不让它滑动，解决角标越界，闪退
            if self.viewModel.getHomeList().count <= 1 {
                return
            }
            /// 禁用手势
            let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
            scrollView.panGestureRecognizer.isEnabled = false
            
            if translatedPoint.y < -50 && self.currentIndex < (self.viewModel.getHomeList().count - 1) {
                /// 上滑
                self.currentIndex += 1
            }
            if translatedPoint.y > 50 && self.currentIndex > 0 {
                /// 下滑
                self.currentIndex -= 1
            }
            if self.currentIndex == self.viewModel.sourceCount - 1 && self.viewModel.getHomeList().count >  self.viewModel.sourceCount {
                self.mainCV.reloadData()
                self.viewModel.sourceCount = self.viewModel.getHomeList().count
            }
            let indexPath = IndexPath(row: self.currentIndex, section: 0)
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                self.mainCV.scrollToItem(at: indexPath, at: .top, animated: true)
            }, completion: { finished in
                scrollView.panGestureRecognizer.isEnabled = true
                if let cell = self.mainCV.cellForItem(at: indexPath) as? QHHomeCollectionViewCell {
                    if self.currentPlayIndex != self.currentIndex { // 上下滑动
                        cell.startLoadingPlayItemAnim(false)
                        self.playVideo(homeModel: self.viewModel.getHomeList()[indexPath.row], cell: cell, indexPath: indexPath)
                    }
                }
                if self.currentIndex == self.viewModel.getHomeList().count - 4 {
                    DLog("给您补给数据。。， ")
                    self.viewModel.loadHomeDataNextPage()
                    // 这里先不刷新
                }
            })
        }
        if let activityType = activityModel.type, activityType == .native { // 原生页面
            activityView.isHidden = false
        } else {
            if activityModel.redirect_url != nil && !activityModel.redirect_url!.isEmpty {
                activityView.isHidden = false
            } else {
                activityView.isHidden = true
            }
        }
        
    }
}

// MARK: - NicooPlayerDelegate

extension QHHomeViewController: NicooPlayerDelegate, NicooCustomMuneDelegate {
    
    func retryToPlayVideo(_ player: NicooPlayerView, _ videoModel: NicooVideoModel?, _ fatherView: UIView?) {
        DLog("网络不可用时调用")
        let url = URL(string: videoModel?.videoUrl ?? "")
        if  let sinceTime = videoModel?.videoPlaySinceTime, sinceTime > 0 {
            player.replayVideo(url, videoModel?.videoName, fatherView, sinceTime)
        } else {
            player.playVideo(url, videoModel?.videoName, fatherView)
        }
    }
    func customActionForPalyer(_ player: NicooPlayerView, _ actionKeyId: Int) {
        if actionKeyId == 1 {
            self.loadData(isRecomment: self.isRecoment)
        } else if actionKeyId == 2 {
            // 跳转到
            let vipVC = InvestController()
            vipVC.currentIndex = 0
            navigationController?.pushViewController(vipVC, animated: true)
        } else if actionKeyId == 3 {
            let shareVc = ShareContentController()
            shareVc.modalPresentationStyle = .overCurrentContext
            shareVc.definesPresentationContext = true
            shareVc.view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
            present(shareVc, animated: false, completion: nil)
        } else if actionKeyId == 4 {
            let typeChoseVC = PushTypeChoseController()
            typeChoseVC.itemCount = 2
            typeChoseVC.modalPresentationStyle = .overCurrentContext
            typeChoseVC.definesPresentationContext = true
            self.present(typeChoseVC, animated: false, completion: nil)
            typeChoseVC.pushtypeChoseHandler = { typeId in
                if typeId == 0 {
                    let recordVc = QHRecordViewController()
                    self.navigationController?.pushViewController(recordVc, animated: true)
                } else if typeId == 1 {
                    self.choseVideoFromLibrary()
                }
            }
        } else if actionKeyId == 5 {  // 充值金币
            let investVC = InvestController()
            investVC.currentIndex = 2
            navigationController?.pushViewController(investVC, animated: true)
        } else if actionKeyId == 6 {  // 金币购买视频
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                XSProgressHUD.showCycleProgress(msg: "支付中...", onView: delegate.window!, animated: false)
            }
            guard let videoModel = viewModel.getHomeList()[currentPlayIndex].video else { return }
            userInfoViewModel.coinsBuyVideo(params: [UseBuyVideoApi.kVideoId: videoModel.id ?? 0] , succeedHandler: { [weak self] in
                guard let strongSelf = self else { return }
                if let delegate = UIApplication.shared.delegate as? AppDelegate {
                    XSProgressHUD.hide(for: delegate.window!, animated: true)
                }
                XSAlert.show(type: .success, text: "恭喜您购买成功")
                strongSelf.buyVideoRePlay()
            }) { (failMsg) in
                XSAlert.show(type: .error, text: failMsg)
                if let delegate = UIApplication.shared.delegate as? AppDelegate {
                    XSProgressHUD.hide(for: delegate.window!, animated: true)
                }
            }
        }
    }
    
    func showOrHideLoadingview(_ isPlayingOrFailed: Bool) {
        let indexPath = IndexPath(row: self.currentIndex, section: 0)
        if let cell = self.mainCV.cellForItem(at: indexPath) as? QHHomeCollectionViewCell {
            cell.startLoadingPlayItemAnim(!isPlayingOrFailed)
        }
    }
    
    func enableScrollAndPanGestureOrNoteWith(isEnable: Bool) {
        DLog("scroll == \(isEnable)")
        activityView.isHidden = !isEnable
        let indexPath = IndexPath(row: self.currentIndex, section: 0)
        if let cell = self.mainCV.cellForItem(at: indexPath) as? QHHomeCollectionViewCell {
            cell.setUIHidenOrNot(!isEnable)
        }
    }
    func doubleTapGestureAction() {
        if let model = viewModel.getHomeList()[currentIndex].video, let isFavor = model.recommend?.isFavor {
            if !isFavor {  // 没有点赞
                let indexPath = IndexPath(row: self.currentIndex, section: 0)
                userInfoViewModel.addVideoFavor([UserFavorAddApi.kVideo_id: model.id ?? 0, UserFavorAddApi.kStatus: 1, UserFavorAddApi.kAction: UserFavorAddApi.kDefaultAction])
                let appraiseCount = viewModel.getHomeList()[indexPath.row].video?.recommend_count ?? 0
                let favorCount = appraiseCount + 1
                viewModel.homeModels[indexPath.row].video?.recommend_count = favorCount
                viewModel.homeModels[indexPath.row].video?.recommend = Recommend(rawValue: 1)
                if let cell = self.mainCV.cellForItem(at: indexPath) as? QHHomeCollectionViewCell {
                    cell.favorItem.title = "\(favorCount)"
                    cell.setFavorStatu(true)
                }
            }
        }
    }
    
}

// MARK: - Layout
private extension QHHomeViewController {
    
    func layoutPageSubviews() {
        layoutAdTimerLable()
        layoutTopSegView()
        layoutActivityView()
    }
    
    func layoutAdTimerLable() {
        adTimerlabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(-15)
            make.top.equalTo(ConstValue.kStatusBarHeight + 50)
            make.height.equalTo(30)
            make.width.equalTo(180)
        }
    }
    func layoutTopSegView() {
        let topMargin: CGFloat = ConstValue.kStatusBarHeight
        topSegView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topMargin)
            make.height.equalTo(40)
        }
    }
    
    func layoutActivityView() {
        let topMargin: CGFloat = screenHeight - safeAreaBottomHeight - 430
        activityView.snp.makeConstraints { (make) in
            make.trailing.equalTo(-6)
            make.size.equalTo(CGSize(width: 50, height: 60))
            make.top.equalTo(topMargin)
        }
    }

}

extension QHHomeViewController {
    func fixModelFollowStatu(_ statu: FocusVideoUploader, userId: Int, datas: [HomeVideoModel]) -> [HomeVideoModel] {
        for homeModel in datas {
            if homeModel.video?.user?.id == userId {
                homeModel.video?.user?.followed = statu
            }
        }
        return datas
    }
}
