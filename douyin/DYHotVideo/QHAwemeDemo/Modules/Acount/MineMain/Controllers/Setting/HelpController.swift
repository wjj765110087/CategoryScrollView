//
//  HelpController.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/25.
//  Copyright © 2018年 pro5. All rights reserved.
//

import UIKit
import SnapKit
import NicooNetwork

/// 用户反馈页面
class HelpController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "意见反馈"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    private lazy var exBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("我的反馈", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(ConstValue.kTitleYelloColor, for: .normal)
        button.addTarget(self, action: #selector(myFeedBtnClick), for: .touchUpInside)
        return button
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
    private lazy var connectContainer: UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 50))
        view.backgroundColor = UIColor(red: 33/255.0, green: 36/255.0, blue:44/255.0, alpha: 0.99)
        view.layer.cornerRadius = 10
        view.clipsToBounds = false
        return view
    }()
    lazy var detailExBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(explainClick), for: .touchUpInside)
        return button
    }()
    private let detailExLab: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = ConstValue.kTitleYelloColor
        label.text = "充值及兑换问题反馈，请查看详细说明"
        label.isHidden = false
        return label
    }()
    private let lineBtn: UIView = {
        let view = UIView()
        view.backgroundColor = ConstValue.kTitleYelloColor
        view.isHidden = false
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
        lable.text = "请用10~200字描述问题的详细情况,有助于我们快速帮您解决"
        return lable
    }()
    private lazy var photoView: PhotoChoseView = {
        let view = PhotoChoseView.init(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 100))
        view.backgroundColor = UIColor.clear
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
        textFiled.placeholder = "邮箱/Telegram/Potato,方便我们联系(选填)"
        return textFiled
    }()
    lazy var commitBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = ConstValue.kTitleYelloColor
        button.layer.cornerRadius = 22.5
        button.layer.masksToBounds = true
        button.setTitle("提交反馈", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(commitClick), for: .touchUpInside)
        return button
    }()
    private lazy var questionsApi: UserQuestionApi = {
        let api = UserQuestionApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    private lazy var imageUpLoad: UploadImageTool = {
        let upload = UploadImageTool()
        upload.delegate = self
        return upload
    }()
    var recordView: ItemLayoutView?
    var questionModels = [QuestionModel]()
    
    var commitParams = [String: Any]()
    var commitImageNames = [String]()
    
    /// 上传第几张图
    var uploadImageIndex: Int = 0
    
    let viewMode = UserInfoViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        navBar.navBarView.addSubview(exBtn)
        view.addSubview(navBar)
        layoutNavBar()
        loadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func loadData() {
        NicooErrorView.removeErrorMeesageFrom(view)
        _ = questionsApi.loadData()
    }
    
    private func setUpUI() {
        view.addSubview(tableView)
        layoutPageSubviews()
        
        addItemView()
        bgScroll.addSubview(detailExLab)
        bgScroll.addSubview(detailExBtn)
        bgScroll.addSubview(lineBtn)
        bgScroll.addSubview(textContainer)
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
        
        addViewModelCallBackHandler()
        addPictureCallBack()
        
        connectTf.setPlaceholderTextColor(placeholderText: "邮箱/Telegram/Potato,方便我们联系(选填)", color: UIColor(white: 0.7, alpha: 0.6))
    }
    
    private func addItemView() {
        var items = [ItemModel]()
        for question in questionModels {
            let item = ItemModel.init(question: question, isSelected: false)
            items.append(item)
        }
        //封装的view
        recordView = ItemLayoutView(aFrame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 120), aTitle: "选择反馈问题", aArray: items)
        bgScroll.addSubview(recordView!)
        DLog("recordViewFrame = \(recordView!.frame)")
    }
    
    private func addViewModelCallBackHandler() {
        viewMode.fadeBackSuccessHandler = { [weak self] in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
            strongSelf.showErrorMessage("反馈成功，感谢您的建议！", cancelHandler: {
                strongSelf.navigationController?.popViewController(animated: true)
            })
        }
        viewMode.fadeBackFailHandler = { [weak self] (msg) in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
            XSAlert.show(type: .error, text: msg)
        }
    }
    
    private func addPictureCallBack() {
        photoView.addPictureAction = { [weak self] in
            self?.openLocalPhotoAlbum()
        }
    }
    
    // MARK: - 相册选图
    private func openLocalPhotoAlbum() {
        _ = self.jh_presentPhotoVC(3 - self.photoView.pictures.count, completeHandler: {  [weak self]  items in
            guard let strongSelf = self else { return }
            var pictures = strongSelf.photoView.pictures
            for item in items {
                let _ = item.originalImage({ (originImage) in
                    pictures.append(originImage)
                })
            }
            strongSelf.photoView.setPictures(pictures)
        })
    }

    @objc private func commitClick() {
        var params = [String: Any]()
      // 这里先吊用图片上传，不管上传成功失败，都吊用提交
        let questons = recordView!.seletedModels
        if questons.count == 0 {
            XSAlert.show(type: .warning, text: "请选择您要反馈的问题!")
            return
        }
        var keys = [String]()
        for item in questons {
            if let questKey = item.question?.key, !questKey.isEmpty {
                keys.append(questKey)
            }
        }
        if let data = try? JSONSerialization.data(withJSONObject: keys, options: []) {
            if let json = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue) {
                params[UserFadeBackApi.kKeys] =  json as String
            }
        }
        
        if textView.text == nil { return }
        if let content = textView.text {
            if content.isEmpty {
                XSAlert.show(type: .warning, text: "您还没有输入反馈内容。")
                return
            }
            params[UserFadeBackApi.kContent] = content
        }
        if let contact = connectTf.text, !contact.isEmpty {
            params[UserFadeBackApi.kContact] = contact
        }
        // 保存参数
        commitParams = params
        if photoView.pictures.count > 0 {
            // 先上传照片，在zuo 提交
            XSProgressHUD.showProgress(msg: "图片上传中...", onView: view, animated: false)
            uploadImage(0)
        } else {
            // 没有上传照片，直接提交
            feedBackCommit(params)
        }
    }
    /// 开始上床
    func uploadImage(_ currentIndex: Int) {
        if photoView.pictures.count > currentIndex {
            imageUpLoad.upload(photoView.pictures[currentIndex])
        } else {
            if commitImageNames.count == photoView.pictures.count { // 上传完成
                XSProgressHUD.hide(for: view, animated: false)
                uploadImageIndex = 0
                if let data = try? JSONSerialization.data(withJSONObject: commitImageNames, options: []) {
                    if let json = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue) {
                        commitParams[UserFadeBackApi.kCover_filename] = json as String
                        feedBackCommit(commitParams)
                    }
                }
            }
        }
    }
    @objc func explainClick() {
        DLog("go see licesen")
        let aboutus = UploadLicenseController()
        aboutus.webType = .typePayExplain
        navigationController?.pushViewController(aboutus, animated: true)
    }
    private func feedBackCommit(_ params: [String: Any]) {
         XSProgressHUD.showProgress(msg: "提交反馈中...", onView: view, animated: false)
         viewMode.fadeBack(params)
    }
    
    @objc func myFeedBtnClick() {
        let feedvc = MyFeedbackController()
        navigationController?.pushViewController(feedvc, animated: true)
    }
}

// MARK: - QHNavigationBarDelegate
extension HelpController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextViewDelegate
extension HelpController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHodlerLable.text = ""
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty {
           placeHodlerLable.text = "请用10~200字描述问题的详细情况,有助于我们快速帮您解决"
        }
        return true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HelpController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - UIScrollViewDelegate
extension HelpController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension HelpController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: self.view, imageNames: nil, bgColor: UIColor.clear, animated: false)
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserQuestionApi {
            if let questions = manager.fetchJSONData(UserReformer()) as? [QuestionModel] {
                questionModels = questions
                if questionModels.count == 0 {
                    NicooErrorView.showErrorMessage(.noData, on: view, clickHandler: nil)
                } else {
                    setUpUI()
                }
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserQuestionApi {
            NicooErrorView.showErrorMessage(.noNetwork, on: view) {
                self.loadData()
            }
        }
    }
}


// MARK: - UploadImageDelegate
extension HelpController: UploadImageDelegate {
    
    func paramsForAPI(_ uploadImageTool: UploadImageTool) -> [String : String]? {
        XSProgressHUD.showProgress(msg: nil, onView: view, animated: false)
        return nil
    }
    
    func uploadImageMethod(_ uploadImageTool: UploadImageTool) -> String {
        return "/\(ConstValue.kApiVersion)/feedback/upload"
    }
    
    func uploadImageSuccess(_ uploadImageTool: UploadImageTool, resultDic: [String : Any]?) {
        if let imageName = resultDic?["result"] as? String {
            commitImageNames.append(imageName)
            uploadImageIndex  = uploadImageIndex + 1
            uploadImage(uploadImageIndex)
        } else {
            XSAlert.show(type: .error, text: "图片上传失败")
        }
    }
    
    func uploadImageFailed(_ uploadImageTool: UploadImageTool, errorMessage: String?) {
        XSProgressHUD.hide(for: view, animated: false)
        XSAlert.show(type: .error, text: "图片上传失败")
    }
    
    func uploadFailedByTokenError() {
        XSProgressHUD.hide(for: view, animated: false)
    }
    
}

// MARK: - Layout
private extension HelpController {
    
    func layoutPageSubviews() {
        layoutTableView()
    }
    
    func layoutExBtnBtn() {
        exBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(75)
            make.height.equalTo(35)
        }
    }
    
    func layoutScrollSubviews() {
        detailExLab.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(recordView!.snp.bottom).offset(-5)
            make.height.equalTo(20)
        }
        detailExBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(recordView!.snp.bottom).offset(-5)
            make.trailing.equalTo(-15)
            make.height.equalTo(26)
        }
        lineBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(detailExLab.snp.bottom).offset(-3)
            make.trailing.equalTo(detailExLab.snp.trailing)
            make.height.equalTo(1)
        }
        textContainer.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(detailExLab.snp.bottom).offset(6)
            make.trailing.equalTo(-15)
            make.height.equalTo(240)
        }
        connectContainer.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.top.equalTo(textContainer.snp.bottom).offset(15)
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
        layoutExBtnBtn()
    }
    
    func layoutScrollView() {
        bgScroll.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(710)
            make.width.equalTo(ConstValue.kScreenWdith)
        }
    }
}

