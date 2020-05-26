//
//  ApplyForUploadController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/5/10.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//  申请上传权限控制器

import UIKit
import NicooNetwork
import SnapKit
import Photos

class ApplyForUploadController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "申请上传权限"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    private lazy var bgScroll: UIView = {
        let scroll = UIView.init(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 710))
        scroll.backgroundColor = UIColor.clear
        return scroll
    }()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.delegate = self
        table.dataSource = self
        table.allowsSelection = false
        table.separatorStyle = .none
        table.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: InfoFindAcountController.fakeCell)
        return table
    }()
    private lazy var textContainer: UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 240))
        view.backgroundColor = UIColor(red: 33/255.0, green: 36/255.0, blue:44/255.0, alpha: 0.99)
        view.layer.cornerRadius = 10
        view.clipsToBounds = false
        return view
    }()
    let titLable: UILabel = {
        let lable = UILabel()
        lable.textColor = ConstValue.kTitleYelloColor
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.numberOfLines = 3
        lable.text = "*视频上传权限申请开通后，每天可上传3部视频请严格遵照上传规则，避免违规"
        return lable
    }()
    let firstStepLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.text = "第一步: 上传视频样品/权限说明"
        return lable
    }()
    let stepTipsLable: UILabel = {
        let lable = UILabel()
        lable.textColor = ConstValue.kTitleYelloColor
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.numberOfLines = 3
        lable.text = "*竖屏内容将被优先审核,本样品仅作为审核参考,不公开展示"
        return lable
    }()
    let secondStepLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.text = "第二步: 填写联系方式"
        return lable
    }()
    private lazy var connectContainer: UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 50))
        view.backgroundColor = UIColor(red: 33/255.0, green: 36/255.0, blue:44/255.0, alpha: 0.99)
        view.layer.cornerRadius = 10
        view.clipsToBounds = false
        return view
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
        lable.textColor = UIColor(white: 0.7, alpha: 0.6)
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.numberOfLines = 2
        lable.text = "请简述您的申请理由，如：视频内容为个人视频或第三方视频，视频类型等（必填）"
        return lable
    }()
    private lazy var photoView: PhotoChoseView = {
        let view = PhotoChoseView.init(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 100))
        view.backgroundColor = UIColor.clear
        view.maxCount = 1
        return view
    }()
    private lazy var connectTf: UITextField = {
        let textFiled = UITextField()
        textFiled.tintColor = .clear
        textFiled.backgroundColor = UIColor.clear
        textFiled.textColor = UIColor.white
        textFiled.borderStyle = .none
        textFiled.font = UIFont.systemFont(ofSize: 12)
        textFiled.layer.cornerRadius = 8
        textFiled.layer.masksToBounds = true
        let ptext = "邮箱/Telegram/Potato,方便我们联系(选填)"
        textFiled.placeholder = ptext
        textFiled.setPlaceholderTextColor(placeholderText: ptext, color: UIColor(white: 0.7, alpha: 0.6))
        return textFiled
    }()
    lazy var commitBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = ConstValue.kTitleYelloColor
        button.layer.cornerRadius = 22.5
        button.layer.masksToBounds = true
        button.setTitle("提交", for: .normal)
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(commitClick), for: .touchUpInside)
        return button
    }()
    
    let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        view.isHidden = true
        return view
    }()
    
    lazy var progressView: CycleProgressView = {
        let progress = CycleProgressView.init(frame: CGRect(x: 0, y: 0, width: 120, height: 120), lineWidth: 5.0)
        return progress
    }()
   
    var pushTask = PushPresenter()
    
    var videoImage: UIImage?

    var questionModels = [QuestionModel]()
    
    var commitParams = [String: Any]()
    var commitImageNames = [String]()
    
    
    let viewMode = UserInfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(navBar)
        layoutNavBar()
        setUpUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    private func setUpUI() {
        view.addSubview(tableView)
        layoutPageSubviews()
        bgScroll.addSubview(titLable)
        bgScroll.addSubview(firstStepLable)
        bgScroll.addSubview(textContainer)
        bgScroll.addSubview(stepTipsLable)
        bgScroll.addSubview(secondStepLable)
        bgScroll.addSubview(connectContainer)
        bgScroll.addSubview(commitBtn)
        layoutScrollSubviews()
        
        textContainer.addSubview(textView)
        textContainer.addSubview(placeHodlerLable)
        textContainer.addSubview(photoView)
        layoutTextContainerSubviews()
        
        connectContainer.addSubview(connectTf)
        layoutConnectContainerSubviews()
        
        tableView.tableHeaderView = bgScroll
        
        /// 回调
        addPictureCallBack()
        addUploadPresenterCallBack()
        
        connectTf.setPlaceholderTextColor(placeholderText: "邮箱/Telegram/Potato,方便我们联系(选填)", color: UIColor(white: 0.7, alpha: 0.6))
        coverView.addSubview(progressView)
        view.addSubview(coverView)
        layoutProgressView()
    }
    
    /// 视频上传回调
    private func addUploadPresenterCallBack() {
        pushTask.videoUploadProgressHandler = { [weak self] (progress) in
            self?.updateProgressUI(progress)
        }
        pushTask.videoUploadSucceedHandler = { [weak self]  in
            self?.progressView.label?.text = "封面上传中..."
            DLog("视频上传成功，准备上传图片。。。")
        }
        pushTask.videoUploadFailedHandler = { [weak self] (errorMsg) in
            DLog("videoUploadFailed")
            self?.alertForUpload("视频上传失败，请重新上传!", step: 1)
        }
        pushTask.imageUploadSucceedHandler = {
            DLog("封面图上传成功， 开始提交视频。。。")
        }
        pushTask.imageUploadFailedHandler = { [weak self] (errorMsg) in
            DLog("封面图上传失败， 点击后从这一步继续？")
            self?.alertForUpload("图片上传失败，请重新上传!", step: 2)
        }
        
        pushTask.commitUploadSucceedHandler = { [weak self] in
            DLog("视频提交成功，删除本地任删除本地任务，刷新列表")
            self?.showSucceedAlert()
        }
        
        pushTask.commitUploadFailedHandler = { [weak self] (errorMsg) in
            DLog("commitUploadFailed")
            self?.alertForUpload("请求提交失败，请重新上传!", step: 3)
        }
    }
    
    /// 更新上传进度
    private func updateProgressUI(_ progress: Double) {
         progressView.setProgress(value: CGFloat(progress))
         progressView.label?.text =  String(format: "%.f%@", Float(progress * 100), "%")
    }
    
    private func addPictureCallBack() {
        if photoView.pictures.count > 1 {
            XSAlert.show(type: .error, text: "只能选择一个视频！")
            return
        }
        photoView.addPictureAction = { [weak self] in
            self?.openLocalPhotoAlbum()
        }
    }
    
    /// 上传失败提示
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
            // 这里需要检测
            self.coverView.isHidden = true
        }
        alertContro.addAction(okAction)
        alertContro.addAction(cancleAction)
        self.present(alertContro, animated: true, completion: nil)
    }
    
    /// 上传成功提示
    private func showSucceedAlert() {
        let succeedModel = ConvertCardAlertModel.init(title: "上传成功", msgInfo: "等待审核通过后，您就可以上传作品了", success: true)
        let controller = AlertManagerController(alertInfoModel: succeedModel)
        controller.modalPresentationStyle = .overCurrentContext
        controller.view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        controller.commitActionHandler = { [weak self] in
            self?.closeAction()
        }
        self.modalPresentationStyle = .currentContext
        self.present(controller, animated: true, completion: nil)
    }
    
    private func closeAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /// 禁止一切操作
    private func disableAllActions(_ enable: Bool) {
        commitBtn.isEnabled = enable
        navBar.backButton.isEnabled = enable
        photoView.isUserInteractionEnabled = enable
        textView.isEditable = enable
        connectTf.isEnabled = enable
    }
    
    // MARK: - 相册选图
    private func openLocalPhotoAlbum() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Thumbnail", bundle: nil)
        let vc: ThumbnailViewController = storyboard.instantiateViewController(withIdentifier: "Thumbnail") as! ThumbnailViewController
        //        let nav = QHNavigationController(rootViewController: vc)
        vc.videoChoseHandler = { (asset) in
            self.libraryVideoEditor(asset: asset)
        }
        vc.cancleChoseHandler = {
            
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
            vc.uploadType = .UploadFor_Check
            vc.applyCheckDoneActionHandler = { [weak self] (image) in
                guard let strongSelf = self else { return }
                strongSelf.videoImage = image
                strongSelf.photoView.setPictures([image ?? ConstValue.kVerticalPHImage ?? UIImage()])
            }
            self.navigationController?.pushViewController(vc, animated: false)
        default:
            break
        }
    }
    
    /// 提交权限审核
    @objc private func commitClick() {
        var params = [String : Any]()
        if textView.text == nil { return }
        if let content = textView.text {
            if content.isEmpty {
                XSAlert.show(type: .warning, text: "请填写申请理由")
                return
            }
            params[ApplyCheckApi.kContent] = content
        }
        params[ApplyCheckApi.kContact] = connectTf.text ?? ""
        // 保存参数
        commitParams = params
        pushTask.pushModel = PushVideoModel.init(videoCover: videoImage, videoUrl: FileManager.videoExportURL, commitParams: params)
        pushTask.videoPushType = .pushTypeCheck
        pushTask.uploadVideo()
        //progressView.isHidden = false
        coverView.isHidden = false
        
    }
    
}

// MARK: - QHNavigationBarDelegate
extension ApplyForUploadController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextViewDelegate
extension ApplyForUploadController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHodlerLable.text = ""
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            placeHodlerLable.text = "请简述您的申请理由，如：视频内容为个人视频或第三方视频，视频类型等（必填）"
        }
        return true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ApplyForUploadController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - UIScrollViewDelegate
extension ApplyForUploadController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}

// MARK: - Layout
private extension ApplyForUploadController {
    
    func layoutPageSubviews() {
        layoutTableView()
    }
    
    func layoutScrollSubviews() {
        titLable.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(0)
            make.height.equalTo(60)
        }
        firstStepLable.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(titLable.snp.bottom)
            make.height.equalTo(50)
        }
        textContainer.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(firstStepLable.snp.bottom)
            make.trailing.equalTo(-15)
            make.height.equalTo(240)
        }
        stepTipsLable.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(textContainer)
            make.top.equalTo(textContainer.snp.bottom)
            make.height.equalTo(45)
        }
        secondStepLable.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(stepTipsLable.snp.bottom).offset(5)
            make.height.equalTo(50)
        }
        connectContainer.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.top.equalTo(secondStepLable.snp.bottom).offset(10)
            make.trailing.equalTo(-12)
            make.height.equalTo(50)
        }
        
        commitBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(connectContainer)
            make.top.equalTo(connectContainer.snp.bottom).offset(30)
            make.height.equalTo(45)
        }
    }
    
    func layoutTextContainerSubviews() {
        textView.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalTo(5)
            make.trailing.equalTo(-10)
            make.height.equalTo(120)
        }
        placeHodlerLable.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.leading.equalTo(textView).offset(10)
            make.trailing.equalTo(textView).offset(-10)
            make.height.equalTo(40)
        }
        photoView.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(10)
            make.leading.equalTo(textView)
            make.trailing.equalTo(textView)
            make.height.equalTo(100)
        }
    }
    
    func layoutConnectContainerSubviews() {
        connectTf.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalTo(5)
            make.trailing.equalTo(-10)
            make.height.equalTo(40)
        }
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    
    func layoutScrollView() {
        bgScroll.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(680)
            make.width.equalTo(ConstValue.kScreenWdith)
        }
    }
    
    func layoutProgressView () {
        coverView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        progressView.snp.makeConstraints { (make) in
            make.centerX.equalTo(coverView)
            make.centerY.equalTo(coverView)
            make.width.height.equalTo(120)
        }
    }
}

