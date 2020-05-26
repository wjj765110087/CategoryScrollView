//
//  MacroDefine.swift
//  XSVideo
//
//  Created by pro5 on 2018/11/26.
//  Copyright © 2018年 pro5. All rights reserved.
//

import Foundation
import UIKit

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

// MARK: ------  域名单利 （用于访问APP中所有的数据APi）
public class ProdValue {
    static private let prodValue: ProdValue = ProdValue()
    class func prod() -> ProdValue {
        return prodValue
    }
    public var kProdUrlBase: String? 
}


let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
var statusBarHeight = UIApplication.shared.statusBarFrame.height
let screenFrame: CGRect = UIScreen.main.bounds
let safeAreaTopHeight: CGFloat = (screenHeight >= 812.0 && UIDevice.current.model == "iPhone" ? 88 : 64)
let safeAreaBottomHeight: CGFloat = (screenHeight >= 812.0 && UIDevice.current.model == "iPhone"  ? 30 : 0)

// MARK: - 全局静态常量
public struct ConstValue {
    
    /// 本appurlscheme
    public static let kAppScheme = "xsvideo"
    
    // MARK: ------  屏幕各个模块的 宽高
    public static let kScreenHeight = UIScreen.main.bounds.size.height
    public static let kScreenWdith = UIScreen.main.bounds.size.width
    public static let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
    public static let kNavigationBarHeight = CGFloat(44.0)
    
    // MARK: ------  App 主体颜色
    public static let kAppDefaultColor = UIColor(red: 73/255.0, green: 114/255.0, blue: 255/255.0, alpha: 1)
    public static let kAppDefaultTitleColor = UIColor(red: 63/255.0, green: 103/255.0, blue: 255/255.0, alpha: 1)
    public static let kAppSepLineColor = UIColor(red: 23/255.0, green: 23/255.0, blue: 38/255.0, alpha: 1.0)
    public static let kTitleYelloColor = UIColor(red: 0/255.0, green:123/255.0, blue: 255/255.0, alpha: 1.0)
    /// vc 背景
    public static let kVcViewColor = UIColor(red: 13/255.0, green: 12/255.0, blue: 24/255.0, alpha: 1.0)
    
    public static let kVBgColor = UIColor(red: 17/255.0, green: 13/255.0, blue: 31/255.0, alpha: 1.0)
    
    /// 灰色， 分割线 bar
    public static let kViewLightColor = UIColor(red: 23/255.0, green: 23/255.0, blue: 38/255.0, alpha: 1.0)
    public static let kIconBgColor = UIColor(red: 60/255.0 , green: 60/255.0 , blue: 72/255.0, alpha: 0.90)
    public static let kBgColor = UIColor(red: 30/255.0, green: 31/255.0, blue: 49/255.0, alpha: 1.0)
    
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
    // Ju7WDrEW7FDnggPU - v0-dev  // pq9YCg1#HdlYrGnm - v0 - Inhouse
    // TbYOSw9svntPMjYu - v1- dev   // RlxQyqdL61u3ltYp - v1 -InHouse
    public static let kApiEncryptKey: String = {
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: filePath!)
        return dictionary!["CustomApiEncryptKey"] as! String
    }()
    /// 是否是Dev 环境。
    public static let kIsDevServer: Bool = {
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: filePath!)
        let number = Int(dictionary!["CustomServerPathIsDev"] as! String)!
        return number == 1
    }()
    
    /// 是否对接口加密的  开关 （如果Dev需要加密，直接 return true）
    public static let kIsEncryptoApi: Bool = {
        return !ConstValue.kIsDevServer
    }()
    
    /// 版本控制
    public static let kApiVersion = "api/v2"
    
    /// app 网页下载地址
    public static let kAppDownLoadLoadUrl = "http://5dy.me"
    
    // MARK: App Produrl (此Url仅用于请求有效域名)
    // public static let kXSBaseProdUrl = "http://192.168.0.186:50004"   //"http://domain.olo91.me"
  
    // MARK: ------  ServiceIdentifier （服务Key）
    /// app 数据接口服务名 （正式服）
    public static let kXSVideoService = "XSVideoService"
    /// 域名请求服务名  （域名服）
    public static let kAppProdService = "AppProdService"
    
    // MARK: ------ 本地数据库名： db name
     /// 本地数据库名称
    public static let kXSVideoLocalDBName = "XSVideoLocal.db"
    
    // MARK: ------ 占位图片
    /// 竖屏展位图
    public static let kVerticalPHImage = UIImage(named: "playCellBg")
    /// 横屏展位图
    public static let kHorizontalPHImage = UIImage(named: "placeholderH")
    /// 默认头像
    public static let kDefaultHeader = UIImage(named: "defaultHeader")
    /// 圆形展位图
    public static let kTopicTypeHolder = UIImage(named: "starHeaderPh")
    
    // MARK: ------ Refresh Image + FontSize  Loading Image
    public static let kRefreshLableFont = UIFont.systemFont(ofSize: 12.0)
    public static let loadingImageNames =  ["refreshing_1","refreshing_2","refreshing_3","refreshing_4","refreshing_5","refreshing_6","refreshing_7","refreshing_8"]
    public static let refreshImageNames = ["loading1","loading2","loading3","loading4","loading5","loading6","loading7","loading8","loading9","loading10","loading11","loading12","loading13","loading14","loading15","loading16"]
    
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
    /// 上传本地视频状态切换通知
    static let kUploadVideoStatuCallBackNotification = Notification.Name("kUploadVideoStatuCallBack")
    ///关注,和取消关注的通知
    static let kAttentionVideoUploaderNotification = Notification.Name("kAttentionVideoUploaderNotification")
    ///通知用户主页刷新关注状态的通知
    static let kUserCenterRefreshAttentionStateNotification = Notification.Name("kUserCenterRefreshAttentionStateNotification")
    /// 分享控件消失
    static let kShareActivityDownNotification = Notification.Name("kShareActivityDownNotification")
    ///是否查看对应消息
    static let kLookMessageNotification = Notification.Name("kShareActivityDownNotification")
    ///社区消息红点
    static let kMessageDotNotification = Notification.Name("kMessageDotNotification")
    ///余额发生改变
    static let kBalanceHasChangeNotification = Notification.Name("kBalanceHasChangeNotification")
    ///充值成功
    static let kHasInvestSuccessNotification = Notification.Name("kHasInvestSuccessNotification")
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
    /// 是否保存idCard
    static let kSaveIDCard = "idCarSave"
    
    /// APP安装包地址
    static let kAppDownLoadUrl = "AppDownLoadUrl"
    /// App分享地址（）
    static let kAppShareUrl = "AppShareUrl"
    /// 是否提示过新用户奖励
    static let knewUserSatisfiedShow = "IsSatisfyAlertShow"
    /// 广告数据是否有
    static let kAdDataUrl = "AdDataUrl"
    /// 广告跳转链接
    static let kAdHrefUrl = "ADHref"
    /// 下载列表的IdS
    static let kDownloadIds = "DownloadIds"
    /// 本地上传任务持久化
    static let kUploadTaskParams = "UploadTaskParams"
    static let kUploadTaskImage = "UploadTaskImage"
    static let kUploadTaskStatu = "UploadTaskStatu"
    
    ///崩溃日志
    static let kCrashLog = "CrashLog"
}


// log
public func DLog(_ item: Any, _ file: String = #file,  _ line: Int = #line, _ function: String = #function) {
    #if DEBUG
    print(file + ":\(line):" + function, item)
    #endif
}
