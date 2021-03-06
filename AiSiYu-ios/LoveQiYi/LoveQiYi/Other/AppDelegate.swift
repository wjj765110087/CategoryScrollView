//
//  AppDelegate.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit
import NicooNetwork
import IQKeyboardManagerSwift
import KeychainSwift

public var uuid: String?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        findServer()
        setupKeyBoard()
        // 从钥匙串获取用户信息
        getOrSaveUUID()
        
        // 查询本地下载任务
        DownLoadMannager.share().checkDownLoadingTaskCount()
        
        rootViewController()
        return true
    }
    
    //  整个项目支持竖屏，播放页面需要横屏，导入播放器头文件，添加下面方法：
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?)
        -> UIInterfaceOrientationMask {
            guard let num = NicooPlayerOrietation(rawValue: orientationSupport.rawValue) else {
                return [.portrait]
            }
            return num.getOrientSupports()           // 这里的支持方向，做了组件化的朋友，实际项目中可以考虑用路由去播放器内拿，
    }
    
    /// 程序进入后台，存储当前下载的信息
    func applicationWillResignActive(_ application: UIApplication) {
        if DownLoadMannager.share().videoDownloadModels.count > 0 {
            DownLoadMannager.share().saveDownloadTaskToLocal()
        }
    }
    
    /// service 配置
    private func findServer() {
        NicooServiceFactory.shareInstance.dataSource = self
    }
    
    /// 键盘管理
    private func setupKeyBoard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    /// 保存用户唯一识别码
    private func getOrSaveUUID() {
        UserDefaults.standard.set(true, forKey: UserDefaults.knewUserSatisfiedShow)
        uuid = getUserDeviceFromKeychain()
    }
    
    private func getUserDeviceFromKeychain() -> String? {
        let keychain = KeychainSwift()
        if let acount = keychain.get(ConstValue.kUserKeychainKey) {
            DLog("acountMsg = \(keychain.accessGroup ?? "") acount == \(acount)")
            return acount
        } else {
            let deviceId = UIDevice.current.getIdfv()
            let random = arc4random()%10000
            let randomAddString = String(format: "%@%d", deviceId, random)
            /// 新用户
            UserDefaults.standard.set(false, forKey: UserDefaults.knewUserSatisfiedShow)
            if let deviceCode = randomAddString.md5() {
                DLog("deviceCode === \(deviceCode )")
                keychain.set(deviceCode, forKey: ConstValue.kUserKeychainKey)
                return deviceCode
            } else {
                keychain.set(deviceId, forKey: ConstValue.kUserKeychainKey)
                return deviceId
            }
        }
    }
}

// MARK: - NicooServiceFactoryProtocol
extension AppDelegate: NicooServiceFactoryProtocol {
    
    /// 自定义的服务
    ///
    /// - Returns: 自定义的服务名
    func servicesKindsOfServiceFactory() -> [String : String] {
        return [ConstValue.kXSVideoService: "XSVideoService"]
    }
    
    /// 自定义的服务所在的命名空间 （如果自定义的服务是组件，命名空间就为 服务组件名）
    ///
    /// - Parameter service: 服务名
    /// - Returns: m命名空间
    func namespaceForService(_ service: String) -> String? {
        switch service {
        case ConstValue.kXSVideoService :
            return "LoveQiYi"   // 这里两个服务都在主工程 （如果服务 跟随组件模块， 则需要传入组件所在的命名空间名）
        default:
            return nil
        }
    }
}

extension AppDelegate {
    private func rootViewController() {
        self.window = UIWindow(frame: screenFrame)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = PreLoadViewController()
        window?.makeKeyAndVisible()
    }
}
