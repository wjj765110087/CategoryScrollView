//
//  MacroDefine.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import Foundation
import UIKit

//MARK: 屏幕size rect width height
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let statusBarHeight = UIApplication.shared.statusBarFrame.height
let screenFrame: CGRect = UIScreen.main.bounds
let tabBarHeight: CGFloat = (screenHeight >= 812.0 && UIDevice.current.model == "iPhone" ? 83 : 49)

let safeAreaTopHeight: CGFloat = (screenHeight >= 812.0 && UIDevice.current.model == "iPhone" ? 88 : 64)
let safeAreaBottomHeight: CGFloat = (screenHeight >= 812.0 && UIDevice.current.model == "iPhone"  ? 34 : 0)

var isIphoneX: Bool {
    return UI_USER_INTERFACE_IDIOM() == .phone
        && (max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 812
            || max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 896)
}

//MARK: 颜色设置
// MARK: ------  App 主体颜色
public let kAppDefaultColor = UIColor(red: 11/255.0, green: 190/255.0, blue: 6/255.0, alpha: 1)
public let kAppShadowColor = UIColor(red: 210/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1)
public let kAppDefaultTitleColor = UIColor(red: 11/255.0, green: 190/255.0, blue: 6/255.0, alpha: 1)
public let kAppSepLineColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
public let kBarColor = UIColor(red: 47/255.0, green: 47/255.0, blue: 49/255.0, alpha: 1.0)
public let kVcViewColor = UIColor(red: 47/255.0, green: 24/255.0, blue: 36/255.0, alpha: 0.99)
public let kIconBgColor = UIColor(red: 60/255.0 , green: 60/255.0 , blue: 72/255.0, alpha: 0.90)


// MARK: ------  域名单利 （用于访问APP中所有的数据APi）
public class ProdValue {
    static private let prodValue: ProdValue = ProdValue()
    class func prod() -> ProdValue {
        return prodValue
    }
    public var kProdUrlBase: String?
}

// MARK: - 全局静态常量
public struct ConstValue {
    /// 本appurlscheme
    public static let kAppScheme = "LoveQiYi"
    
    /// 用户钥匙串唯一标识 key
    public static let kUserKeychainKey: String = {
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: filePath!)
        return dictionary!["CustomKeychainKey"] as! String
    }()
    // MARK: ------ 接口数据加密开关 + 密钥
    /// 图片解密key
    public static let kImageDataDecryptKey: String = {
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: filePath!)
        return dictionary!["CustomImageDataDecryptKey"] as! String
    }()
    /// 接口数据加密解密Key
    public static let kApiEncryptKey: String = {
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: filePath!)
        return dictionary!["CustomApiEncryptKey"] as! String
    }()
    /// 是否是Dev 环境。
    public static let kIsDevServer: Bool = {
        return false
    }()
    
    /// 是否对接口加密的  开关 （如果Dev需要加密，直接 return true）
    public static let kIsEncryptoApi: Bool = {
        return !ConstValue.kIsDevServer
    }()
    
    /// app 网页下载地址
    public static let kAppDownLoadLoadUrl = "http://isiyu.me"
    
    // MARK: App Produrl (此Url仅用于请求有效域名)
    
    // MARK: ------  ServiceIdentifier （服务Key）
    /// app 数据接口服务名 （正式服）
    public static let kXSVideoService = "XSVideoService"
    /// 域名请求服务名  （域名服）
    public static let kAppProdService = "AppProdService"
    
    // MARK: ------ 本地数据库名： db name
    /// 本地数据库名称
    public static let kXSVideoLocalDBName = "XSVideoLocal.db"
    /// 下载进度记录本地数据表
    public static let kVideoDownLoadListTable = "VideoDownLoadListTable"
    
    // MARK: ------ 占位图片
    /// 竖屏展位图
    public static let kVerticalPHImage = UIImage(named: "PV")
    /// 横屏展位图
    public static let kHorizontalPHImage = UIImage(named: "PH")
    /// 默认头像
    public static let kDefaultHeader = UIImage(named: "PIc")
    /// 圆形展位图
    public static let kTopicTypeHolder = UIImage(named: "PIc")
    
    // MARK: ------ Refresh Image + FontSize  Loading Image
    public static let kRefreshLableFont = UIFont.systemFont(ofSize: 12.0)
    public static let refreshImageNames = ["refreshing_1","refreshing_2","refreshing_3","refreshing_4","refreshing_5","refreshing_6","refreshing_7","refreshing_8"]
    public static let loadingImageNames = ["laohu1","laohu2","laohu3","laohu14","laohu5","laohu6","laohu7","laohu8","laohu9","laohu10","laohu11","laohu12","laohu13","laohu14","laohu15","laohu16","laohu17","laohu18","laohu19","laohu20","laohu21","laohu22","laohu23","laohu24","laohu25","laohu26","laohu27"]
    
}


// MARK: ------ 观看历史本地数据库表 参数名
public struct WatchedVideoListParams {
    public static let kVideoId = "videoId"
    public static let kVideoCover_Path = "Cover_Path"
    public static let kVideoName = "videoName"
    public static let kVideoIntrol = "videoIntrol"
    public static let kVideoWatchedPoint = "watchPoint"
}

// MARK: - Notificaiton name
public extension Notification.Name {
    /// 登录成功的通知
    static let kUserLoginSuccessfully = Notification.Name("kUserLoginSuccessfully")
    /// 在切换定位信息后，需要某些地方收到通知，并重新获取数据
    static let kLocationHaveSwitchedNotification = Notification.Name("locationHaveSwitchedNotification")
    /// 账户信息变动的通知
    static let kUserBasicalInformationChanged = Notification.Name("kUserBasicalInformationChanged")
    /// 用户别踢下线或者token失效的回调
    static let kUserBeenKickedOutNotification = Notification.Name("kUserBeenKickedOutNotification")
    /// 分享信息更新
    static let kShareInfoUpdateNotification = Notification.Name("kShareInfoUpdateNotification")
    /// 首页星期选择发送
    static let kUpdateWeekNotification = Notification.Name("kUpdateWeekNotification")
    /// 任务列表是否需要刷新
    static let kLoadTaskListNotification = Notification.Name("kLoadTaskListNotification")
    /// 书架刷新数据
    static let kBookShelfRefreshNotification = Notification.Name("kBookShelfRefreshNotification")
}

// MARK: - UserDefaults Key
public extension UserDefaults {
    /// 本地存储vip类型key
    static let kVipCardLevel = "saveVipLevel"
    /// 手势密码是否开启
    static let kGestureLock = "GestureLock"
    /// 是否是首次进入APP
    static let kIsNotFirstIn = "IsFirstIn"
    ///  当日是否已经领过观影奖励 bool 类型
    static let kSatisfyKey = "Satisfy"
    ///  当日累加观影时长 Int
    static let kWatchedTime = "TimeLogin"
    ///  最后一次观影的日期 String
    static let kLastTimeDay = "LastTimeDay"
    ///  [String: Any]类型  存放单日观影时长， 当日时间，
    static let kSatisfyInfo = "SatisfyInfo"
    ///  上一个用户的用户名
    static let kUserAcountPhone = "AcountPhone"
    /// 上一个 登录的用户token
    static let kUserToken = "UserLastToken"
    ///  上一个登录用户的邀请码
    static let kUserInviteCode = "UserInviteCode"
    /// 搜索历史 (数组，长度为9)
    static let kSearchHistory = "SearchHistoryList"
    
    /// APP安装包地址
    static let kAppDownLoadUrl = "AppDownLoadUrl"
    /// App分享地址（）
    static let kAppShareUrl = "AppShareUrl"
    /// 是否提示过新用户奖励
    static let knewUserSatisfiedShow = "IsSatisfyAlertShow"
    /// 启动图
    static let kReloadImg = "kReloadImg"
    static let kReloadHerf = "kReloadHerf"
    /// 广告数据是否有
    static let kAdDataUrl = "AdDataUrl"
    /// 广告跳转链接
    static let kAdHrefUrl = "ADHref"
    /// 下载列表的IdS
    static let kDownloadIds = "DownloadIds"
    /// 允许下一话直接购买的 漫画Id 数组
    static let kNextBuyAutoIds = "NextBuyAutoIds"
}


/// 栈顶控制器
var topVC: UIViewController? {
    var resultVC: UIViewController?
    resultVC = _topVC(UIApplication.shared.keyWindow?.rootViewController)
    while resultVC?.presentedViewController != nil {
        resultVC = _topVC(resultVC?.presentedViewController)
    }
    return resultVC
}

private  func _topVC(_ vc: UIViewController?) -> UIViewController? {
    if vc is UINavigationController {
        return _topVC((vc as? UINavigationController)?.topViewController)
    } else if vc is UITabBarController {
        return _topVC((vc as? UITabBarController)?.selectedViewController)
    } else {
        return vc
    }
}

//MARK: 自定义打印
func DLog<T>(_ message: T , file: String = #file, function: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):funciton:\(function):line:\(lineNumber)]- \(message)")
    #endif
}

// MARK: - AppKey
public enum APPKeys {
    /// WeChat APPid
    public static let kWeChatAppId = ""
    /// 支付宝appid
    public static let kAlipayAppId = ""
    /// QQ appid
    public static let kQQAppId = ""
    /// 高的地图appid
    public static let kAMAppKey = ""
    /// 友盟
    public static let kUMengAppKey = ""
    public static let kUMengChannelId = ""
    /// sina
    public static let kSinaAppkey = ""
    public static let kSinaAppSecurity = ""
}
