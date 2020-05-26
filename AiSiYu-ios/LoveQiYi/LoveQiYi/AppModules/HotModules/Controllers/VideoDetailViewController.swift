//
//  HotVideoDetailViewController.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/22.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

class VideoDetailViewController: BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private lazy var headerView: HotDetailHeaderView = {
       let headerView = HotDetailHeaderView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth * 9/16))
        headerView.chargeActionHandler = { [ weak self] in
            self?.goCharge()
        }
        return headerView
    }()
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "navBackWhite"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        button.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()
    private lazy var headerTipView: HeaderTipsView = {
        let tipView = HeaderTipsView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 60))
        return tipView
    }()
    private lazy var footerView: HotDetailFooterView = {
        guard let footerView = Bundle.main.loadNibNamed("HotDetailFooterView", owner: nil, options: nil)?[0] as? HotDetailFooterView else { return HotDetailFooterView() }
      
        footerView.didClickDownLoaderHandeler = { [weak self] in
            self?.loadDownloadAuth()
        }
        footerView.didClickLikeHandler = { [weak self] in
            if self?.model.is_collect?.boolValue ?? false {
                self?.cancleCollecteVideo()
            } else {
                self?.collectedVideo()
            }
        }
        footerView.didClickShareHandler = { [weak self] in
            self?.share()
        }
        
        return footerView
    }()
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
       let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
       collection.dataSource = self
       collection.delegate = self
       collection.allowsSelection = true
       collection.backgroundColor = .white
       collection.register(VideoDetailBigCollectionCell.classForCoder(), forCellWithReuseIdentifier: VideoDetailBigCollectionCell.cellId)
       collection.register(SeriesDetailItemCell.classForCoder(), forCellWithReuseIdentifier: SeriesDetailItemCell.cellId)
       collection.register(VideoDetailSectionHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: VideoDetailSectionHeader.cellId)
       return collection
    }()
    private lazy var playerView: NicooPlayerView = {
        let player = NicooPlayerView(frame: self.headerView.bounds, bothSidesTimelable: true)
        //player.videoLayerGravity = .sca
        player.videoNameShowOnlyFullScreen = true
        player.delegate = self
        return player
    }()
    private lazy var allPlayContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    ///接收从其他控制器中传过来的播放model
    var model: VideoModel = VideoModel()
//    var adModel: VideoDetailAdModel = VideoDetailAdModel()
    var adListModel: [VideoDetailAdModel] = [VideoDetailAdModel]()
    var rooterList = [RouterModel]()
    /// 当前线路
    var currentChannel: RouterModel?
    
    var viewModel: HotVideoViewModel = HotVideoViewModel()
    
    var currentPage: Int = 0
    
    var dataSource: [VideoModel] = [VideoModel]()
        
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(backButton)
        view.addSubview(headerTipView)
        view.addSubview(footerView)
        view.addSubview(collectionView)
        layoutPageView()
        
        /// 进入App后屏幕保持常亮
        UIApplication.shared.isIdleTimerDisabled = true
        
        viewModelCallBack()
        /// 获取视频详情
        loadInfoData(model: self.model)
        /// 获取广告
        loadAdData()
        /// 活动广告
        loadVipADInfo()
        /// 获取线路列表的数据
        loadRouterList()
        
        setVideoInfo()
       

        /// 广告活动跳转
        headerTipView.adClickHandler = { [weak self] in
            if let url = self?.viewModel.vipAdModel?.url{
                if url.hasPrefix("http") {
                    self?.goWebVC(url)
                } else {
                    self?.goCharge()
                }
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // 如果当前播放器已经添加，支持横竖屏
        if headerView.videoPlayView.subviews.count > 0 {
            orientationSupport = NicooPlayerOrietation.orientationAll
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        /// 离开视频播放页面，只支持竖屏
        playerView.playerStatu = PlayerStatus.Pause
        orientationSupport = NicooPlayerOrietation.orientationPortrait
        /// 进入App后屏幕保持常亮
        UIApplication.shared.isIdleTimerDisabled = false
        
    }
    
    func endRefreshing() {
        refreshView.endRefreshing()
        loadMoreView.endRefreshing()
    }
    
    func setVideoInfo() {
        headerView.videoPlayView.kfSetHorizontalImageWithUrl(model.cover_url)
        footerView.likeBtn.isSelected = model.is_collect?.boolValue ?? false
    }
    
    private func playVideo() {
        headerView.authErrorView.isHidden = true
        if let auth_error = model.auth_error {
            if auth_error.key == 2 {         /// 预看10秒
                if let url = URL(string: model.play_url_m3u8 ?? "")  {
                    playerView.playVideo(url, model.title ?? "" , headerView.videoPlayView)
                }
            } else {  /// 不可观看， 显示
                headerView.authErrorView.isHidden = false
                headerView.authErrorLabel.text = auth_error.info ?? ""
            }
        } else { /// 鉴权通过，直接播放 //URL(string: "http://yun.kubo-zy-youku.com/20181112/BULbB7PC/index.m3u8")
            if let url = URL(string: model.play_url_m3u8 ?? ""){
                if (model.view_time ?? 0) > 0 {
                    playerView.replayVideo(url, model.title ?? "", headerView.videoPlayView, Float(model.view_time ?? 0))
                } else {
                    playerView.playVideo(url, model.title ?? "" , headerView.videoPlayView)
                }
            }
        }
    }
    
    ///猜你喜欢
    func loadGuessData(model: VideoModel) {
        if let videoId = model.id {
            viewModel.loadGuessList(video_id: videoId)
        }
    }
    
    ///点击cell刷新
    func refreshAndPushGuessData(model: VideoModel) {
        if self.model.id != model.id  {
            XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
            if let videoId = model.id {
                viewModel.loadVideoInfo(video_id: videoId)
            }
        }
    }
    
    private func goCharge() {
        let vip = VipCardController()
        navigationController?.pushViewController(vip, animated: true)
    }
    
    private func goWebVC(_ url: String) {
        if let URL = URL(string: url) {
            let webkit = WebKitController.init(url: URL, true)
            navigationController?.pushViewController(webkit, animated: true)
        }
        
    }
    
    @objc func back() {
        if headerView.videoPlayView.subviews.count == 0 { // 播放器未添加
            goBack()
            return
        }
        if model.auth_error != nil { /// 播放视频权限错误存在
            goBack()
            return
        }
        /// 时间记录回调
        viewModel.watchTimeRecordCallBack = { [weak self] in
            self?.goBack()
        }
        saveWatchRecordTime()
    }

    private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: -网络请求
extension VideoDetailViewController {
    
    ///获取线路列表
    func loadRouterList() {
        viewModel.loadRouterList()
    }
    
    /// 收藏
    func collectedVideo() {
        viewModel.loadVideoFavorAdd()
    }
    
    /// 取消收藏
    func cancleCollecteVideo() {
        viewModel.loadCancleFavor()
    }
    
    ///保存线路
    func saveRouter(model: RouterModel) {
        if let key =  model.key {
            currentChannel = model
            viewModel.loadRouterSave(key: key)
        }
    }
    
    /// 保存播放时间
    func saveWatchRecordTime() {
        let times = playerView.getNowPlayPositionTimeAndVideoDuration()
        let params: [String: Any] = [VideoViewTimeApi.kVideo_id: model.id ?? 0, VideoViewTimeApi.kTime: Int(times[0])]
        viewModel.loadTimeWatchedRecord(params)
    }
    
    /// 广告活动配置
    func loadVipADInfo() {
        viewModel.loadVipAdInfoData()
    }
    
    ///获取视频详情广告
    func loadAdData() {
        viewModel.loadVideoDetailAd()
    }
    
    ///视频详情
    func loadInfoData(model: VideoModel) {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        if let videoId = model.id {
            viewModel.loadVideoInfo(video_id: videoId)
        }
    }
    
    /// 下载鉴权
    func loadDownloadAuth() {
        viewModel.loadDownLoadAuth()
    }

    /// 线路列表
    func showActionSheet() {
        if rooterList.count == 0 { return }
        let alertController = UIAlertController(title: "切换线路", message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = UIColor.darkText
        for model in rooterList {
            let LineAction = UIAlertAction(title: model.title, style: UIAlertAction.Style.default, handler: { ( action ) in
                ///发送保存线路的网络请求
                self.saveRouter(model: model)
            })
            alertController.addAction(LineAction)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            
        })
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// viewmodel 回调
    func viewModelCallBack() {
        /// 视频详情
        viewModel.videoInfoSuccessHandler = { [weak self] infoModel in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
            strongSelf.model = infoModel
            strongSelf.collectionView.reloadData()
            strongSelf.setVideoInfo()
            strongSelf.playVideo()
            strongSelf.loadGuessData(model: infoModel)
        }
        
        viewModel.videoInfoFailureHandler = { errorMsg in
            XSAlert.show(type: .error, text: errorMsg)
        }
        
        ///猜你喜欢
        viewModel.guessLikeSuccessHandler = { [weak self] (models, pageNumber) in
            guard  let strongSelf = self else { return }
            if let dataList = models.data {
                strongSelf.dataSource = dataList
                strongSelf.collectionView.reloadSections([1])
            }
        }
        /// 视频详情广告
        viewModel.videoDetailAdSuccessHandler = { [weak self] adListModel in
            guard let strongSelf = self else { return }
            strongSelf.adListModel = adListModel
            strongSelf.collectionView.reloadItems(at: [IndexPath.init(row: 0, section: 0)])
        }

        /// 线路保存
        viewModel.routerSaveSuccessHandler = { [weak self]  in
            guard let strongSelf = self else { return }
            UserModel.share().userInfo?.channel = strongSelf.currentChannel
            strongSelf.collectionView.reloadSections([0])
            strongSelf.loadInfoData(model: strongSelf.model)
        }
        viewModel.routerListFailureHandler = { errorMsg in
            XSAlert.show(type: .error, text: errorMsg)
        }
        
        /// 线路列表
        viewModel.routerListSuccessHandler = { [weak self] routerList in
            guard let strongSelf = self else { return }
            strongSelf.rooterList = routerList
            strongSelf.collectionView.reloadSections([0])
        }
        viewModel.routerListFailureHandler = { errorMsg in
            XSAlert.show(type: .error, text: errorMsg)
        }
        
        /// 视频收藏
        viewModel.addFavorSuccessHandler = { [weak self] in
            XSAlert.show(type: .success, text: "收藏成功")
            self?.footerView.likeBtn.isSelected = true
            self?.model.is_collect = .collected
        }
        viewModel.addFavorFailedHandler = { msg in
            XSAlert.show(type: .error, text: msg)
        }
        
        /// 取消收藏
        viewModel.cancelFavorSuccessHandler = { [weak self] in
            XSAlert.show(type: .success, text: "取消收藏成功")
            self?.footerView.likeBtn.isSelected = false
            self?.model.is_collect = .unCollected
        }
        viewModel.cancelFavorFailedHandler = { msg in
             XSAlert.show(type: .error, text: msg)
        }
        
        /// 广告配置
        viewModel.vipAdInfoSuccessHandler = { [weak self] in
            self?.headerTipView.tipLabel.text = self?.viewModel.vipAdModel?.title ?? "新客专项！VIP月卡首月仅6元"
        }
        viewModel.vipAdInfoFailedHandler = { [weak self] (msg) in
            self?.headerTipView.tipLabel.text = "新客专项！VIP月卡首月仅6元"
        }
        
        /// 下载鉴权
        viewModel.downloadAuthSuccessCallBack = { [weak self] in
            self?.downloadVideo()
        }
        viewModel.downloadAuthFailedCallBack = { [weak self] (msg) in
            self?.showDialog(title: nil, message: msg, okTitle: "成为VIP", cancelTitle: "取消", okHandler: {
                self?.goCharge()
            }, cancelHandler: nil)
        }
    }
}

// MARK: - Download
extension VideoDetailViewController {
    
    func downloadVideo() {
        if model.auth_error != nil {
            return
        }
        if DownLoadMannager.share().yagorsDownloading.count >= 3 {
            XSAlert.show(type: .warning, text: "最多允许同时下载3个任务。")
            return
        }
        let videoModelStr = encodeVideoModel()
        let vDirectoryName = String(format: "%d%@", model.id ?? 0, model.play_url_m3u8 ?? "").md5()
        /// 排重处理
        var isHaveCurrenYagor = false
        for yagor in DownLoadMannager.share().yagors {
            if yagor.directoryName == vDirectoryName {
                isHaveCurrenYagor = true
            }
        }
        if !isHaveCurrenYagor {
            let model = VideoDownLoad(videoDirectory: vDirectoryName, videoDownLoadUrl: self.model.play_url_m3u8, videoModelString: videoModelStr)
            DownLoadMannager.share().downloadViedoWith(model)
            alertForDownload("已添加到下载列表")
        } else {
            alertForDownload("下载文件已存在")
        }
    }
    
    func encodeVideoModel() -> String? {
        let encoder = JSONEncoder()
        if let resultData = try? encoder.encode(model) {
            let videoString = String(data: resultData, encoding: .utf8)
            return videoString
        }
        return nil
    }
    func alertForDownload(_ msg: String) {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.view.tintColor = UIColor.darkGray
        let action =  UIAlertAction.init(title: "立即查看", style: .destructive) { (alert) in
            self.goDownLoadTaskVc()
        }
        let action1 = UIAlertAction.init(title: "知道了", style: .default, handler: nil)
        alert.addAction(action)
        alert.addAction(action1)
        present(alert, animated: true, completion: nil)
    }
    
    func goDownLoadTaskVc() {
        let downloadVC = DownloadTasksController()
        navigationController?.pushViewController(downloadVC, animated: true)
    }
    
    private func bannerClick(_ model: VideoDetailAdModel) {
        if model.type ?? .banner_video == .banner_link {
            goWeb(model.redirect_url)
        } else if model.type ?? .banner_video == .banner_video {
            var videModel = VideoModel()
            videModel.id = model.video_id
            let videoDetail = VideoDetailViewController()
            videoDetail.model = videModel
            navigationController?.pushViewController(videoDetail, animated: true)
        } else if model.type ?? .banner_video == .banner_ad {
            goWeb(model.redirect_url)
        } else if model.type ??  .banner_video == .banner_internalLink {
            if let redirect_position = model.redirect_position {
                if redirect_position == .MEMBER_CENTER {
                    ///跳转到会员中心
                    let vip = VipCardController()
                    navigationController?.pushViewController(vip, animated: true)
                } else if redirect_position == .TASK_INTERFACE {
                    ///跳转到任务
                    if let delegate =  UIApplication.shared.delegate as? AppDelegate {
                        if let tabBarVC = delegate.window?.rootViewController as? RootTabBarViewController {
                            tabBarVC.selectedIndex  = 3
                        }
                    }
                }  else if redirect_position == .LU_FRIENDLY {
                    ///跳转到撸友交流
                    if let redirect_url = model.redirect_url {
                        UIApplication.shared.openURL(URL.init(string: redirect_url)!)
                    }
                }
            }
        }
    }
    
    private func goWeb(_ urlStr: String?) {
        let webvc = WebKitController(url: URL(string: urlStr ?? "")!)
        self.navigationController?.pushViewController(webvc, animated: true)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension VideoDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.dataSource.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoDetailBigCollectionCell.cellId, for: indexPath) as! VideoDetailBigCollectionCell
            cell.setVideoIndoModel(model)
            if adListModel.count > 0 {
                DLog("广告大图Cell赋值===================")
                cell.setAdModel(adListModel[indexPath.row])
                cell.scrollItemClickHandler = {[weak self] index in
                    guard let strongSelf = self else {return}
                    self?.bannerClick(strongSelf.adListModel[index])
                }
            }
            if let channel = UserModel.share().userInfo?.channel {
                cell.setModel(channel)
            }
            cell.changeRouterHandler = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.showActionSheet()
            }
            var imagenames = [String]()
            for i in adListModel.enumerated() {
                imagenames.append(i.element.cover_oss_path ?? "" )
            }
            cell.setImages(images: imagenames)
            cell.scrollItemClickHandler = { [weak self] (index) in
                guard let strongSelf = self else {return}
                DLog("---------------------------------------------------------------")
                strongSelf.bannerClick(strongSelf.adListModel[index])
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeriesDetailItemCell.cellId, for: indexPath) as! SeriesDetailItemCell
            cell.setModel(self.dataSource[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 1 {
            /// 切换视频，记录上一个视频的观看时长
            saveWatchRecordTime()
            ///发送视频详情接口
            let model = self.dataSource[indexPath.item]
            self.refreshAndPushGuessData(model: model)
        } else if indexPath.section == 0 {
            
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension VideoDetailViewController: UICollectionViewDelegateFlowLayout {
    /// itemSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return VideoDetailBigCollectionCell.itemSize
        } else {
            return SeriesDetailItemCell.itemSize
        }
    }
    
    ///边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    /// sectionHeader高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: screenWidth, height: 40)
        }
        return CGSize.zero
    }
    
    /// 组头组尾
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reuseableView: UICollectionReusableView?
        if kind == UICollectionView.elementKindSectionHeader {
            let hotHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: VideoDetailSectionHeader.cellId, for: indexPath) as! VideoDetailSectionHeader
            reuseableView = hotHeaderView
        }
        return reuseableView!
    }
}

// MARK: - NicooPlayerDelegate
extension VideoDetailViewController: NicooPlayerDelegate, NicooCustomMuneDelegate {
    
   
    func retryToPlayVideo(_ player: NicooPlayerView, _ videoModel: NicooVideoModel?, _ fatherView: UIView?) {
        print("网络不可用时调用")
        let url = URL(string: videoModel?.videoUrl ?? "")
        if  let sinceTime = videoModel?.videoPlaySinceTime, sinceTime > 0 {
            player.replayVideo(url, videoModel?.videoName, fatherView, sinceTime)
        }else {
            player.playVideo(url, videoModel?.videoName, fatherView)
        }
    }
    
    func currentVideoPlayToEnd(_ videoModel: NicooVideoModel?, _ isPlayingDownLoadFile: Bool) -> NicooAuth_error? {
        if let authError = model.auth_error  {
            let nicooAuth = NicooAuth_error.init(key: authError.key, info: authError.info)
            return nicooAuth
        } else {
            let params: [String: Any] = [VideoViewTimeApi.kVideo_id: model.id ?? 0, VideoViewTimeApi.kTime: 0]
            viewModel.loadTimeWatchedRecord(params)
            return nil
        }
    }
    
    func authErrorActionClick(chargeHandler: (Bool) -> Void) {
        // 跳充值
        let vip = VipCardController()
        navigationController?.pushViewController(vip, animated: true)
    }
    
    func scaleScreenAction(_ isFullScreen: Bool) -> Bool {
        let isPortrait = model.is_long?.boolValue ?? false
        if isPortrait {
            if !isFullScreen {
                self.view.addSubview(allPlayContentView)
                allPlayContentView.snp.makeConstraints { (make) in
                    make.leading.trailing.top.equalToSuperview()
                    if #available(iOS 11.0, *) {
                        make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                    } else {
                        make.bottom.equalToSuperview()
                    }
                }
                playerView.changeVideoContainerView(allPlayContentView)
            } else {
                playerView.changeVideoContainerView(headerView.videoPlayView)
                allPlayContentView.removeFromSuperview()
            }
           return true
        }
        return false
    }
}

// MARK: - Layout
extension VideoDetailViewController {
    
    private func layoutPageView() {
        layoutHeaderView()
        layoutBackButton()
        layoutTipaView()
        layoutFooterView()
        layoutCollectionView()
    }
    
    private func layoutBackButton() {
        backButton.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalTo(statusBarHeight + 6)
            make.width.height.equalTo(30)
        }
    }
    private func layoutHeaderView() {
        headerView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(screenWidth*9/16 + statusBarHeight)
        }
    }
    private func layoutTipaView() {
        headerTipView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(60)
        }
    }
    
    private func layoutCollectionView() {
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(headerTipView.snp.bottom)
            make.bottom.equalTo(footerView.snp.top)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
    }
    
    private func layoutFooterView() {
        footerView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
    }
}
