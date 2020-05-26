//
//  WorkVideosController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork
import MJRefresh

class WorkVideosController: UIViewController {

    static let videoItemWidth: CGFloat = (ConstValue.kScreenWdith - 34)/3
    static let videoItemHieght: CGFloat = videoItemWidth * 4/3
    static let videoItemSize: CGSize = CGSize(width: videoItemWidth, height: videoItemHieght)
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = videoItemSize
        layout.minimumLineSpacing = 2   // 垂直最小间距
        layout.minimumInteritemSpacing = 0 // 水平最小间距
        layout.sectionInset = UIEdgeInsets(top: 5, left: 15, bottom: 10, right:15)
        return layout
    }()
    lazy var collectionView: CustomcollectionView = {
        let collection = CustomcollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.clear
        collection.register(AcountVideoCell.classForCoder(), forCellWithReuseIdentifier: AcountVideoCell.cellId)
        collection.mj_footer = loadMoreView
        collection.mj_header = refreshView
        return collection
    }()
    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadmore = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.loadNextPage()
        })
        loadmore?.stateLabel.font = ConstValue.kRefreshLableFont
        loadmore?.setTitle("", for: .idle)
        loadmore?.setTitle("已经到底了", for: .noMoreData)
        loadmore?.isHidden = true
        return loadmore!
    }()
    lazy private var refreshView: MJRefreshGifHeader = {
        weak var weakSelf = self
        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
            weakSelf?.isRefreshOperation = true
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
    private lazy var videoApi: UserWorkListApi =  {
        let api = UserWorkListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var deleteApi: UserDeleteWordsApi =  {
        let api = UserDeleteWordsApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    var loaclCell: AcountVideoCell?
    /// 选中index
    var selectIndex:Int = 0
    /// 当前点击的视频的Id
    var currentVideoId: Int = 0
    
    var cateModels = [VideoModel]()
    
    var isRefreshOperation = false
    
    /// 用户id
    var userId: Int?
    
    var isUserCenter: Bool = false
    ///作品数量的回调
    var workVideoTotalHandler: ((_ total: Int)->())?
    ///作品列表
    var workListHandler: ((_ model: UserInfoModel?)->())?
    
    /// 用于解决滑动跟随问题
    var headerHeight: CGFloat = 345.0
    var lastContentOffset: CGFloat = 0
    var scrollDownToTopHandler:((_ canScroll: Bool)->Void)?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(collectionView)
        layoutPageSubviews()
//        /// 这里不要问我，我也不知道为什么  底部 bottom: 要用 safeAreaTopHeight 才对
        let bottomMarginUser: CGFloat = UIDevice.current.isiPhoneXSeriesDevices() ? 118 : 75
        let bottomMargin: CGFloat = UIDevice.current.isiPhoneXSeriesDevices() ? 0 : 0
        collectionView.contentInset = UIEdgeInsets(top: UIDevice.current.isiPhoneXSeriesDevices() ? 30 : 10, left: 0, bottom: isUserCenter ? bottomMarginUser : bottomMargin, right: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(userCenterHeaderAttentionChange), name: Notification.Name.kAttentionVideoUploaderNotification, object: nil)
        headerHeight = isUserCenter ? 345.0 : 260.0
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DLog("uploadTask = \(String(describing: UploadTask.shareTask().tasks))")
    }
   
    @objc func uploadStatuChange(_ notif: Notification) {
        
    }
    
    ///通知
    @objc func userCenterHeaderAttentionChange(no: Notification) {
        let userinfo = no.userInfo
        if let obj = userinfo {
            let isAdd = obj["isAttention"] as? Bool
            if let isAttention = isAdd {
                if cateModels.count > 0 {
                    for video in cateModels {
                        if isAttention {
                            video.user?.followed = FocusVideoUploader.focus
                        } else {
                            video.user?.followed = FocusVideoUploader.notFocus
                        }
                    }
                    collectionView.reloadData()
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.kAttentionVideoUploaderNotification, object: nil)
    }
    
}

// MARK: - Private - Funcs
private extension WorkVideosController {
    
    func loadData() {
        NicooErrorView.removeErrorMeesageFrom(view)
        if !isRefreshOperation {
            XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        }
        let _ = videoApi.loadData()
    }
    func loadFirstPage() {
        let _ = videoApi.loadData()
    }
    func loadNextPage() {
        let _ = videoApi.loadNextPage()
    }
    func endRefreshing() {
        collectionView.mj_footer.endRefreshing()
        collectionView.mj_header.endRefreshing()
    }
    
    /// 检查本地上传任务
    func checkLocalUploadVideoTask() {
        guard let tasks = UploadTask.shareTask().tasks else { return }
        if tasks.count == 0 { return }
        let task = tasks[0]
        let videoUploadModel = VideoModel()
        videoUploadModel.isLocalUpload = true
        videoUploadModel.localUrl = FileManager.videoExportURL
        if task.videoPushStatu == .videoUploadFailed || task.videoPushStatu == .imageUploadFailed || task.videoPushStatu == .commitFailed || task.videoPushStatu == .waitForUpload {
            videoUploadModel.check = CheckStatu.uploadFailed
            cateModels.insert(videoUploadModel, at: 0)
        } else if task.videoPushStatu == .videoUploading || task.videoPushStatu == .imageUploading {
            videoUploadModel.check = CheckStatu.uploading
            cateModels.insert(videoUploadModel, at: 0)
        }
        
        UploadTask.shareTask().tasks![0].videoUploadProgressHandler = { (progress) in
            DLog("here is acount progress = \(progress)")
            self.loaclCell?.setProgress(progress)
        }
        
        UploadTask.shareTask().tasks![0].videoUploadFailedHandler = { (msg) in
             DLog("视频文件上传失败， 点击后从这一步继续？")
            self.loaclCell?.setCoverMsg("上传失败\n请重新上传")
            self.loadData()
        }
        
        UploadTask.shareTask().tasks![0].videoUploadSucceedHandler = {
            DLog("视频上传成功，准备上传图片。。。。")
            self.collectionView.reloadData()
        }
        
        UploadTask.shareTask().tasks![0].imageUploadSucceedHandler = {
            DLog("封面图上传成功， 点击后从这一步继续？")
        }
        
        UploadTask.shareTask().tasks![0].imageUploadFailedHandler = { (msg) in
            DLog("封面图上传失败， 点击后从这一步继续？")
            self.loaclCell?.setCoverMsg("上传失败\n请重新上传")
            self.loadData()
        }
        
        UploadTask.shareTask().tasks![0].commitUploadSucceedHandler = {
             DLog("视频提交成功，删除本地任务，刷新列表。")
             self.loaclCell?.setCoverMsg("上传成功")
             self.removeTasks()
             self.collectionView.mj_header.beginRefreshing()
        }
        UploadTask.shareTask().tasks![0].commitUploadFailedHandler = { (msg) in
            DLog("视频提交失败， 点击重新提交？")
            self.loaclCell?.setCoverMsg("上传失败\n请重新上传")
            self.collectionView.mj_header.beginRefreshing()
            self.loadData()
        }
    }
    
     /// 移除任务，刷新列表
    func removeTasks() {
        guard let _ = UploadTask.shareTask().tasks else { return }
        DLog("removeTasks == removeTasks")
        UploadTask.shareTask().tasks!.removeAll()
        UserDefaults.standard.removeObject(forKey: UserDefaults.kUploadTaskParams)
        UserDefaults.standard.removeObject(forKey: UserDefaults.kUploadTaskImage)
        UserDefaults.standard.set(0, forKey: UserDefaults.kUploadTaskStatu)
    }
    
    func succeedRequest(_ model: VideoListModel) {
        if let models = model.data, let pageNum = model.current_page, let total = model.total {
            DLog("====\(total)=======")
            UserDefaults.standard.set(total, forKey: "workVideoCount")
            if pageNum == 1 {
                cateModels = models
                if userId == UserModel.share().userInfo?.id {  // 表示是自己
                    checkLocalUploadVideoTask() /// 检查本地是否有正在上传的视频
                }
                if cateModels.count == 0 {
                    NicooErrorView.showErrorMessage(.noData, isUserCenter ? "你还没有作品\n快去发布吧": "这家伙很懒\n还没有发布作品", on: view) {
                        self.loadData()
                    }

                } else {
                    workListHandler?(cateModels[0].user)
                }
            } else {
                cateModels.append(contentsOf: models)
            }
            workVideoTotalHandler?(model.total ?? 0)
            loadMoreView.isHidden = models.count < UserWorkListApi.kDefaultCount
        }
        endRefreshing()
        collectionView.reloadData()
    }
    
    func failedRequest(_ manager: NicooBaseAPIManager) {
        endRefreshing()
        NicooErrorView.showErrorMessage(.noNetwork, on: view) {
            self.loadData()
        }
    }
    
    /// 上传失败操作提示
    func alertForUpload(_ msg: String, step: Int) {
        guard let tasks = UploadTask.shareTask().tasks, tasks.count > 0 else { return }
        let alertContro = UIAlertController.init(title: nil, message: msg, preferredStyle: .alert)
        var okTitle = "重新上传"
        if step == 0 {
            okTitle = "立即上传"
        }
        let okAction = UIAlertAction(title: okTitle, style: .default) { (action) in
            self.goPushWaitTask()
//            if step == 1 || step == 0 { // 视频文件上传失败, 或者第一次上传
//               // 直接上传 调用 : tasks[0].uploadVideo()
//               // 这里是重新到发布页面
//               self.goPushWaitTask()
//            } else if step == 2 { // 图片上传失败
//                tasks[0].uploadVideoCover()
//                self.collectionView.reloadData()
//            } else if step == 3 { // 提交失败
//                tasks[0].commitForPush()
//            }
        }
        let cancleAction = UIAlertAction(title: "删除", style: .cancel) { (action) in
            // 这里删除要做： 1。判断是本地任务， 删除本地持久化对应数据
            self.removeTasks()
            self.collectionView.mj_header.beginRefreshing()
        }
        alertContro.addAction(okAction)
        alertContro.addAction(cancleAction)
        alertContro.modalPresentationStyle = .fullScreen
        self.present(alertContro, animated: true, completion: nil)
    }
    
    /// 删除已经上传的视频
    func alertForAlreadyUploadVideo(_ msg: String, _ title: String? = nil, _ isSelf: Bool) {
        let alertContro = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        if isSelf {
           let  okAction = UIAlertAction(title: "删除", style: .default) { (action) in
                // 调用删除接口
                let _ = self.deleteApi.loadData()
            }
            alertContro.addAction(okAction)
        } else {
            let sureAction = UIAlertAction(title: "确认", style: .default, handler: nil)
            alertContro.addAction(sureAction)
        }
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
        }
        alertContro.addAction(cancleAction)
        alertContro.modalPresentationStyle = .fullScreen
        self.present(alertContro, animated: true, completion: nil)
    }
    
    func goPushWaitTask() {
        let pushVc = PushVideoController()
        pushVc.isUploadFormLastTimeSave = true
        getAcountVC()?.navigationController?.pushViewController(pushVc, animated: true)
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension WorkVideosController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cateModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellForRow(with: indexPath)
        return cell
    }
    
    /// 配置cell
    func cellForRow(with indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AcountVideoCell.cellId, for: indexPath) as! AcountVideoCell
        let model = cateModels[indexPath.row]
        ///是自己的
        if userId == UserModel.share().userInfo?.id {
            if model.isLocalUpload ?? false { //本地正在上传的，或者失败的
                if let tasks = UploadTask.shareTask().tasks, tasks.count > 0 {
                    cell.coverPath.image = tasks[0].pushModel.videoCover ?? ConstValue.kVerticalPHImage
                    cell.progressCover.isHidden = false
                    loaclCell = cell
                    cell.statuImage.isHidden = true
                    cell.deleButton.isHidden = true
                    cell.setVideoWordsSuccess(false)
                    cell.showCoinTips(false)
                    if tasks[0].videoPushStatu == .videoUploading {
                        cell.setProgress(tasks[0].videoProgress)
                    } else if tasks[0].videoPushStatu == .videoUploadFailed || tasks[0].videoPushStatu == .imageUploadFailed || tasks[0].videoPushStatu == .commitFailed {
                        cell.setCoverMsg("上传失败\n请重新上传")
                    } else if tasks[0].videoPushStatu == .imageUploading {
                        cell.setCoverMsg("上传封面中...")
                    } else if tasks[0].videoPushStatu == .waitForUpload { // 点击一下
                        cell.setCoverMsg("视频待上传...")
                    }
                }
            } else {
                let checkStatu = model.check ?? CheckStatu.passCheck
                cell.progressCover.isHidden = true
                if checkStatu == .waitForCheck {
                    cell.setVideoWordsSuccess(false)
                    cell.showCoinTips(false)
                    // cell.progressCover.isHidden = false
                    cell.statuImage.isHidden = false
                    cell.deleButton.isHidden = true
                    cell.statuImage.image = UIImage(named: "shenhezhong")
                    cell.setCoverMsg("等待审核...")
                } else if checkStatu == .passCheck {
                    cell.statuImage.isHidden = true
                    cell.deleButton.isHidden = false
                    cell.setVideoWordsSuccess(true)
                    cell.showCoinTips(model.is_coins == 1)
                    if let coins = model.coins, coins > 0 {
                        cell.coinLable.text = "\(model.coins ?? 0)金币"
                    } else {
                        cell.coinLable.isHidden = true
                    }
                    cell.setCoverMsg("")
                } else if checkStatu == .notPassCheck {
                    cell.setVideoWordsSuccess(false)
                    cell.showCoinTips(false)
                    // cell.progressCover.isHidden = true
                    cell.statuImage.isHidden = false
                    cell.deleButton.isHidden = true
                    cell.statuImage.image = UIImage(named: "noPassWork")
                    cell.setCoverMsg("审核未通过")
                }
                cell.deleteActionHandler = { [weak self] in
                    if checkStatu == .passCheck {
                        self?.currentVideoId = model.id ?? 0
                        self?.alertForAlreadyUploadVideo("是否删除该视频？", nil, true)
                    }
                }
                if userId != UserModel.share().userInfo?.id {
                    cell.deleButton.isHidden = true
                }
                cell.collectionBtn.setTitle(" \(getStringWithNumber(model.recommend_count ?? 0))", for: .normal)
                cell.coverPath.kfSetVerticalImageWithUrl(model.cover_path)
            }
        } else {  ///是别人
            let checkStatu = model.check ?? CheckStatu.passCheck
            cell.progressCover.isHidden = true
            if checkStatu == .passCheck {
                cell.statuImage.isHidden = true
                cell.deleButton.isHidden = true
                cell.setVideoWordsSuccess(true)
                cell.setCoverMsg("")
            }
            cell.showCoinTips(model.is_coins == 1)
            cell.coinLable.text = "\(model.coins ?? 0)金币"
            cell.collectionBtn.setTitle(" \(getStringWithNumber(model.recommend_count ?? 0))", for: .normal)
            cell.coverPath.kfSetVerticalImageWithUrl(model.cover_path)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = cateModels[indexPath.row]
        if userId == UserModel.share().userInfo?.id { ///是自己的
            if model.isLocalUpload ?? false {
                let checkStatu = model.check ?? .uploading
                if checkStatu == .uploadFailed {
                    // 弹一个框， 提示删除或者重新上传， 这里重新上传，需要获取到， 当前任务的失败点： （1.视频上传失败，2. t视频成功，封面失败。 3。视频，封面都成功，提交失败。 ） 从失败的位置 开始
                    guard let tasks = UploadTask.shareTask().tasks, tasks.count > 0 else { return }
                    if tasks[0].videoPushStatu == .videoUploadFailed {
                        alertForUpload("上传失败，请重新上传!", step: 1)
                    } else if tasks[0].videoPushStatu == .imageUploadFailed {
                        alertForUpload("上传失败，请重新上传!", step: 2)
                    } else if tasks[0].videoPushStatu == .commitFailed {
                        alertForUpload("上传失败，请重新上传!", step: 3)
                    } else if tasks[0].videoPushStatu == .waitForUpload {
                        alertForUpload("视频待上传，是否立即上传？", step: 0)
                    }
                }
            } else {
                let checkStatu = model.check ?? .uploading
                if checkStatu == .passCheck {
                    let controller = AcountVideoPlayController()
                    controller.canGoNext = false
                    controller.videos = cateModels
                    controller.playWorks = true
                    controller.currentIndex = indexPath.item
                    controller.goVerbOrRefreshActionHandler = { [weak self] (isVerb) in
                        if isVerb {
                            let vipvc = InvestController()
                            vipvc.currentIndex = 0
                            self?.navigationController?.pushViewController(vipvc, animated: false)
                        } else {
                            self?.collectionView.mj_header.beginRefreshing()
                        }
                    }
                    let nav = QHNavigationController(rootViewController: controller)
                    nav.modalPresentationStyle = .fullScreen
                    if let vc = getAcountVC() {
                        vc.present(nav, animated: false, completion: nil)
                    } else {
                        getUserCenterVC()?.present(nav, animated: false, completion: nil)
                    }
                } else if checkStatu == .waitForCheck {
                    currentVideoId = model.id ?? 0
                    self.alertForAlreadyUploadVideo("审核通过后可查看，是否删除？", "审核中...", true)
                } else if checkStatu == .notPassCheck {
                    currentVideoId = model.id ?? 0
                    self.alertForAlreadyUploadVideo("视频审核未通过，是否删除？", "审核未通过", true)
                }
            }
        } else { ///是别人的
            let checkStatu = model.check ?? .uploading
            if checkStatu == .passCheck {
                let controller = AcountVideoPlayController()
                controller.canGoNext = false
                ///将当前的播放的视频角标传进去
                controller.currentIndex = indexPath.item
                controller.videos = cateModels
                controller.playWorks = userId == UserModel.share().userInfo?.id
                controller.goVerbOrRefreshActionHandler = { [weak self] (isVerb) in
                    if isVerb {
                        let vipvc = InvestController()
                        vipvc.currentIndex = 0
                        self?.navigationController?.pushViewController(vipvc, animated: false)
                    } else {
                        self?.collectionView.mj_header.beginRefreshing()
                    }
                }
                let nav = QHNavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                getUserCenterVC()?.present(nav, animated: false, completion: nil)
            }
        }
    }
    func getUserCenterVC() -> UserMCenterController? {
        var next = view.superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is UserMCenterController) {
                return nextResponder as? UserMCenterController
            }
            next = next?.superview
        }
        return nil
    }
    func getAcountVC() -> AcountNewController? {
        var next = view.superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is AcountNewController) {
                return nextResponder as? AcountNewController
            }
            next = next?.superview
        }
        return nil
    }
}

// MARK: - UIScrollViewDelegate
extension WorkVideosController: UIScrollViewDelegate {
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
           // DLog("下拉行为 == \(offsetY)")
            if offsetY <= 0 {
                scrollDownToTopHandler?(true)
            }
        }
    }
}

// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension WorkVideosController: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        if manager is UserDeleteWordsApi {
            return [UserDeleteWordsApi.kVideo_id : currentVideoId]
        }
        if manager is UserWorkListApi {
            if userId == UserModel.share().userInfo?.id {  ///如果是自己
                if let uid = userId {
                    return [UserWorkListApi.kUserId : uid]
                }
            } else {
                if userId != nil {
                    return [UserWorkListApi.kUserId : userId!]
                }
            }
        }
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if let videoList = manager.fetchJSONData(VideoReformer()) as? VideoListModel {
            if manager is UserWorkListApi {
                succeedRequest(videoList)
            }
        } else if manager is UserDeleteWordsApi {
            XSAlert.show(type: .success, text: "删除成功!")
            self.loadData()
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserWorkListApi {
            failedRequest(manager)
        } else if manager is UserDeleteWordsApi {
            XSAlert.show(type: .error, text: "删除失败，请重试")
        }
    }
}


// MARK: - Layout
private extension WorkVideosController {
    
    func layoutPageSubviews() {
        layoutCollection()
    }
    
    func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            if #available(iOS 11.0, *) {
                if isUserCenter {
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                } else {
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-44)
                }
            } else {
                if isUserCenter {
                    make.bottom.equalToSuperview()
                } else {
                    make.bottom.equalToSuperview().offset(-44)
                }
            }
        }
    }
}
