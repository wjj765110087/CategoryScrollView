//
//  PushVideoController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/26.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import AVKit
import Photos
import NicooNetwork

/// 视频上传确认页面
class PushVideoController: UIViewController {
    
    static let videoItemWidth: CGFloat = (ConstValue.kScreenWdith - 80)/4
    static let videoItemHieght: CGFloat = 35
    static let videoItemSize: CGSize = CGSize(width: videoItemWidth, height: videoItemHieght)
    
    static let kLocalTaskTitles = "localTaskTitles"
    static let kLocalTaskTalkTitle = "kLocalTaskTalkTitle"

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "发布视频"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.lineView.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.init(white: 0.9, alpha: 1.0)
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.backgroundColor = UIColor.clear
        textView.delegate = self
        return textView
    }()
    let placeHodlerLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor(r: 59, g: 57, b: 73)
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.numberOfLines = 2
        lable.text = "@抖阴 随时随地，分享你的性福生活"
        return lable
    }()
    let talksItem: CateChoseItemView = {
        let item = CateChoseItemView(frame: CGRect.zero)
        item.lineBottom.isHidden = true
        item.titleLable.text = "添加话题"
        item.tipsLable.text = "参与话题,让更多人看到"
        item.iconImage.image = UIImage(named: "talksPushIcon")
        return item
    }()
    let priceItem: CateChoseItemView = {
        let item = CateChoseItemView(frame: CGRect.zero)
        item.lineBottom.isHidden = true
        item.titleLable.text = "设置观看金币"
        item.tipsLable.text = "不设置将视为免费"
        item.iconImage.image = UIImage(named: "priceVideoIcon")
        return item
    }()
    let catesTipsItem: CateChoseItemView = {
        let item = CateChoseItemView(frame: CGRect.zero)
        item.iconImage.image = UIImage(named: "PushTipsIcon")
        item.titleLable.text = "选择分类"
        item.tipsLable.text = "准确的分类,吸引更多粉丝"
        return item
    }()
    lazy var videoBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(videoImage, for: .normal)
        button.setImage(UIImage(named: "CommunityPlayIcon"), for: .normal)
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(videoWatch), for: .touchUpInside)
        return button
    }()
    let progressCover: UILabel = {
        let label = UILabel()
        label.textColor = ConstValue.kTitleYelloColor
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    let licenseItem: PushVideoLicenceView = {
        let item = PushVideoLicenceView(frame: CGRect.zero)
        return item
    }()
    lazy var saveBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("保存本地", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 56/255.0, green: 59/255.0, blue: 71/255.0, alpha: 0.99)
        button.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    lazy var commitBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("发 布", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = ConstValue.kTitleYelloColor
        button.addTarget(self, action: #selector(commitPushVideo(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10 ,left: 10, bottom: 10, right: 10)
        return layout
    }()
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.clear
        collection.isScrollEnabled = false
        collection.register(PushKeysCell.classForCoder(), forCellWithReuseIdentifier: PushKeysCell.cellId)
        return collection
    }()
    private lazy var uploadCountApi: UserUploadCountApi = {
        let api = UserUploadCountApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    
    var pushTask = PushPresenter()
    var talkModel: TalksModel?
    var coinsPrice: Int = 0
    
    var videoImage: UIImage?
    var videoDuration: Int = 0
    var tagModels = [CateTagModel]()
    /// 是否是上传上次保存的视频
    var isUploadFormLastTimeSave = false
    var isChangeparams = false
    
    deinit {
        DLog("PushVideoController -- release")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        setUpUI()
        addItemsCallBack()
        
        if isUploadFormLastTimeSave {
            loadLoaclData()
        }
        addUploadPresenterCallBack()
    }
    
    private func setUpUI() {
        view.addSubview(navBar)
        view.addSubview(videoBtn)
        view.addSubview(progressCover)
        view.addSubview(textView)
        view.addSubview(placeHodlerLable)
        view.addSubview(talksItem)
        view.addSubview(priceItem)
        view.addSubview(catesTipsItem)
        view.addSubview(collectionView)
        view.addSubview(licenseItem)
        view.addSubview(saveBtn)
        view.addSubview(commitBtn)
        layoutPageSubviews()
        
        /// 检查发布主页是否 已 填写过发布内容
        if UploadTask.shareTask().content != nil && !UploadTask.shareTask().content!.isEmpty {
            textView.text = UploadTask.shareTask().content
            placeHodlerLable.text = ""
        }
        /// 检查发布主页是否 已 添加过话题
        talkModel = UploadTask.shareTask().talksModel
        if let titles = self.talkModel?.title, titles.count > 0 {
            self.talksItem.tipsLable.text = "\(titles)"
            self.talksItem.tipsLable.textColor = UIColor.white
        } else {
            self.talksItem.tipsLable.text = "参与话题,让更多人看到"
            self.talksItem.tipsLable.textColor = UIColor(r: 59, g: 57, b: 73)
        }
    }
    
    /// 选择分类和话题的。事件回调
    private func addItemsCallBack() {
        catesTipsItem.itemClickHandler = { [weak self] in
            self?.choseCateTips()
        }
        talksItem.itemClickHandler = { [weak self] in
            self?.choseTalksModel()
        }
        priceItem.itemClickHandler = { [weak self] in
            self?.showPriceSelectedView()
        }
        licenseItem.licenseClickHandler = { [weak self] in
            self?.getRecordLicenseVc()
        }
    }
    
    /// 获取本地未处理的 上传任务
    private func loadLoaclData() {
        guard let localTasks = UploadTask.shareTask().tasks else { return }
        if localTasks.count == 0 { return }
        let localTask = localTasks[0]
        self.pushTask = localTask
        if let tagTitles = localTask.pushModel.commitParams?[PushVideoController.kLocalTaskTitles] as? [String] {
            var tagsModels = [CateTagModel]()
            for tagTitle in tagTitles {
                let tagsModel = CateTagModel(id: 0, title: tagTitle, isSelected: false)
                tagsModels.append(tagsModel)
            }
            tagModels = tagsModels
            collectionView.reloadData()
        }
        if let title = localTask.pushModel.commitParams?[PushVideoApi.kTitle] as? String {
            textView.text = title
            placeHodlerLable.text = ""
        }
        if let talksId = localTask.pushModel.commitParams?[PushVideoApi.kTalks_id] as? Int {
            let talksModel = TalksModel()
            talksModel.id = talksId
            if let talksTitle = localTask.pushModel.commitParams?[PushVideoController.kLocalTaskTalkTitle] as? String {
                talksModel.title = talksTitle
                talksItem.titleLable.text = talksTitle
            }
            self.talkModel = talksModel
        }
        if let priceCoins = localTask.pushModel.commitParams?[PushVideoApi.kCoins] as? Int {
            self.coinsPrice = priceCoins
            if self.coinsPrice > 0 { //
                priceItem.tipsLable.text = "\(self.coinsPrice) 金币"
                priceItem.tipsLable.textColor = UIColor.white
            } else {
                priceItem.tipsLable.text = "不设置将视为免费"
                priceItem.tipsLable.textColor = UIColor(r: 59, g: 57, b: 73)
            }
        }
        videoImage = pushTask.pushModel.videoCover
        videoBtn.setBackgroundImage(videoImage, for: .normal)
    }
    
    private func addUploadPresenterCallBack() {
        pushTask.videoUploadProgressHandler = { [weak self] (progress) in
            self?.updateProgressUI(progress)
        }
        pushTask.videoUploadSucceedHandler = { [weak self]  in
            self?.progressCover.text = "封面上传中..."
            DLog("视频上传成功，准备上传图片。。。")
        }
        pushTask.videoUploadFailedHandler = { [weak self] (errorMsg) in
            DLog("videoUploadFailed")
            self?.progressCover.text = "上传失败\n请重新上传"
            self?.alertForUpload("视频上传失败，请重新上传!", step: 1)
        }
        pushTask.imageUploadSucceedHandler = {
            DLog("封面图上传成功， 开始提交视频。。。")
        }
        pushTask.imageUploadFailedHandler = { [weak self] (errorMsg) in
            DLog("封面图上传失败， 点击后从这一步继续？")
            self?.progressCover.text = "上传失败\n请重新上传"
            self?.alertForUpload("图片上传失败，请重新上传!", step: 2)
        }
        
        pushTask.commitUploadSucceedHandler = { [weak self] in
            DLog("视频提交成功，删除本地任删除本地任务，刷新列表")
           // XSAlert.show(type: .success, text: "视频上传成功！")
            self?.progressCover.text = "上传成功"
            self?.removeTasks()
            self?.showSucceedAlert()
        }
        
        pushTask.commitUploadFailedHandler = { [weak self] (errorMsg) in
             DLog("commitUploadFailed")
             self?.alertForUpload("请求提交失败，请重新上传!", step: 3)
        }
    }
    
    private func alertForUpload(_ msg: String, step: Int) {
        let alertContro = UIAlertController.init(title: nil, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "重新上传", style: .default) { (action) in
            self.pushTask.uploadVideo()
//            if step == 1 { // 视频文件上传失败
//                self.pushTask.uploadVideo()
//            } else if step == 2 { // 图片上传失败
//                self.pushTask.uploadVideo()
//            } else if step == 3 { // 提交失败
//                self.pushTask.uploadVideo()
//            }
        }
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            self.saveBtn.isEnabled = true
            self.catesTipsItem.fakeChoseBtn.isEnabled = true
            // 这里需要检测
        }
        alertContro.addAction(okAction)
        alertContro.addAction(cancleAction)
        self.present(alertContro, animated: true, completion: nil)
    }
    
    /// 移除任务
    private func removeTasks() {
        guard let _ = UploadTask.shareTask().tasks else { return }
        DLog("removeTasks")
        UploadTask.shareTask().tasks!.removeAll()
        UserDefaults.standard.removeObject(forKey: UserDefaults.kUploadTaskImage)
        UserDefaults.standard.removeObject(forKey: UserDefaults.kUploadTaskParams)
        UserDefaults.standard.set(0, forKey: UserDefaults.kUploadTaskStatu)
    }

    private func showSucceedAlert() {
        let succeedModel = ConvertCardAlertModel.init(title: "作品/动态发布成功", msgInfo: "请到‘我的-作品/动态‘查看", success: true)
        let controller = AlertManagerController(alertInfoModel: succeedModel)
        controller.modalPresentationStyle = .overCurrentContext
        controller.view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        controller.commitActionHandler = { [weak self] in
             self?.closeAction()
        }
        self.modalPresentationStyle = .currentContext
        self.present(controller, animated: true, completion: nil)
    }
    
    private func alertForLimit(_ msg: String) {
        let alertContro = UIAlertController.init(title: "温馨提示", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) { (action) in
            self.commitUpload()
        }
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
           
            // 这里需要检测
        }
        alertContro.addAction(okAction)
        alertContro.addAction(cancleAction)
        alertContro.modalPresentationStyle = .fullScreen
        self.present(alertContro, animated: true, completion: nil)
    }
    
    private func closeAction() {
        UploadTask.shareTask().talksModel = nil
        UploadTask.shareTask().content = nil
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - User Actions
private extension PushVideoController {
    
    /// 预览播放
    @objc func videoWatch() {
        let playerVc = AVPlayerViewController()
        playerVc.player = AVPlayer(url: FileManager.videoExportURL)
        playerVc.player?.play()
        playerVc.modalPresentationStyle = .fullScreen
        self.present(playerVc, animated: false, completion: nil)
    }
    
   func choseCateTips() {
        let cateTagsVc = CateAllTagsController()
        cateTagsVc.saveButtonClickHandler = { (allTags) in
            self.tagModels = allTags
            self.isChangeparams = true
            self.collectionView.reloadData()
        }
        navigationController?.pushViewController(cateTagsVc, animated: true)
    }
    func choseTalksModel() {
        let talksvc = AddTalksController()
        talksvc.talksChooseBackHandler = { (talksModel) in
            self.talkModel = talksModel
            if let titles = talksModel.title, titles.count > 0 {
                self.talksItem.tipsLable.text = "\(titles)"
                self.talksItem.tipsLable.textColor = UIColor.white
            } else {
                self.talksItem.tipsLable.text = "参与话题,让更多人看到"
                self.talksItem.tipsLable.textColor = UIColor(r: 59, g: 57, b: 73)
            }
        }
        navigationController?.pushViewController(talksvc, animated: true)
    }
    
    func showPriceSelectedView() {
        let priceChoseVC = VideoCoinSelectedController()
        priceChoseVC.modalPresentationStyle = .overCurrentContext
        priceChoseVC.definesPresentationContext = true
        priceChoseVC.view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        self.present(priceChoseVC, animated: false, completion: nil)
        priceChoseVC.coinsSelectedHandler = { price in
            self.coinsPrice = price
            if self.coinsPrice > 0 { //
                self.priceItem.tipsLable.text = "\(self.coinsPrice) 金币"
                self.priceItem.tipsLable.textColor = UIColor.white
            } else {
                self.priceItem.tipsLable.text = "不设置将视为免费"
                self.priceItem.tipsLable.textColor = UIColor(r: 59, g: 57, b: 73)
            }
            priceChoseVC.dismiss(animated: false, completion: nil)
        }
    }
    
    /// 录制须知
    func getRecordLicenseVc() {
        let uploadLicense = UploadLicenseController()
        uploadLicense.webType = .typeUpload
        navigationController?.pushViewController(uploadLicense, animated: true)
    }
    
    /// 上传任务存本地
    @objc func saveTask() {
        let allowed = allowedForUploadOrSave(true)
        if allowed {
            if videoImage == nil {
                return
            }
            var params = [String: Any]()
            params[PushVideoApi.kTitle] = textView.text
            params[PushVideoApi.kTalks_id] = talkModel?.id
            params[PushVideoApi.kKey_id] = getVideokeysIds() ?? ""
            params[PushVideoApi.kDuration] = videoDuration
            params[PushVideoApi.kCoins] = coinsPrice
            params[PushVideoController.kLocalTaskTitles] = getVideokeysTitles()
            params[PushVideoController.kLocalTaskTalkTitle] = talkModel?.title
            let pushTasks = PushPresenter()
            pushTasks.pushModel = PushVideoModel.init(videoCover: videoImage, videoUrl: FileManager.videoExportURL, commitParams: params)
            // 这里用 UploadTask持有 task
            UploadTask.shareTask().tasks = [pushTasks]
            // 保存本地
            pushTasks.saveUploadTask()
            XSAlert.show(type: .success, text: "保存成功！")
            closeAction()
        }
    }
    
    /// 上传业务 1.判断必传参数。 2.上传封面图， 3。上传视频文件 4. 吊用提交接口。
    @objc func commitPushVideo(_ sender: UIButton) {
        let _ = uploadCountApi.loadData()
    }
    
    /// 提交
    func commitUpload() {
        let allowed = allowedForUploadOrSave(false) 
        if allowed {
            commitBtn.isEnabled = false
            saveBtn.isEnabled = false
            catesTipsItem.fakeChoseBtn.isEnabled = false
            if isUploadFormLastTimeSave {
                if var params = pushTask.pushModel.commitParams {
                    params.removeValue(forKey: PushVideoController.kLocalTaskTitles)
                    params.removeValue(forKey: PushVideoController.kLocalTaskTalkTitle)
                    params[PushVideoApi.kTitle] = textView.text
                    params[PushVideoApi.kTalks_id] = talkModel?.id
                    params[PushVideoApi.kCoins] = coinsPrice
                    if isChangeparams {
                        params[PushVideoApi.kKey_id] = getVideokeysIds()
                    }
                    pushTask.pushModel.commitParams = params
                }
            } else {
                var params = [String: Any]()
                params[PushVideoApi.kTitle] = textView.text
                params[PushVideoApi.kTalks_id] = talkModel?.id
                params[PushVideoApi.kCoins] = coinsPrice
                params[PushVideoApi.kKey_id] = getVideokeysIds() ?? ""
                params[PushVideoApi.kDuration] = videoDuration * 1000
                params[PushVideoController.kLocalTaskTitles] = getVideokeysTitles()
                params[PushVideoController.kLocalTaskTalkTitle] = talkModel?.title
                pushTask.pushModel = PushVideoModel.init(videoCover: videoImage, videoUrl: FileManager.videoExportURL, commitParams: params)
            }
            pushTask.uploadVideo()
            // 这里用 UploadTask持有 task,
            UploadTask.shareTask().tasks = [self.pushTask]
        }
    }
    
    func updateProgressUI(_ progress: Double) {
        let height = Float(progress * 145.0)
        progressCover.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
        progressCover.text = String(format: "上传中%.f%@", Float(progress * 100.0), "%")
    }
    
    /// 取出所有的ids
    func getVideokeysIds() -> String? {
        var tagKeyIds = [Int]()
        for tagModel in tagModels {
            tagKeyIds.append(tagModel.id ?? 0)
        }
        if let data = try? JSONSerialization.data(withJSONObject: tagKeyIds, options: []) {
            if let json = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue) {
                return json as String
            }
        }
        return nil
    }
    
    /// 取出所有title
    func getVideokeysTitles() -> [String] {
        var tagKeyTitles = [String]()
        for tagModel in tagModels {
            tagKeyTitles.append(tagModel.title ?? "")
        }
        return tagKeyTitles
    }
    
    func allowedForUploadOrSave(_ isSaveAction: Bool) -> Bool {
        if let currentTasks = UploadTask.shareTask().tasks, currentTasks.count > 0 {
            if isUploadFormLastTimeSave {
                if isSaveAction {
                    // 当前有任务在上传中
                    XSAlert.show(type: .warning, text: "您已保存过该作品.")
                    return false
                }
            } else {
                // 当前有任务在上传中
                XSAlert.show(type: .warning, text: "您有一个作品未处理.")
                return false
            }
        }
        if textView.text.isEmpty {
            XSAlert.show(type: .warning, text: "请填写动态/作品的文字内容")
            return  false
        }
        if talkModel == nil {
            XSAlert.show(type: .warning, text: "请添加话题")
            return false
        }
        if tagModels.count == 0 {
            XSAlert.show(type: .warning, text: "请选择视频分类")
            return false
        }
        if !licenseItem.licenseChoseBtn.isSelected {
            XSAlert.show(type: .warning, text: "您还未同意上传抖阴上传规则")
            return false
        }
        return true
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PushVideoController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellForRow(with: indexPath)
        return cell
    }
    
    /// 配置cell
    func cellForRow(with indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PushKeysCell.cellId, for: indexPath) as! PushKeysCell
        cell.tagLabel.text = tagModels[indexPath.row].title ?? ""
        cell.deleteTagsHandler = { [weak self] in
            self?.tagModels.remove(at: indexPath.item)
            self?.isChangeparams = true
            self?.collectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return PushVideoController.videoItemSize
    }
}

// MARK: - QHNavigationBarDelegate
extension PushVideoController:  QHNavigationBarDelegate  {
    
    func backAction() {
        self.closeAction()
    }
    
}

// MARK: - UITextViewDelegate
extension PushVideoController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHodlerLable.text = ""
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count >= 300 {
            return false
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            placeHodlerLable.text = "@抖阴 随时随地，分享你的性福生活"
        }
        return true
    }
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension PushVideoController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: self.view, imageNames: nil, bgColor: UIColor.clear, animated: false)
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserUploadCountApi {
            if let dic = manager.response.content as? [String : Any] {
                if ConstValue.kIsEncryptoApi { /// 加密后 s次数变为字符串
                    if let result = dic["result"] as? String  {
                        let decodeResultString = result.urlDecoded()
                        if let num = decodeResultString.aes128DecryptString(withKey: ConstValue.kApiEncryptKey) {
                            if Int(num) == 0 {
                                XSAlert.show(type: .error, text: "今日上传次数已满，请隔日再上传")
                            } else {
                                commitUpload()
                            }
                        }
                    }
                } else {
                    if let result = dic["result"] as? Int {
                        if result == 0 {
                            XSAlert.show(type: .error, text: "今日上传次数已满，请隔日再上传")
                        } else {
                            commitUpload()
                        }
                    }
                }
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        XSAlert.show(type: .error, text: "网络不佳，请重试")
    }
}


// MARK: - Layout
private extension PushVideoController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutVideoPart()
        layoutTalksChosePart()
        layoutPriceItemPart()
        layoutCateChosePart()
        layoutBottomPart()
        layoutCollectionView()
        layoutLicenseItem()
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    
    func layoutVideoPart() {
        videoBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-15)
            make.top.equalTo(navBar.snp.bottom).offset(5)
            make.width.equalTo(100)
            make.height.equalTo(145)
        }
        textView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(navBar.snp.bottom).offset(5)
            make.trailing.equalTo(videoBtn.snp.leading).offset(-10)
            make.height.equalTo(150)
        }
        progressCover.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(videoBtn)
            make.height.equalTo(0)
        }
        placeHodlerLable.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom).offset(5)
            make.leading.equalTo(textView).offset(10)
            make.trailing.equalTo(textView).offset(-10)
            make.height.equalTo(40)
        }
    }
    
    func layoutCateChosePart() {
        catesTipsItem.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(priceItem.snp.bottom)
            make.height.equalTo(50)
        }
    }
    func layoutTalksChosePart() {
        talksItem.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(textView.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
    }
    func layoutPriceItemPart() {
        priceItem.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(talksItem.snp.bottom)
            make.height.equalTo(50)
        }
    }
    
    func layoutBottomPart() {
        saveBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.width.equalTo((ConstValue.kScreenWdith - 55)/2)
            make.height.equalTo(40)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
            } else {
                make.bottom.equalTo(-8)
            }
        }
        commitBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-15)
            make.width.equalTo((ConstValue.kScreenWdith - 55)/2)
            make.height.equalTo(40)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
            } else {
                make.bottom.equalTo(-8)
            }
        }
    }
    
    func layoutLicenseItem() {
        licenseItem.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(saveBtn.snp.top).offset(-8)
            make.top.equalTo(collectionView.snp.bottom).offset(10)
//            make.height.equalTo(90)
        }
    }
    
    func layoutCollectionView() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(catesTipsItem.snp.bottom).offset(10)
            make.height.equalTo(95)
        }
    }
}
