//
//  CommunityPlayController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/11.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import DouYPlayer
import AssetsLibrary
import Photos

class CommunityPlayController: UIViewController {

    var currentIndex:Int = 0
    var currentPlayIndex: Int = 0
    
    var urls = [String]()
    
    lazy var playerView: NicooPlayerView = {
        let player = NicooPlayerView(frame: view.bounds, bothSidesTimelable: true)
        player.videoLayerGravity = .resizeAspect
        player.videoNameShowOnlyFullScreen = true
        player.delegate = self
        player.customViewDelegate = self
        return player
    }()
    private let commentbgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 30, g: 17, b: 23)
        return view
    }()
    private lazy var videoCommentView: VideoCommentView = {
        let view = VideoCommentView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 50))
        view.backgroundColor = UIColor.clear
        return view
    }()
    lazy var leftBackButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "navBackWhite"), for: .normal)
        button.backgroundColor = UIColor(white: 0.9, alpha: 0.2)
        button.layer.cornerRadius = 17.5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        return button
    }()
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        //每个Item之间最小的间距
        layout.minimumInteritemSpacing = 0
        //每行之间最小的间距
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    lazy var collection: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
        collectionView.register(PresentPlayCell.classForCoder(), forCellWithReuseIdentifier: PresentPlayCell.cellId)
        return collectionView
    }()
    
    /// 没有次数的时候去充值
    var goVerbOrRefreshActionHandler:((_ goVerb: Bool) -> Void)?
    
    private let userInfoViewModel = UserInfoViewModel()
    
    var isRefreshOperation = false
    
    var isFirstIn = true
    
    var playWorks = false
    
    var commentMsg: String = ""
    
    var topicModels = [TopicModel]()
    
    let videoViewModel = VideoViewModel()
    /// 是否还能点击头像跳转
    var canGoNext: Bool = true
    
    deinit {
        DLog("release ---- PresentPlayVC")
        NotificationCenter.default.removeObserver(self, name: Notification.Name.kAttentionVideoUploaderNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        setUpUI()
        collection.scrollToItem(at: IndexPath.init(item: currentIndex, section: 0), at: .top, animated: false)
        addUserInfoViewModelCallBack()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveUserCenterFollowStatus), name: Notification.Name.kAttentionVideoUploaderNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerView.playerStatu = PlayerStatus.Pause
    }
    
    private func setUpUI() {
        view.addSubview(collection)
        view.addSubview(commentbgView)
        commentbgView.addSubview(videoCommentView)
        if #available(iOS 11.0, *) {
            collection.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(leftBackButton)
        
        layoutPageSubviews()
        addCommentViewCallBackHandler()
    }
    
    /// 添加评论栏点击回调
    func addCommentViewCallBackHandler() {
        videoCommentView.sendCommentTextHandler = { [weak self] (text) in
            guard let strongSelf = self else { return }
            if text.isEmpty {
                XSAlert.show(type: .warning, text: "请输入评论内容。")
                return
            }
            strongSelf.commentMsg = text
            if let videoid = strongSelf.topicModels[strongSelf.currentIndex].video?[0].id {
                strongSelf.videoViewModel.loadVideoCommentApi([VideoCommentApi.kVideo_Id : videoid, VideoCommentApi.kContent: text])
            }
        }
        videoViewModel.videoCommentSuccessHandler = { [weak self] in
            self?.videoCommentView.textInputView.text = nil
            self?.commentMsg = ""
            XSAlert.show(type: .success, text: "评论成功。")
        }
        
        videoViewModel.videoCommentFailedHandler = { [weak self] msg in
            self?.commentMsg = ""
            self?.videoCommentView.textInputView.text = nil
            XSAlert.show(type: .error, text: msg)
        }
    }
    
    ///接收他人主页关注状态的通知
    @objc func receiveUserCenterFollowStatus(notify: Notification) {
        if let userinfo = notify.userInfo {
            if let isAttention =  userinfo["isAttention"] as? Bool, let user = userinfo["user"] as? UserInfoModel  {
                if isAttention {
                    for video in topicModels {
                        if let users = video.user {
                            if users.id == user.id {
                                users.followed = .focus
                            }
                        }
                    }
                } else {
                    for video in topicModels {
                        if let users = video.user {
                            if users.id == user.id {
                                users.followed = .notFocus
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
        
    }
    
    @objc func backButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    ///用户操作的回调
    func addUserInfoViewModelCallBack() {
        userInfoViewModel.followAddOrCancelSuccessHandler = { [weak self] isAdd , model in
            guard let strongSelf = self else {return}
            if strongSelf.topicModels.count > 0 {
                for video in strongSelf.topicModels {
                    if isAdd {
                        video.user?.followed = .focus
                    } else {
                        video.user?.followed = .notFocus
                    }
                }
                DispatchQueue.main.async {
                    strongSelf.collection.reloadData()
                    ///通知用户主页去再次请求关注状态的接口
                    NotificationCenter.default.post(name: Notification.Name.kUserCenterRefreshAttentionStateNotification, object: nil)
                }
            }
        }
        
        userInfoViewModel.followOrCancelFailureHandler = { (isAdd, msg) in
            XSAlert.show(type: .error, text: msg)
        }
    }
    
    func goUserCenter(_ user: UserInfoModel) {
        if !canGoNext {
            backButtonClick()
            return
        }
        let usercenter = UserMCenterController()
        usercenter.user = user
        usercenter.followOrCancelBackHandler = { statu in
            self.reloadCurrentIndexFocusStatu(statu)
        }
        navigationController?.pushViewController(usercenter, animated: true)
    }
    
    func reloadCurrentIndexFocusStatu(_ statu: FocusVideoUploader) {
        if let cell = collection.cellForItem(at: IndexPath.init(item: currentIndex, section: 0)) as? PresentPlayCell {
            cell.seriesAddButton.isHidden = statu == .focus
            topicModels[currentIndex].user?.followed = statu
        }
    }
    
    func commentgoUserCenter(_ user: UserInfoModel?) {
        let userCenter = UserMCenterController()
        userCenter.user = user
        navigationController?.pushViewController(userCenter, animated: true)
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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CommunityPlayController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topicModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PresentPlayCell.cellId, for: indexPath) as! PresentPlayCell
        cell.backgroundColor = UIColor.darkText
        guard let videoModel = topicModels[indexPath.item].video?[0] else { return cell}
        if topicModels.count > indexPath.item {
            cell.setVideoModel(videoModel)
            cell.setTalksMode(topicModels[indexPath.item].topic)
            cell.commentItem.msgLable.text = getStringWithNumber(videoModel.comment_count ?? 0)
            cell.favorItem.title = getStringWithNumber(videoModel.recommend_count ?? 0)
            /// 第一次进入，播放第currentIndex条
            if indexPath.row == currentIndex && isFirstIn {
                if playWorks {
                    self.playWork(video: videoModel, cell: cell, indexPath: indexPath)
                } else {
                    self.configVideo(videoModel, cell: cell, indexPath: indexPath)
                }
            }
        }
        if let userModel = videoModel.user {
            cell.seriesButton.kfSetHeaderImageWithUrl(userModel.cover_path, placeHolder: UserModel.share().getUserHeader(userModel.id))
            cell.seriesButton.setTitle("", for: .normal)
            cell.nameLable.text = "@\(userModel.nikename ?? "老湿")"
        }
        cell.didClickSeriesHandler = { [weak self] in
            guard let strongSelf = self else {return}
            if let user = videoModel.user {
                strongSelf.goUserCenter(user)
            }
        }
        cell.commentItemClick = { [weak self] in
            let commentVC = CommentsMController()
            commentVC.videoId = videoModel.id ?? 0
            commentVC.userId = videoModel.user?.id ?? 0
            commentVC.modalPresentationStyle = .overCurrentContext
            commentVC.definesPresentationContext = true
            commentVC.view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
            self?.present(commentVC, animated: true, completion: nil)
            commentVC.userClickHandler = { [weak self] user in
                self?.commentgoUserCenter(user)
                commentVC.dismiss(animated: false, completion: nil)
            }
            commentVC.buyVipClickHandler = {
                let vipvc = InvestController()
                vipvc.currentIndex = 0
                self?.navigationController?.pushViewController(vipvc, animated: true)
                commentVC.dismiss(animated: false, completion: nil)
            }
        }
        cell.shareItemClick = { [weak self] in
            let textShare = videoModel.title
            let topicShare = self?.topicModels[indexPath.item].topic?.title
            UserModel.share().shareImageLink = videoModel.cover_path
            UserModel.share().shareText = self?.getShareText(topicShare , textShare)
            let shareVc = ShareContentController()
            shareVc.modalPresentationStyle = .overCurrentContext
            shareVc.definesPresentationContext = true
            shareVc.view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
            self?.present(shareVc, animated: false, completion: nil)
        }
        cell.videoFavorItemClick = { [weak self] (isFavor) in
            guard let strongSelf = self else { return  0 }
            strongSelf.userInfoViewModel.addVideoFavor([UserFavorAddApi.kVideo_id: videoModel.id ?? 0, UserFavorAddApi.kStatus: isFavor ? 0 : 1, UserFavorAddApi.kAction: UserFavorAddApi.kDefaultAction])
            if let appraiseCount = videoModel.recommend_count {
                let favorCount = isFavor ? appraiseCount - 1 : appraiseCount + 1
                videoModel.recommend_count = favorCount
                videoModel.recommend = Recommend(rawValue: isFavor ? 0 : 1)
                return favorCount
            }
            return 0
        }
        cell.addFollowHandler = { [weak self]  in
            guard let strongSelf = self else {
                return
            }
            if let id = videoModel.user?.id {
                strongSelf.userInfoViewModel.loadAddFollowApi([UserFollowStatuApi.kUserId: id, UserFollowStatuApi.kSelfId: UserModel.share().userInfo?.id ?? 0])
            }
        }
        cell.clickTypeKeyCellHandler = { [weak self] videoKey in
            guard let strongSelf = self else { return }
            let keyMainVc = SeriesKeyMainController()
            keyMainVc.keyMode = videoKey
            strongSelf.navigationController?.pushViewController(keyMainVc, animated: true)
        }
        cell.talksKeyClickHandler = { [weak self] in
            guard let strongSelf = self else { return }
            if let model = strongSelf.topicModels[indexPath.item].topic {
                let topicVC = TalksMainController()
                topicVC.talksModel = model
                strongSelf.navigationController?.pushViewController(topicVC, animated: true)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension CommunityPlayController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size;
    }
}

// MARK: - play video
extension CommunityPlayController {
    
    private func configVideo(_ videoModel: VideoModel, cell: PresentPlayCell, indexPath: IndexPath) {
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
            playerView.setCoinsVideoValues(isCoin: false, coinsCount: 0, coinsUser: UserModel.share().wallet?.coins ?? 0, userNickName: videoModel.user?.nikename ?? "")
            playVideo(video: videoModel, cell: cell, indexPath: indexPath)
        }
    }
    private func playVideo(video: VideoModel, cell: PresentPlayCell, indexPath: IndexPath) {
        videoViewModel.loadVideoAuthData(params: [VideoAuthApi.kVideo_id: video.id ?? 0], succeedHandler: { [weak self] in
            guard let strongSelf = self else { return }
            cell.startLoadingPlayItemAnim(true)
            strongSelf.playWithVideo(video, cell)
        }) { [weak self] (errorMsg) in
            guard let strongSelf = self else { return }
            cell.startLoadingPlayItemAnim(true)
            if errorMsg == "403" {
                strongSelf.playerView.isNotPermission = true
                strongSelf.playerView.playVideo(URL(string: "http://123.mp4"), "", cell.imageBackGroup)
                strongSelf.playerView.showLoadedFailedView("noPermission", nil)
            } else {
                strongSelf.playerView.isNotPermission = false
                strongSelf.playerView.playVideo(URL(string: "http://123.mp4"), "", cell.imageBackGroup)
            }
            strongSelf.isFirstIn = false
            strongSelf.currentPlayIndex = strongSelf.currentIndex
        }
    }
    private func coinsVideoConfig(video: VideoModel, cell: PresentPlayCell) {
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
    private func playWithVideo(_ video: VideoModel?, _ cell: PresentPlayCell) {
        let urlstrMp4 = video?.play_url_mp4
         if let urlStrM3u8 = video?.play_url_m3u8, !urlStrM3u8.isEmpty {
            guard let url = URL(string: urlStrM3u8) else {
                XSAlert.show(type: .error, text: "视频转码失败")
                return
            }
            playerView.video_id = video?.id
            playerView.isNotPermission = false
            playerView.playVideo(url, "", cell.imageBackGroup)
        } else {
            guard let url = URL(string: urlstrMp4 ?? "") else {
                XSAlert.show(type: .error, text: "视频转码失败")
                return
            }
            playerView.video_id = video?.id
            playerView.isNotPermission = false
            playerView.playVideo(url, "", cell.imageBackGroup)
        }
        isFirstIn = false
        currentPlayIndex = currentIndex
    }
    private func playWork(video: VideoModel, cell: PresentPlayCell, indexPath: IndexPath) {
        cell.startLoadingPlayItemAnim(true)
        let urlstrMp4 = video.play_url_mp4
        if let urlStrM3u8 = video.play_url_m3u8, !urlStrM3u8.isEmpty {
            let url = URL(string: urlStrM3u8)
            self.playerView.video_id = video.id
            self.playerView.isNotPermission = false
            self.playerView.playVideo(url, "", cell.imageBackGroup)
        } else {
            let url = URL(string: urlstrMp4 ?? "")
            self.playerView.video_id = video.id
            self.playerView.isNotPermission = false
            self.playerView.playVideo(url, "", cell.imageBackGroup)
        }
        isFirstIn = false
        currentPlayIndex = currentIndex
    }
    
    private func buyVideoRePlay() {
        guard let video = topicModels[currentIndex].video?[0] else { return }
        video.coins = 0
        let indexPath = IndexPath(row: currentIndex, section: 0)
        if let cell = collection.cellForItem(at: indexPath) as? PresentPlayCell {
            /// 对金币视频赋值
            playerView.setCoinsVideoValues(isCoin: (video.is_coins ?? 0) == 1, coinsCount: 0, coinsUser: UserModel.share().wallet?.coins ?? 0, userNickName: video.user?.nikename ?? "")
            // 已购买 解锁进度条
            playerView.timeProgressEnabled(true)
            /// 金币视频无需鉴权
            playWithVideo(video, cell)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension CommunityPlayController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
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
            /// 禁用手势
            let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
            scrollView.panGestureRecognizer.isEnabled = false
            
            if translatedPoint.y < -50 && self.currentIndex < (self.topicModels.count - 1) {
                /// 上滑
                self.currentIndex += 1
            }
            if translatedPoint.y > 50 && self.currentIndex > 0 {
                /// 下滑
                self.currentIndex -= 1
            }
            let indexPath = IndexPath(row: self.currentIndex, section: 0)
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                if self.topicModels.count > indexPath.row {
                    self.collection.scrollToItem(at: indexPath, at: .top, animated: true)
                }
            }, completion: { finished in
                scrollView.panGestureRecognizer.isEnabled = true
                if let cell = self.collection.cellForItem(at: indexPath) as? PresentPlayCell {
                    if self.currentPlayIndex != self.currentIndex { // 上下滑动
                        cell.startLoadingPlayItemAnim(false)
                        if let videoModel = self.topicModels[indexPath.row].video?[0] {
                            self.configVideo(videoModel, cell: cell, indexPath: indexPath)
                        }
                    }
                }
            })
        }
    }
}


// MARK: - NicooPlayerDelegate
extension CommunityPlayController: NicooPlayerDelegate, NicooCustomMuneDelegate {
    func customActionForPalyer(_ player: NicooPlayerView, _ actionKeyId: Int) {
        if actionKeyId == 1 {
            goVerbOrRefreshActionHandler?(false)
            dismiss(animated: true, completion: nil)
        } else if actionKeyId == 2 {
            goVerbOrRefreshActionHandler?(true)
            dismiss(animated: true, completion: nil)
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
        } else if actionKeyId == 5 { //  充值金币
            let investVC = InvestController()
            investVC.currentIndex = 2
            navigationController?.pushViewController(investVC, animated: true)
        } else if actionKeyId == 6 {
            XSProgressHUD.showCycleProgress(msg: "支付中...", onView: view, animated: false)
            guard let videoModel = topicModels[currentIndex].video?[0] else { return }
            userInfoViewModel.coinsBuyVideo(params: [UseBuyVideoApi.kVideoId: videoModel.id ?? 0] , succeedHandler: { [weak self] in
                guard let strongSelf = self else { return }
                XSProgressHUD.hide(for: strongSelf.view, animated: false)
                XSAlert.show(type: .success, text: "恭喜您购买成功")
                strongSelf.buyVideoRePlay()
            }) { [weak self] (failMsg) in
                guard let strongSelf = self else { return }
                XSAlert.show(type: .error, text: failMsg)
                XSProgressHUD.hide(for: strongSelf.view, animated: false)
            }
        }
    }
    
    func retryToPlayVideo(_ player: NicooPlayerView, _ videoModel: NicooVideoModel?, _ fatherView: UIView?) {
        DLog("网络不可用时调用")
        let url = URL(string: videoModel?.videoUrl ?? "")
        if  let sinceTime = videoModel?.videoPlaySinceTime, sinceTime > 0 {
            player.replayVideo(url, videoModel?.videoName, fatherView, sinceTime)
        } else {
            player.playVideo(url, videoModel?.videoName, fatherView)
        }
    }
    
    func showOrHideLoadingview(_ isPlayingOrFailed: Bool) {
        let indexPath = IndexPath(row: self.currentIndex, section: 0)
        if let cell = collection.cellForItem(at: indexPath) as? PresentPlayCell {
            cell.startLoadingPlayItemAnim(!isPlayingOrFailed)
        }
    }
    
    func enableScrollAndPanGestureOrNoteWith(isEnable: Bool) {
        let indexPath = IndexPath(row: self.currentIndex, section: 0)
        if let cell = collection.cellForItem(at: indexPath) as? PresentPlayCell {
            cell.setUIHidenOrNot(!isEnable)
        }
    }
    
    func doubleTapGestureAction() {
        guard let model = topicModels[currentIndex].video?[0] else { return }
        if let isFavor = model.recommend?.isFavor {
            if !isFavor {  // 没有点赞
                let indexPath = IndexPath(row: self.currentIndex, section: 0)
                userInfoViewModel.addVideoFavor([UserFavorAddApi.kVideo_id: model.id ?? 0, UserFavorAddApi.kStatus: 1, UserFavorAddApi.kAction: UserFavorAddApi.kDefaultAction])
                let appraiseCount = model.recommend_count ?? 0
                let favorCount = appraiseCount + 1
                model.recommend_count = favorCount
                model.recommend = Recommend(rawValue: 1)
                if let cell = self.collection.cellForItem(at: indexPath) as? PresentPlayCell {
                    cell.favorItem.title = "\(favorCount)"
                    cell.setFavorStatu(true)
                }
            }
        }
    }
}

// MARK: - Layout
private extension CommunityPlayController {
    
    func layoutPageSubviews() {
        layoutLeftBackButton()
        layoutCommentBgView()
        layoutCommentView()
        layoutCollection()
    }
    
    func layoutCollection() {
        collection.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview()
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
            make.top.equalToSuperview()
            make.height.equalTo(49)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func layoutLeftBackButton() {
        leftBackButton.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.top.equalTo(ConstValue.kStatusBarHeight + 10)
            make.width.height.equalTo(35)
        }
    }
}
