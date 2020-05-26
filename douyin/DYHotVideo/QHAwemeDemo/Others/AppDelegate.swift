//
//  AppDelegate.swift
//  QHAwemeDemo
//
//  Created by Anakin chen on 2017/10/15.
//  Copyright © 2017年 AnakinChen Network Technology. All rights reserved.
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
//        // 谷歌统计
//        FirebaseApp.configure()
        // 配置服务（这一步必须先执行， 请求都需要先有服务）
        findServer()
        // 从钥匙串获取用户信息
        getOrSaveUUID()
        // 键盘管理
        setupKeyBoard()
        // 检查本地上传任务
        getLocalUploadTask()
    
        if #available(iOS 11.0, *) {
            UITableView.appearance().estimatedRowHeight = 0
            UITableView.appearance().estimatedSectionFooterHeight = 0
            UITableView.appearance().estimatedSectionHeaderHeight = 0
        }
        #if DEBUG
        Bundle.init(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection10.bundle")?.load()
        #endif
        return true
    }
    
//    //  整个项目支持竖屏，播放页面需要横屏，导入播放器头文件，添加下面方法：
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?)
//        -> UIInterfaceOrientationMask {
//            guard let num = NicooPlayerOrietation(rawValue: orientationSupport.rawValue) else {
//                return [.portrait]
//            }
//            return num.getOrientSupports()           // 这里的支持方向，做了组件化的朋友，实际项目中可以考虑用路由去播放器内拿，
//    }

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
        uuid = getUserDeviceFromKeychain()   //getUserFromKeychain()
    }
    
    private func getUserDeviceFromKeychain() -> String? {
        let keychain = KeychainSwift()
        if let acount = keychain.get(ConstValue.kUserKeychainKey) {
            DLog("acountMsg = \(keychain.accessGroup ?? "没有添加用户群组") acount == \(acount)")
            return acount
        } else {
            let deviceId = UIDevice.current.getIdfv()
            let random = arc4random()%1000000
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
    
    private func getLocalUploadTask() {
        guard let taskData = UserDefaults.standard.data(forKey: UserDefaults.kUploadTaskImage) else {
            return
        }
        if let taskParams = UserDefaults.standard.object(forKey: UserDefaults.kUploadTaskParams) as? [String: Any] {
            let task = PushPresenter()
            var pushModel = PushVideoModel()
            if let taskImage = NSKeyedUnarchiver.unarchiveObject(with: taskData) as? UIImage {
                pushModel.videoCover = taskImage
                pushModel.commitParams = taskParams
                pushModel.videoUrl = FileManager.videoExportURL
                task.pushModel = pushModel
                let statu = UserDefaults.standard.integer(forKey: UserDefaults.kUploadTaskStatu)
                task.videoPushStatu = VideoPushStatu.init(rawValue: statu) ?? .waitForUpload
                UploadTask.shareTask().tasks = [task]
                DLog("本地未处理完成的上传任务 == \(task)")
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
        return [ConstValue.kXSVideoService: "XSVideoService", ConstValue.kAppProdService: "AppProdService"]
    }
    
    /// 自定义的服务所在的命名空间 （如果自定义的服务是组件，命名空间就为 服务组件名）
    ///
    /// - Parameter service: 服务名
    /// - Returns: m命名空间
    func namespaceForService(_ service: String) -> String? {
        switch service {
        case ConstValue.kXSVideoService, ConstValue.kAppProdService:
            return "QHAwemeDemo"   // 这里两个服务都在主工程 （如果服务 跟随组件模块， 则需要传入组件所在的命名空间名）
        default:
            return nil
        }
    }
}
