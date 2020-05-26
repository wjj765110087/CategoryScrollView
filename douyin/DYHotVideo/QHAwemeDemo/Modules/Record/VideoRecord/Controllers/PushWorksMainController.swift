//
//  PushWorksMainController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/2.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork
import AssetsLibrary
import Photos

class PushWorksMainController: QHBaseViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "发布动态/作品"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.lineView.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.init(white: 0.9, alpha: 1.0)
        textView.font = UIFont.systemFont(ofSize: 14)
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
    lazy var addImageBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "PushimageChose"), for: .normal)
        button.addTarget(self, action: #selector(addImageButtonClick), for: .touchUpInside)
        return button
    }()
    lazy var videoUploadBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "UpLoadVideoIcon"), for: .normal)
        button.addTarget(self, action: #selector(videoUploadClick), for: .touchUpInside)
        return button
    }()
    lazy var videoRecordBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "PushVideoRecord"), for: .normal)
        button.addTarget(self, action: #selector(videoRecodClick), for: .touchUpInside)
        return button
    }()
    
    let talksItem: CateChoseItemView = {
        let item = CateChoseItemView(frame: CGRect.zero)
        item.titleLable.text = "添加话题"
        item.tipsLable.text = "参与话题,让更多人看到"
        item.iconImage.image = UIImage(named: "talksPushIcon")
        return item
    }()
    let pushTipsLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor(r: 153, g: 153, b: 153)
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.numberOfLines = 0
        lable.attributedText = TextSpaceManager.getAttributeStringWithString("温馨提示: 视频动态发布后，请在 我的作品 中查看审核进度， 图片和文字动态请在 我的动态 中查看审核进度。审核通过后用将分别在首页和社区中展示。", lineSpace: 5)
        return lable
    }()
    lazy var commitBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("发 布", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(r: 0, g: 123, b: 255)
        button.layer.cornerRadius = 22.5
        button.layer.masksToBounds = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(pushBtnClick), for: .touchUpInside)
        return button
    }()

    /// 提交动态Api
    private lazy var pushTopicUpApi: PushTopicApi = {
        let pushApi = PushTopicApi()
        pushApi.paramSource = self
        pushApi.delegate = self
        return pushApi
    }()
    var talksModel: TalksModel?
    var commitParams = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        addItemsCallBack()
        (self.navigationController as? QHNavigationController)?.changeTransition(false)
    }
    
    private func setUpUI() {
        view.addSubview(navBar)
        view.addSubview(addImageBtn)
        view.addSubview(videoUploadBtn)
        view.addSubview(videoRecordBtn)
        view.addSubview(textView)
        view.addSubview(placeHodlerLable)
        view.addSubview(talksItem)
        view.addSubview(pushTipsLable)
        view.addSubview(commitBtn)
        layoutPageSubviews()
        if let titles = self.talksModel?.title, titles.count > 0 {
            self.talksItem.tipsLable.text = "\(titles)"
            self.talksItem.tipsLable.textColor = UIColor.white
        } else {
            self.talksItem.tipsLable.text = "参与话题,让更多人看到"
            self.talksItem.tipsLable.textColor = UIColor(r: 59, g: 57, b: 73)
        }
    }
    
    /// 选择分类和话题的。事件回调
    private func addItemsCallBack() {
        talksItem.itemClickHandler = { [weak self] in
            self?.choseTalksModel()
        }
    }
    @objc private func pushBtnClick() {
        var params = [String: Any]()
        if textView.text.isEmpty {
            XSAlert.show(type: .warning, text: "请填写动态内容")
            return
        }
        if talksModel == nil {
            XSAlert.show(type: .warning, text: "请添加话题")
            return
        }
        if let content = textView.text {
            if content.isEmpty {
                XSAlert.show(type: .warning, text: "请填写动态内容")
                return
            }
            params[PushTopicApi.kTitle] = content
        }
        if let topicId = talksModel?.id {
            params[PushTopicApi.kTalks_id] = topicId
        }
        // 保存参数
        commitParams = params
        // 没有上传照片，直接提交
        commitTopicPush(params)
    }
}

// MARK: - Private Funcs
private extension PushWorksMainController {
    func choseTalksModel() {
        let talksvc = AddTalksController()
        talksvc.talksChooseBackHandler = { (talksModel) in
            self.talksModel = talksModel
            if let titles = self.talksModel?.title, titles.count > 0 {
                self.talksItem.tipsLable.text = "\(titles)"
                self.talksItem.tipsLable.textColor = UIColor.white
            } else {
                self.talksItem.tipsLable.text = "参与话题,让更多人看到"
                self.talksItem.tipsLable.textColor = UIColor(r: 59, g: 57, b: 73)
            }
        }
        navigationController?.pushViewController(talksvc, animated: true)
    }
    @objc func addImageButtonClick() {
        let imagePushVC = PushImagesController()
        imagePushVC.talkModel = self.talksModel
        imagePushVC.content = textView.text
        navigationController?.pushViewController(imagePushVC, animated: false)
    }
    @objc func videoRecodClick() {
        if let tasks = UploadTask.shareTask().tasks, tasks.count > 0 {
            alertForUpdateVideos()
            return
        }
        UploadTask.shareTask().talksModel = self.talksModel
        UploadTask.shareTask().content = textView.text
        let recordVc = QHRecordViewController()
        navigationController?.pushViewController(recordVc, animated: true)
    }
    @objc func videoUploadClick() {
        if let tasks = UploadTask.shareTask().tasks, tasks.count > 0 {
            alertForUpdateVideos()
            return
        }
        UploadTask.shareTask().talksModel = self.talksModel
        UploadTask.shareTask().content = textView.text
        choseVideoFromLibrary()
    }
    /// 从相册选择视频
    func choseVideoFromLibrary() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Thumbnail", bundle: nil)
        let vc: ThumbnailViewController = storyboard.instantiateViewController(withIdentifier: "Thumbnail") as! ThumbnailViewController
        //        let nav = QHNavigationController(rootViewController: vc)
        vc.videoChoseHandler = { (asset) in
            DLog("videoChoseHandler.asset= \(asset)")
            self.libraryVideoEditor(asset: asset)
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
    private func alertForUpdateVideos() {
        let msg = "您有一个待处理视频，请前往个人中心 -> 作品列表 查看视频上传状态。"
        let alertContro = UIAlertController.init(title: nil, message: msg, preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "知道了", style: .cancel) { (action) in
        }
        alertContro.addAction(cancleAction)
        alertContro.modalPresentationStyle = .fullScreen
        self.present(alertContro, animated: true, completion: nil)
    }
    
    /// 提交动态
    func commitTopicPush(_ params: [String : Any]) {
        XSProgressHUD.showProgress(msg: "发布中...", onView: view, animated: false)
        let _ = pushTopicUpApi.loadData()
    }
}

// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension PushWorksMainController: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        return commitParams
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is PushTopicApi {
            XSAlert.show(type: .success, text: "发布成功")
            closeAction()
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is PushTopicApi {
            XSAlert.show(type: .error, text: manager.errorMessage)
        }
    }
}

// MARK: - UITextViewDelegate
extension PushWorksMainController: UITextViewDelegate {
    
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
            commitBtn.isEnabled = false
        } else {
            commitBtn.isEnabled = true
        }
        return true
    }
}


// MARK: - Layout
private extension PushWorksMainController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutVideoPart()
        layoutTalksChosePart()
        layoutPushTipsLabel()
        layoutBottomPart()
    }
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    func layoutVideoPart() {
        textView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(navBar.snp.bottom).offset(5)
            make.trailing.equalTo(-15)
            make.height.equalTo(120)
        }
        addImageBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(8)
            make.top.equalTo(textView.snp.bottom).offset(15)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        videoUploadBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(addImageBtn.snp.trailing).offset(15)
            make.centerY.equalTo(addImageBtn)
            make.width.height.equalTo(40)
        }
        videoRecordBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(videoUploadBtn.snp.trailing).offset(15)
            make.centerY.equalTo(videoUploadBtn)
            make.width.height.equalTo(40)
        }
        placeHodlerLable.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom).offset(5)
            make.leading.equalTo(textView).offset(10)
            make.trailing.equalTo(textView).offset(-10)
            make.height.equalTo(40)
        }
    }
    func layoutTalksChosePart() {
        talksItem.snp.makeConstraints { (make) in
            make.leading.equalTo(5)
            make.trailing.equalTo(-5)
            make.top.equalTo(addImageBtn.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
    }
    func layoutPushTipsLabel() {
        pushTipsLable.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(talksItem.snp.bottom).offset(20)
        }
    }
    func layoutBottomPart() {
        commitBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-25)
            make.leading.equalTo(25)
            make.height.equalTo(45)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            } else {
                make.bottom.equalTo(-20)
            }
        }
    }
}



// MARK: - QHNavigationBarDelegate
extension PushWorksMainController: QHNavigationBarDelegate  {
    func backAction() {
        closeAction()
    }
    private func closeAction() {
        (self.navigationController as? QHNavigationController)?.changeTransition(true)
        self.navigationController?.popViewController(animated: true)
        (self.navigationController as? QHNavigationController)?.changeTransition(false)
    }
}
