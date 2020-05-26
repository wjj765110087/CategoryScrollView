//
//  MainVedioViewController.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

class MainVedioViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    /// 防止跳转时闪动 bug
    private let fakeBarView: UIView = {
        let view = UIView()
        view.backgroundColor = kBarColor
        return view
    }()
    private lazy var pageView: PageItemView = {
       let view = PageItemView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        view.titles = MainType.share().typeTitles()
        return view
    }()
    private lazy var muneBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "allKM"), for: .normal)
        button.addTarget(self, action: #selector(muneBtnClick), for: .touchUpInside)
        return button
    }()
    let searchView: MainSearchView = {
        let view = MainSearchView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        return view
    }()
    private lazy var pageVc: VCPageController = {
        let pageVC = VCPageController()
        pageVC.controllers = getControllers() ?? [UIViewController]()
        return pageVC
    }()
    var viewControlers: [UIViewController]?
    var currentIndex: Int = 1
    private let commonViewModel = CommonViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadADView()
        view.addSubview(fakeBarView)
        navigationController?.setNavigationBarHidden(false, animated: true)
        view.backgroundColor = kBarColor
        navigationController?.navigationBar.addSubview(pageView)
        //navigationController?.navigationBar.addSubview(muneBtn)
        layoutPageView()
        
        self.addChild(pageVc)
        view.addSubview(pageVc.view)
        view.addSubview(searchView)
        layoutSubviews()
        pageVc.scrollToIndex = { [weak self] (index) in
            guard let strongSelf = self else { return }
            strongSelf.pageView.scrollTopIndex(index)
            strongSelf.searchView.isModuleVc = index == 0
            strongSelf.currentIndex = index
        }
        pageView.itemClickHandler = { [weak self] (index) in
            guard let strongSelf = self else { return }
            strongSelf.pageVc.clickItemToScroll(index)
            strongSelf.searchView.isModuleVc = index == 0
            strongSelf.currentIndex = index
        }
        searchView.actionHandler = {[weak self] (actionId) in
            if actionId == 1 {
                self?.goSearchVc()
            } else if actionId == 2 {  // 历史观看
                self?.goHistory()
            } else if actionId == 3 {  // 切换 最新 <-> 最热
                self?.refreshWithSort()
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func refreshWithSort() {
        if viewControlers != nil && viewControlers!.count > currentIndex {
            (viewControlers![currentIndex] as! VideoListController).loadFirstPage()
        }
    }
    
    private func getControllers() -> [UIViewController]? {
        guard let typeModels = MainType.share().typeModels else { return nil }
        if typeModels.count == 0 { return nil }
        var controllers = [UIViewController]()
        for model in typeModels {
            if (model.id ?? 0) < 0 { // 推荐 模块
                let moduleVc = ModulesController()
                controllers.append(moduleVc)
            } else { // 其他列表
                let listVc = VideoListController()
                listVc.typeModel = model
                controllers.append(listVc)
            }
        }
        viewControlers = controllers
        return controllers
    }
    
    /// 版本信息
    private func getVersionInfo() {
        loadAppInfoDataCallBackHandler()
        loadUpdateInfo()
    }
    
    private func goSearchVc() {
        let search = SearchMainController()
        navigationController?.pushViewController(search, animated: true)
    }
 
    private func goHistory() {
        let hisvc = CollectedLsController()
        hisvc.isHistory = true
        navigationController?.pushViewController(hisvc, animated: true)
    }
    
    @objc private func muneBtnClick() {
        
    }
}

// MARK: - 版本信息
private extension MainVedioViewController {
    
    // 版本跟新
    private func loadUpdateInfo() {
        commonViewModel.checkUpdateInfo()
    }
    
    // MARK: - 版本信息请求回调
    private func loadAppInfoDataCallBackHandler() {
        commonViewModel.loadCheckVersionInfoApiSuccess = { [weak self] in
            ///判断是否当前为最新版本
            guard let strongSelf = self else { return }
            if strongSelf.commonViewModel.versionInfo != nil {
                self?.loadUpdateInfoSuccess(strongSelf.commonViewModel.versionInfo!)
            }
            strongSelf.checkAppVersionInfo()
        }
    }
    
    @objc func checkAppVersionInfo() {
        let appInfo = AppInfo.share()
        guard let versionNew = appInfo.appInfo?.version_code else { return }
        guard let numVersionNew = versionNew.removeAllPoints() else { return }
        guard let numVersionCurrent = getCurrentAppVersion().removeAllPoints() else { return }
        if Int(numVersionNew) != nil && Int(numVersionCurrent) != nil && Int(numVersionNew)! > Int(numVersionCurrent)! {
            let controller = AlertManagerController()
            controller.alertType = .updateInfo
            controller.modalPresentationStyle = .overCurrentContext
            controller.commitActionHandler = { [weak self] in
                self?.goAndUpdate(String(format: "%@", appInfo.appInfo?.package_path ?? ConstValue.kAppDownLoadLoadUrl))
            }
            controller.cancleActionHandler = { [weak self] in
                self?.goAndUpdate(String(format: "%@", appInfo.appInfo?.official_url ?? ConstValue.kAppDownLoadLoadUrl))
            }
            self.modalPresentationStyle = .currentContext
            self.tabBarController?.present(controller, animated: false, completion: nil)
        } else {
            showHelpAlert()
        }
    }
    
    func loadUpdateInfoSuccess(_ model: AppVersionInfo) {
        setAppInfoModel(model)
        saveDownLoadUrlString(model.share_url)
        saveShareUrlString(model.share_url)
    }
    
    func setAppInfoModel(_ model: AppVersionInfo) {
        AppInfo.share().appInfo = model
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
    
    /// 保存下载地址
    func saveDownLoadUrlString(_ downloadUrl: String?) {
        if downloadUrl != nil && !downloadUrl!.isEmpty {
            UserDefaults.standard.set(downloadUrl!, forKey: UserDefaults.kAppDownLoadUrl)
        }
    }
    
    /// 保存分享地址
    func saveShareUrlString(_ shareUrl: String?) {
        if shareUrl != nil && !shareUrl!.isEmpty {
            UserDefaults.standard.set(shareUrl!, forKey: UserDefaults.kAppShareUrl)
        }
    }
}

// MARK: - 新手alert + 助手Alert
private extension MainVedioViewController {
    
    /// 提示新手奖励
    func showNewUserSatisfyAlert() {
        let isShow = UserDefaults.standard.bool(forKey: UserDefaults.knewUserSatisfiedShow)
        if !isShow {
            let alertController = AlertManagerController(newUserCard: [AlertManagerController.kWelfCardString : "阅读卷 +\(UserModel.share().userInfo?.day_count ?? "5") ", AlertManagerController.kWelfCardTiem : "快去个人中心查看吧。"])
            alertController.view.backgroundColor = UIColor.clear
            alertController.modalPresentationStyle = .overCurrentContext
            alertController.commitActionHandler = {
                UserDefaults.standard.set(true, forKey: UserDefaults.knewUserSatisfiedShow)
                self.getVersionInfo()
            }
            alertController.closeActionHandler = {
                UserDefaults.standard.set(true, forKey: UserDefaults.knewUserSatisfiedShow)
                self.getVersionInfo()
            }
            self.modalPresentationStyle = .currentContext
            self.providesPresentationContextTransitionStyle = true
            self.definesPresentationContext = true
            self.tabBarController?.present(alertController, animated: false, completion: nil)
        } else {
            self.getVersionInfo()
        }
        
    }
    
    private func showHelpAlert() {
        let alert = UIAlertController.init(title: "提示(已保存点忽略)", message: "近期苹果大量封杀成人视频,保存应用中心，以便您找回爱私欲", preferredStyle: .alert)
        let actionOk = UIAlertAction.init(title: "保存应用中心", style: .default) { (action) in
            self.goAndUpdate(AppInfo.share().appInfo?.help_url)
        }
        let cancle = UIAlertAction.init(title: "忽略", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        alert.addAction(cancle)
        self.present(alert, animated: false, completion: nil)
    }
}


// MARK: - 广告展示 + 下载
extension MainVedioViewController {
    func loadADView() {
        if let currentAd = SwiftAdFileConfig.readCurrentAdModel() { // 1. 检测 本地 有没有 广告
            showAdView(currentAd)
        } else {
            getVersionInfo() //showNewUserSatisfyAlert()
        }
        loadAdAPI()
    }
    
    func loadAdAPI() {
//        let adfile = AdFileModel(adUrl: "https://github.com/shiliujiejie/adResource/raw/master/advertiseMP4.gif", adType: .gif, adHerfUrl: "http://www.baidu.com", adId: 0, customSaveKey: nil)
//        /// 下载广告, 下次启动展示
//        SwiftAdFileConfig.downLoadAdData(adfile)
        commonViewModel.loadAdInfo()
    }
    
    func showAdView(_ adModel: AdFileModel) {
        let advc = SwiftAdView(config: configModel(), adModel: adModel)
        self.present(advc, animated: false, completion: nil)
        advc.adClickHandler = { (adModel) in
            let webvc = WebKitController(url: URL(string: adModel.adHerfUrl ?? "")!)
            self.navigationController?.pushViewController(webvc, animated: true)
        }
        advc.skipBtnClickHandler = {
            self.showNewUserSatisfyAlert()
        }
    }
    
    /// 广告页面属性 - 配置
    func configModel() -> SwiftAdFileConfig {
        let config = SwiftAdFileConfig()
        config.duration = 5
        config.skipBtnBackgroundColor = kAppDefaultColor
        config.skipBtnTitleColor = UIColor.white
        config.autoDissMiss = false
        config.videoGravity = .resizeAspectFill
        return config
    }
}

// MARK: - 被挤掉提示
extension MainVedioViewController {
    
    private func addKickedOutNotif() {
        NotificationCenter.default.addObserver(self, selector: #selector(didUserBeenKickedOut), name: Notification.Name.kUserBeenKickedOutNotification, object: nil)
    }
    // 掉线提醒
    @objc private func didUserBeenKickedOut() {
        DLog("didUserBeenKickedOut  ===== AdController")
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.window?.rootViewController?.showDialog(title: "被挤掉提示", message: XSAlertMessages.kNotAvailTokenAlertMsg, okTitle: "确认", cancelTitle: "取消", okHandler: {
                DLog("跳转到官网")
            }, cancelHandler: nil)
        }
    }
}


// MARK: - Layout
private extension MainVedioViewController {
    
    func layoutSubviews() {
        layoutFakeBarView()
        layoutSearchView()
        layoutPageVcview()
    }
    
    func layoutFakeBarView(){
        fakeBarView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(-safeAreaTopHeight)
            make.height.equalTo(safeAreaTopHeight)
        }
    }
    func layoutPageVcview() {
        pageVc.view.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(0)
            make.top.equalTo(0)
        }
    }
    
    func layoutPageView() {
        pageView.snp.makeConstraints { (make) in
            make.leading.equalTo(5)
            make.trailing.equalTo(-5)
            make.top.equalTo(0)
            make.height.equalTo(44)
        }
       // layoutMuneButton()
    }
    
    func layoutMuneButton() {
        muneBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-5)
            make.top.equalTo(5)
            make.width.height.equalTo(34)
        }
    }
    
    func layoutSearchView() {
        searchView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(44)
        }
    }
}
