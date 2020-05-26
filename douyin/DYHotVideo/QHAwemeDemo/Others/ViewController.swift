

import UIKit
import NicooNetwork

/// 用于做进入App前的一些操作： 1.展示GIF动画 1.5 秒。 2.添加广告 3. 同时请求公共y域名。 4 。公公域名请求成功才进入app. 否则停留在广告页

class ViewController: UIViewController {
    
    private lazy var screenImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "screenCan")
        image.contentMode = .scaleAspectFill
        return image
    }()
    /// 公共域名请求
    private lazy var appProdApi: XSVideoProdAPI = {
        let prodApi = XSVideoProdAPI()
        prodApi.delegate = self
        prodApi.paramSource = self
        return prodApi
    }()
    /// 系统公告请求
    private lazy var systemMsgApi: AppMessageApi = {
        let msgApi = AppMessageApi()
        msgApi.delegate = self
        msgApi.paramSource = self
        return msgApi
    }()
    /// 服务器线路列表
    private lazy var videoChannelApi: VideoChannelApi = {
        let channelApi = VideoChannelApi()
        channelApi.delegate = self
        channelApi.paramSource = self
        return channelApi
    }()
    private let registerViewModel = RegisterLoginViewModel()
    
    private let userInfoViewModel = UserInfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        NotificationCenter.default.addObserver(self, selector: #selector(didUserBeenKickedOut), name: Notification.Name.kUserBeenKickedOutNotification, object: nil)
        view.addSubview(screenImage)
        layoutPageSubviews()
        loadAppInfoDataCallBackHandler()
        deviceRegisterCallBackHandler()
        /*  ----------------------------- 1.展示GIF动画 1.5 秒 --------------------*/
       // playGif()
        /*  ----------------------------- 2.添加广告 --------------------*/
        // 如果有广告，先加载广告后，再验证手势密"
        self.sleep(0.5) {
            self.loadAppProdUrl()
        }
    }
    
    // 掉线提醒
    @objc private func didUserBeenKickedOut() {
        DLog("didUserBeenKickedOut  ===== AdController")
        if let delegate = UIApplication.shared.delegate as? AppDelegate, delegate.window?.rootViewController is AdvertiseController || delegate.window?.rootViewController is ViewController {
            delegate.window?.rootViewController?.showDialog(title: "被挤掉提示", message: XSAlertMessages.kNotAvailTokenAlertMsg, okTitle: "确认", cancelTitle: "取消", okHandler: {
                DLog("跳转到官网")
            }, cancelHandler: nil)
        }
    }
    
    /// 请求公共域名
    private func loadAppProdUrl() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate, delegate.window?.rootViewController is AdvertiseController || delegate.window?.rootViewController is ViewController {
            XSProgressHUD.showCycleProgress(msg: "正在检测线路...", onView: delegate.window!, animated: true)
            let _ = appProdApi.loadData()
        }
    }
    
    /// 请求系统公告
    private func loadSystemMsg() {
        _ = systemMsgApi.loadData()
    }
    
    /// 请求线路列表
    private func loadChannels() {
        _ = videoChannelApi.loadData()
    }
    
    private func loadUpdateInfo() {
        registerViewModel.checkUpdateInfo()
    }
    
    /// 版本信息请求回调
    private func loadAppInfoDataCallBackHandler() {
        registerViewModel.loadCheckVersionInfoApiSuccess = { [weak self] in
            ///判断是否当前为最新版本
            guard let strongSelf = self else { return }
            if strongSelf.registerViewModel.versionInfo != nil {
                self?.loadUpdateInfoSuccess(strongSelf.registerViewModel.versionInfo!)
            }
        }
        userInfoViewModel.loadUserInfoSuccessHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loadSystemMsg()
            strongSelf.loadChannels()
            // 存下用户的初始 VIP级别
            UserDefaults.standard.set(UserModel.share().userInfo?.vip_id ?? 1, forKey: UserDefaults.kVipCardLevel)
        }
    }
    
    private func deviceRegisterCallBackHandler() {
        registerViewModel.loadDeviceRegisterSuccess = { [weak self] in
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                XSProgressHUD.hide(for: delegate.window!, animated: true)
            }
            // 存下用户的初始 VIP级别
            UserDefaults.standard.set(UserModel.share().userInfo?.vip_id ?? 1, forKey: UserDefaults.kVipCardLevel)
            self?.loadSystemMsg()
            self?.loadChannels()
        }
        registerViewModel.loadDeviceRegisterFail = {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                XSProgressHUD.hide(for: delegate.window!, animated: true)
            }
            XSAlert.show(type: .error, text: "设备注册失败，请重新打开APP.")
        }
    }
    
    /// 加手势锁
    private func addGestureLock() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate, delegate.window?.rootViewController is AdvertiseController || delegate.window?.rootViewController is ViewController {
            if GYCircleConst.getGestureWithKey(gestureFinalSaveKey) != nil {
                let gestureVC = GestureViewController()
                // 登录成功， 进入抖音
                gestureVC.lockLoginSuccess = {
                    self.setVideoRootVC()
                }
                gestureVC.type = GestureViewControllerType.login
                gestureVC.navBarHiden = true
                if let delegate = UIApplication.shared.delegate as? AppDelegate {
                    delegate.window?.rootViewController = gestureVC
                }
            } else {
                DLog("暂未设置手势密码,直接进入App")
                setVideoRootVC()
            }
        }
    }
    
    /// 设置抖音模块为 根控制器
    private func setVideoRootVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "QHNavigationController") as! QHNavigationController
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.window?.rootViewController = viewController
            if let navigationC =  delegate.window?.rootViewController as? QHNavigationController {
                navigationC.addGesturePush()
            }
        }
    }
    
    /// 加载广告
    private func loadAdDataOrDownload() {
        // 第一次进入的新用户不弹广告, 没有缓存过广告图片不展示
        if let adDataUrl = UserDefaults.standard.string(forKey: UserDefaults.kAdDataUrl), !adDataUrl.isEmpty {
            // 开屏广告
            let adVC = AdvertiseController()
            adVC.adUrl = adDataUrl
            adVC.view.backgroundColor = ConstValue.kVcViewColor
            adVC.adClickOrShowToEndHandler = {
                /// 校验手势锁
                self.addGestureLock()
            }
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.window?.rootViewController = adVC
            }
        } else {
            /// 校验手势锁
            addGestureLock()
        }
    }
    
    /// 设备号注册
    func registerDevice() {
        // 测试卡片升级
        if let token = UserDefaults.standard.string(forKey: UserDefaults.kUserToken) {
            let user = UserInfoModel()
            user.api_token = token
            UserModel.share().userInfo = user
            userInfoViewModel.loadUserInfo()
        } else {
            registerViewModel.registerDevice()
        }
    }
}

// MARK: - 保存版本信息
private extension ViewController {
    
    func loadUpdateInfoSuccess(_ model: AppVersionInfo) {
        setAppInfoModel(model)
        saveDownLoadUrlString(model.share_url)
        saveShareUrlString(model.share_url)
        /// 设备号注册
        self.registerDevice()
    }
    
    func setAppInfoModel(_ model: AppVersionInfo) {
        AppInfo.share().id = model.id
        AppInfo.share().extend = model.extend
        AppInfo.share().title = model.title
        AppInfo.share().remark = model.remark
        AppInfo.share().version_code = model.version_code
        AppInfo.share().package_path = model.package_path
        AppInfo.share().share_url = model.share_url
        AppInfo.share().share_text = model.share_text
        AppInfo.share().platform = model.platform
        AppInfo.share().potato_invite_link = model.potato_invite_link
        AppInfo.share().official_url = model.official_url
        AppInfo.share().force = model.force
        AppInfo.share().updated_at = model.updated_at
        AppInfo.share().static_url = model.static_url
        AppInfo.share().file_upload_url = model.file_upload_url
        AppInfo.share().help_url = model.help_url
        AppInfo.share().wallet_url = model.wallet_url
        AppInfo.share().app_rule = model.app_rule
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

// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension ViewController: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is XSVideoProdAPI {
            if let prodstring = manager.fetchJSONData(AppProdReformer()) as? String {
                /// 域名为空，或 为 dev环境， 使用默认的调试域名
                ProdValue.prod().kProdUrlBase = prodstring.isEmpty ? "" : prodstring
            }
            /// 请求版本信息
            self.loadUpdateInfo()
            ///崩溃上传
            TBUncaughtExceptionHandler.shared.exceptionLogWithData()
        } else if manager is AppMessageApi {
            if let msgList = manager.fetchJSONData(VideoReformer()) as? [SystemMsgModel], msgList.count > 0 {
                SystemMsg.share().systemMsgs = msgList
            }
        } else if manager is VideoChannelApi {
            if let channelList = manager.fetchJSONData(VideoReformer()) as? [VideoChannelModel], channelList.count > 0 {
                //DLog("看看这里走没走 == \(channelList)")
                SystemMsg.share().videoChannels = channelList
                loadAdDataOrDownload()
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        if manager is XSVideoProdAPI {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                XSProgressHUD.hide(for: delegate.window!, animated: true)
            }
            if let delegate = UIApplication.shared.delegate as? AppDelegate, delegate.window?.rootViewController is AdvertiseController || delegate.window?.rootViewController is ViewController {
                delegate.window?.rootViewController?.showDialog(title: "线路繁忙", message: "数据加载异常，请检查网络，或稍后再试。", okTitle: "重新连接", cancelTitle: "取消", okHandler: {
                    self.loadAppProdUrl()
                }, cancelHandler: nil)
            }
        } else if manager is VideoChannelApi {
            loadAdDataOrDownload()
        }
    }
    
}

// MARK: - 开机GIF 动画
private extension ViewController {
    
    /// 线程延时
    private func sleep(_ time: Double,mainCall:@escaping ()->()) {
        let time = DispatchTime.now() + .milliseconds(Int(time * 1000))
        DispatchQueue.main.asyncAfter(deadline: time) {
            mainCall()
        }
    }
    
    func playGif() {
        //1.加载GIF图片，并转化为data类型
        guard let path = Bundle.main.path(forResource: "MOSHED.gif", ofType: nil) else {return}
        
        guard let data = NSData(contentsOfFile: path) else {return}
        //2.从data中读取数据，转换为CGImageSource
        guard let imageSource = CGImageSourceCreateWithData(data, nil) else {return}
        let imageCount = CGImageSourceGetCount(imageSource)
        //3.遍历所有图片
        var images = [UIImage]()
        var totalDuration : TimeInterval = 0
        for i in 0..<imageCount {
            //3.1取出图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else {continue}
            let image = UIImage(cgImage: cgImage)
            images.append(image)
            
            //3.2取出持续时间
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? NSDictionary else {continue}
            guard let gifDict = properties[kCGImagePropertyGIFDictionary]  as? NSDictionary else  {continue}
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else {continue}
            totalDuration += frameDuration.doubleValue
            
        }
        //4.设置imageview的属性
        screenImage.animationImages = images
        screenImage.animationDuration = totalDuration
        screenImage.animationRepeatCount = 100
        //5.开始播放
        screenImage.startAnimating()
    }
}

// MARK: - layout
private extension ViewController {
    
    func layoutPageSubviews() {
        layoutScreenImage()
    }
    
    func layoutScreenImage() {
        screenImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
