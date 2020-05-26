//
//  SeriesPlayController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/25.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import DouYPlayer
import AssetsLibrary
import Photos

/// 系列详情弹出播放页
class SeriesPlayController: UIViewController {
    
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
    
    var commentMsg: String = ""
    
    /// 没有次数的时候去充值
    var goVerbOrRefreshActionHandler:((_ goVerb: Bool) -> Void)?
    
    private let userInfoViewModel = UserInfoViewModel()
    
    var isRefreshOperation = false
    
    var isFirstIn = true
    
    var videos: [VideoModel]!
    
    let videoViewModel = VideoViewModel()
    
    
    deinit {
        DLog("release ---- PresentPlayVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        setUpUI()
        collection.scrollToItem(at: IndexPath.init(item: currentIndex, section: 0), at: .top, animated: false)
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
        addViewModelCallback()
        
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
            if let videoid = strongSelf.videos[strongSelf.currentIndex].id {
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
    
    @objc func backButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func goUserCenter(_ user: UserInfoModel) {
        let usercenter = UserMCenterController()
        usercenter.user = user
        usercenter.followOrCancelBackHandler = { statu in
            self.reloadCurrentIndexFocusStatu(statu)
        }
        navigationController?.pushViewController(usercenter, animated: true)
    }
    func addViewModelCallback() {
        userInfoViewModel.followAddOrCancelSuccessHandler = {[weak self]  isAdd, followOrCancelModel in
            guard let strongSelf = self else { return }
            strongSelf.videos[strongSelf.currentIndex].user?.followed = isAdd ? .focus : .notFocus
            if let cell = strongSelf.collection.cellForItem(at: IndexPath.init(item: strongSelf.currentIndex, section: 0)) as? PresentPlayCell {
                cell.seriesAddButton.isHidden = isAdd
            }
        }
        userInfoViewModel.followOrCancelFailureHandler = { (isAdd, msg) in
            XSAlert.show(type: .error, text: msg)
        }
    }
    
    func reloadCurrentIndexFocusStatu(_ statu: FocusVideoUploader) {
        if let cell = collection.cellForItem(at: IndexPath.init(item: currentIndex, section: 0)) as? PresentPlayCell {
            cell.seriesAddButton.isHidden = statu == .focus
            videos[currentIndex].user?.followed = statu
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
extension SeriesPlayController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PresentPlayCell.cellId, for: indexPath) as! PresentPlayCell
        cell.backgroundColor = UIColor.darkText
        if videos.count > indexPath.row {
            let videoModel = videos[indexPath.row]
            cell.setVideoModel(videoModel)
            cell.commentItem.msgLable.text = getStringWithNumber(videoModel.comment_count ?? 0)
            cell.favorItem.title = getStringWithNumber(videoModel.recommend_count ?? 0)
            if let userModel = videos[indexPath.item].user {
                let userDefaultHeader = UserModel.share().getUserHeader(userModel.id)
                cell.seriesButton.kfSetHeaderImageWithUrl(userModel.cover_path, placeHolder: userDefaultHeader)
                cell.seriesButton.setTitle("", for: .normal)
                cell.nameLable.text = "@\(userModel.nikename ?? "老湿")"
            }
            /// 第一次进入，播放第currentIndex条
            if indexPath.row == currentIndex && isFirstIn {
                self.configVideo(videoModel, cell: cell, indexPath: indexPath)
            }
        }
        cell.commentItemClick = { [weak self] in
            let commentVC = CommentsMController()
            commentVC.videoId = self?.videos[indexPath.row].id ?? 0
            commentVC.userId = self?.videos[indexPath.row].user?.id ?? 0
            commentVC.modalPresentationStyle = .overCurrentContext
            commentVC.definesPresentationContext = true
            commentVC.view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
            self?.present(commentVC, animated: true, completion: nil)
            commentVC.userClickHandler = { [weak self] user in
                self?.commentgoUserCenter(user)
                commentVC.dismiss(animated: true, completion: nil)
            }
            commentVC.buyVipClickHandler = {
                let verb = InvestController()
                verb.currentIndex = 0
                self?.navigationController?.pushViewController(verb, animated: true)
                commentVC.dismiss(animated: false, completion: nil)
            }
        }
        cell.shareItemClick = { [weak self] in
            let shareText = self?.videos[indexPath.row].title
            let topicTitle = self?.videos[indexPath.row].topic?.topic?.title
            UserModel.share().shareImageLink = self?.videos[indexPath.row].cover_path
            UserModel.share().shareText = self?.getShareText(topicTitle, shareText)
            let shareVc = ShareContentController()
            shareVc.modalPresentationStyle = .overCurrentContext
            shareVc.definesPresentationContext = true
            shareVc.view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
            self?.present(shareVc, animated: false, completion: nil)
        }
        cell.didClickSeriesHandler = { [weak self] in
            guard let strongSelf = self else { return }
            if let user = strongSelf.videos[strongSelf.currentIndex].user {
                self?.goUserCenter(user)
            }
        }
        cell.addFollowHandler = { [weak self]  in
            guard let strongSelf = self else { return }
            let currentModel = strongSelf.videos[strongSelf.currentIndex]
            strongSelf.userInfoViewModel.loadAddFollowApi([UserFollowStatuApi.kUserId: currentModel.user?.id ?? 0, UserFollowStatuApi.kSelfId: UserModel.share().userInfo?.id ?? 0])
        }
        cell.videoFavorItemClick = { [weak self] (isFavor) in
            guard let strongSelf = self else { return  0 }
            strongSelf.userInfoViewModel.addVideoFavor([UserFavorAddApi.kVideo_id: strongSelf.videos[indexPath.row].id ?? 0, UserFavorAddApi.kStatus: isFavor ? 0 : 1, UserFavorAddApi.kAction: UserFavorAddApi.kDefaultAction])
            if let appraiseCount = strongSelf.videos[indexPath.row].recommend_count {
                let favorCount = isFavor ?  appraiseCount - 1 : appraiseCount + 1
                strongSelf.videos[indexPath.row].recommend_count = favorCount
                strongSelf.videos[indexPath.row].recommend = Recommend(rawValue: isFavor ? 0 : 1)
                return favorCount
            }
            return 0
        }
        cell.clickTypeKeyCellHandler = { [weak self] videoKey in
            guard let strongSelf = self else { return }
            let keyMainVc = SeriesKeyMainController()
            keyMainVc.keyMode = videoKey
            strongSelf.navigationController?.pushViewController(keyMainVc, animated: true)
        }
        cell.talksKeyClickHandler = { [weak self] in
            guard let strongSelf = self else { return }
            if let model = strongSelf.videos[indexPath.row].topic?.topic {
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
extension SeriesPlayController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size;
    }
}

// MARK: - play video
extension SeriesPlayController {
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
    
    private func buyVideoRePlay() {
        videos[currentPlayIndex].coins = 0
        let video = videos[currentPlayIndex]
        let indexPath = IndexPath(row: currentPlayIndex, section: 0)
        if let cell = collection.cellForItem(at: indexPath) as? PresentPlayCell {
            /// 对金币视频赋值
            playerView.setCoinsVideoValues(isCoin: (video.is_coins ?? 0) == 1, coinsCount: 0, coinsUser: UserModel.share().wallet?.coins ?? 0, userNickName: video.user?.nikename ?? "")
            // 已购买 解锁进度条
            playerView.timeProgressEnabled(true)
            playWithVideo(video, cell)
        }
    }
    
}

// MARK: - UIScrollViewDelegate
extension SeriesPlayController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let touchPoint = scrollView.panGestureRecognizer.location(in: self.view)
        let tapAreaY = screenHeight - 95 - (UIDevice.current.isXSeriesDevices() ? 34 : 0)
        DLog("tapAreaY === \(tapAreaY) touchPoint.y = \(touchPoint.y)")
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
            
            if translatedPoint.y < -50 && self.currentIndex < (self.videos.count - 1) {
                /// 上滑
                self.currentIndex += 1
            }
            if translatedPoint.y > 50 && self.currentIndex > 0 {
                /// 下滑
                self.currentIndex -= 1
            }
            //            if self.currentIndex == self.viewModelForPlay.sourceCount - 1 && self.viewModelForPlay.getVideoList().count > self.viewModelForPlay.sourceCount {
            //                self.collection.reloadData()
            //                self.viewModelForPlay.sourceCount = self.viewModelForPlay.getVideoList().count
            //            }
            let indexPath = IndexPath(row: self.currentIndex, section: 0)
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                if self.videos.count > indexPath.row {
                    self.collection.scrollToItem(at: indexPath, at: .top, animated: true)
                }
            }, completion: { finished in
                scrollView.panGestureRecognizer.isEnabled = true
                if let cell = self.collection.cellForItem(at: indexPath) as? PresentPlayCell {
                    if self.currentPlayIndex != self.currentIndex { // 上下滑动
                        cell.startLoadingPlayItemAnim(false)
                        self.configVideo(self.videos[indexPath.row], cell: cell, indexPath: indexPath)
                    }
                }
            })
        }
    }
}


// MARK: - NicooPlayerDelegate
extension SeriesPlayController: NicooPlayerDelegate, NicooCustomMuneDelegate {
    
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
            let videoModel = videos[currentPlayIndex]
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
        let model = videos[currentIndex]
        if let isFavor = model.recommend?.isFavor {
            if !isFavor {  // 没有点赞
                let indexPath = IndexPath(row: self.currentIndex, section: 0)
                userInfoViewModel.addVideoFavor([UserFavorAddApi.kVideo_id: model.id ?? 0, UserFavorAddApi.kStatus: 1, UserFavorAddApi.kAction: UserFavorAddApi.kDefaultAction])
                let appraiseCount = videos[indexPath.row].recommend_count ?? 0
                let favorCount = appraiseCount + 1
                videos[indexPath.row].recommend_count = favorCount
                videos[indexPath.row].recommend = Recommend(rawValue: 1)
                if let cell = self.collection.cellForItem(at: indexPath) as? PresentPlayCell {
                    cell.favorItem.title = "\(favorCount)"
                    cell.setFavorStatu(true)
                }
            }
        }
    }
    
}

// MARK: - Layout
private extension SeriesPlayController {
    
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
