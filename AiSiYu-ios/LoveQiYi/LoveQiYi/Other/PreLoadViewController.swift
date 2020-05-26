//
//  PreLoadViewController.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit
import NicooNetwork

class PreLoadViewController: UIViewController {

    private lazy var screenImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "ScreenShow"))
        image.contentMode = .scaleToFill
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private let  tipImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "tipScreen"))
        image.contentMode = .scaleToFill
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private let channelVideoModel = ChannelViewModel()
    private let commonViewModel = CommonViewModel()
    private let userInfoViewModel = AcountViewModel()
    private let mainTypeViewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        NotificationCenter.default.addObserver(self, selector: #selector(didUserBeenKickedOut), name: Notification.Name.kUserBeenKickedOutNotification, object: nil)
        view.addSubview(screenImage)
        view.addSubview(tipImage)
        
        layoutPageSubviews()

        /// 启动图
        loadScreenData()

        if ConstValue.kIsDevServer {
            ProdValue.prod().kProdUrlBase = XSVideoService.appServerPath
            self.getModules()
        } else {
            channelCallback()
            self.loadChannels()
        }
    }
    
    private func loadScreenData() {
        guard let adModel = SwiftAdFileConfig.readCurrentAdModel(UserDefaults.kReloadImg) else { return }
        tipImage.isHidden = true
        if let imageData = SwiftAdFileConfig.getAdDataFromLocal(adModel.adUrl) {
            let type = UIImage.checkImageDataType(data: imageData)
            if type == .gif {
                self.screenImage.image = UIImage.gif(data: imageData)
            } else {
                self.screenImage.image = UIImage(data: imageData)
            }
        } else {
            self.screenImage.image = UIImage.image(url: adModel.adUrl)
        }
    }
    
    /// 线程延时
    private func sleep(_ time: Double,mainCall:@escaping ()->()) {
        let time = DispatchTime.now() + .milliseconds(Int(time * 1000))
        DispatchQueue.main.asyncAfter(deadline: time) {
            mainCall()
        }
    }
}

// MARK: - 请求线路列表
extension PreLoadViewController {
    /// 请求线路列表
    private func loadChannels() {
        if (UIApplication.shared.delegate as? AppDelegate) != nil {
            XSProgressHUD.showCustomAnimation(msg: "正在检测最优线路...", onView: self.view, imageNames: nil, bgColor: UIColor(white: 0, alpha: 0.5), UIColor.white, animated: false)
            self.sleep(2.0) {
                self.channelVideoModel.loadChannel()
            }
        }
    }
    /// 线路检测回调
    private func channelCallback() {
        channelVideoModel.channelCallback = { [weak self] in
            guard let strongSelf = self else { return }
            let channels = strongSelf.channelVideoModel.timesModels
            if channels.count > 0 {
                ProdValue.prod().kProdUrlBase = channels[0].mothUrl
                strongSelf.getModules()
            } else {
                strongSelf.showChannelFailed()
            }
        }
    }
    /// 线路获取失败
    private func showChannelFailed() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.window?.rootViewController?.showDialog(title: "线路繁忙", message: "数据加载异常，请检查网络，或稍后再试。", okTitle: "重新连接", cancelTitle: "取消", okHandler: {
                self.loadChannels()
            }, cancelHandler: nil)
        }
    }
}

// MARK: - register
extension PreLoadViewController {
    
    private func getModules() {
        deviceRegisterCallBackHandler()
        /// 设备号注册
        self.registerDevice()
    }
    
    /// 设备号注册, 已注册，拉用户信息
    func registerDevice() {
        if let token = UserDefaults.standard.string(forKey: UserDefaults.kUserToken) {
            var user = UserInfoModel()
            user.api_token = token
            UserModel.share().userInfo = user
            userInfoViewModel.loadUserInfo()
        } else {
            commonViewModel.registerDevice()
        }
    }
    
    // MARK: - 设备号注册回调
    private func deviceRegisterCallBackHandler() {
        commonViewModel.loadDeviceRegisterSuccess = { [weak self] in
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                XSProgressHUD.hide(for: delegate.window!, animated: true)
            }
            self?.loadMainTypeDatas()
        }
        commonViewModel.loadDeviceRegisterFail = {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                XSProgressHUD.hide(for: delegate.window!, animated: true)
            }
            XSAlert.show(type: .error, text: "您的设备注册失败,请在检查网络后，重新打开APP.")
        }
        userInfoViewModel.loadUserInfoSuccessHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loadMainTypeDatas()
        }
    }
}

// MARK: - 请求首页大分类列表
private extension PreLoadViewController {
    
    func loadMainTypeDatas() {
        loadMainTypesCallBack()
        mainTypeViewModel.loadMainTypes()
    }
    
    func loadMainTypesCallBack() {
        mainTypeViewModel.loadMainTypesSuccess = { [weak self] in
            self?.loadGuestureCover()
        }
    }
    
}

// MARK: - 手势密码
private extension PreLoadViewController {
    
    func loadGuestureCover() {
        if GYCircleConst.getGestureWithKey(gestureFinalSaveKey) != nil {
            let gestureVC = GestureViewController()
            // 登录成功， 进入抖音
            gestureVC.lockLoginSuccess = {
                self.configTabBar()
            }
            gestureVC.type = GestureViewControllerType.login
            gestureVC.navBarHiden = true
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.window?.rootViewController = gestureVC
            }
        } else {
            print("暂未设置手势密码,直接进入App")
            configTabBar()
        }
    }
}

extension PreLoadViewController {
    private func configTabBar() {
        
        let tabBarNormalImages = ["main_N","hot_N","specil_N","task_N","acount_N"]
        let tabBarSelectedImages = ["main_S","hot_S","specil_S","task_S","acount_S"]
        let tabBarTitles = ["首页","热点","系列","任务","我的"]
        let rootModel1 = RootTabBarModel.init(title: tabBarTitles[0], imageNormal: tabBarNormalImages[0], imageSelected: tabBarSelectedImages[0], controller: MainVedioViewController())
        
        let rootModel2 = RootTabBarModel.init(title: tabBarTitles[1], imageNormal: tabBarNormalImages[1], imageSelected: tabBarSelectedImages[1], controller: HotMainController())
        
        let rootModel3 = RootTabBarModel.init(title: tabBarTitles[2], imageNormal: tabBarNormalImages[2], imageSelected: tabBarSelectedImages[2], controller: SeriesViewController())
        let rootModel4 = RootTabBarModel.init(title: tabBarTitles[3], imageNormal: tabBarNormalImages[3], imageSelected: tabBarSelectedImages[3], controller: TaskViewController())
        let rootModel5 = RootTabBarModel.init(title: tabBarTitles[4], imageNormal: tabBarNormalImages[4], imageSelected: tabBarSelectedImages[4], controller: AcountController())
        let tabBars =  [rootModel1,rootModel2,rootModel3, rootModel4, rootModel5]
        let tabbarVC = RootTabBarViewController.init(config: getConfigModel(), tabBars: tabBars)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.window?.rootViewController = tabbarVC
        }
    }
    
    /// 定制 tabbar 和 navgationBar 样式
    ///
    /// - Returns: RootTabBarConfig 对象
    private func getConfigModel() -> RootTabBarConfig {
        let rootConfig = RootTabBarConfig()
        rootConfig.tabBarStyle = .normal
        
        /// 是否 点击  动画
        rootConfig.isAnimation = true
        
        /// 点击 动画类型 scaleDown：小-大     rotation： 旋转
        rootConfig.animation = .scaleDown
        
        /// 中心按钮j 上浮高度
        rootConfig.centerInsetUp = 0
        
        rootConfig.tabBarBackgroundColor = UIColor(white: 0.98, alpha: 0.99)
        
        rootConfig.navBarBackgroundColor = kBarColor
        
        rootConfig.tabBarShadowColor = UIColor.groupTableViewBackground
        rootConfig.titleColorNormal = UIColor.darkText
        rootConfig.titleColorSelected = UIColor(r: 11, g: 190, b: 6)
        rootConfig.navBarshadowColor = UIColor.clear
        
        // rootConfig.centerViewController = PresentController()
        
        return rootConfig
    }
}

// MARK: - layout
private extension PreLoadViewController {
    func layoutPageSubviews() {
        layoutScreenImage()
        layoutTipsimage()
    }
    
    func layoutScreenImage() {
        screenImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    func layoutTipsimage() {
        tipImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - 启动页也可以 换 广告
extension PreLoadViewController {
    func loadADView() {
        if let currentAd = SwiftAdFileConfig.readCurrentAdModel(UserDefaults.kReloadImg) { // 1. 检测 本地 有没有 广告
            showAdView(currentAd)
        }
    }
    /// 展示默认 广告， 或者不展示广告
    func showDefaultAd() {
        /// image
        //let fileImage = Bundle.main.path(forResource: "guide02", ofType: "png") ?? ""
        /// gif
        let fileGif = Bundle.main.path(forResource: "Screen", ofType: "png") ?? ""
        /// 视频
        // let fileVideo = Bundle.main.path(forResource: "1", ofType: "mp4") ?? ""
        
        let admodel = AdFileModel(adUrl: fileGif, adType: .image, adHerfUrl: "", adId: 1, customSaveKey: nil)
        
        showAdView(admodel)
    }
    
    func showAdView(_ adModel: AdFileModel) {
        let advc = SwiftAdView(config: configModel(), adModel: adModel)
        self.addChild(advc)
        view.addSubview(advc.view)
        advc.skipBtnClickHandler = {
            
        }
        advc.adClickHandler = { (adModel) in
            let webvc = WebKitController(url: URL(string: adModel.adHerfUrl ?? "")!)
            self.navigationController?.pushViewController(webvc, animated: true)
        }
    }
    
    /// 广告页面属性 - 配置
    func configModel() -> SwiftAdFileConfig {
        let config = SwiftAdFileConfig()
        config.duration = 3
        config.skipBtnBackgroundColor = UIColor.clear
        config.skipBtnTitleColor = UIColor.clear
        config.autoDissMiss = false
        config.videoGravity = .resizeAspectFill
        return config
    }
}

// MARK: - 被挤掉提示
extension PreLoadViewController {
    
    @objc private func didUserBeenKickedOut() {
        DLog("didUserBeenKickedOut  ===== AdController")
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.window?.rootViewController?.showDialog(title: "被挤掉提示", message: XSAlertMessages.kNotAvailTokenAlertMsg, okTitle: "确认", cancelTitle: "取消", okHandler: {
                DLog("跳转到官网")
            }, cancelHandler: nil)
        }
    }
}
