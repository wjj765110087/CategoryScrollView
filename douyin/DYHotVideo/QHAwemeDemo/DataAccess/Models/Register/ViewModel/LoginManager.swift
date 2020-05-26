//
//  LoginManager.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/21.
//  Copyright © 2018年 pro5. All rights reserved.
//

import UIKit
import NicooNetwork

/// 登录拦截器
class LoginManager: NSObject {
    
    private let viewModel = RegisterLoginViewModel()
    private let userInfo = UserInfoViewModel()
    
    /// 登录
    ///
    /// - Parameter successHandler: 成功回调
    func login(_ successHandler:(() -> Void)?) {
//        let loginVC = LoginController()
//        loginVC.loginSuccessCallBack = successHandler
//        let loginNav = UINavigationController(rootViewController: loginVC)
//        UIViewController.currentViewController()?.present(loginNav, animated: true, completion: nil)
    }
    
    /// 退出登录
    func logout(_ successhandler:(() -> Void)?) {
    
        UserDefaults.standard.removeObject(forKey: UserDefaults.kUserToken)
    }
    
    /// 自动登录成功回调
    private func loginCallBackHandler() {
        viewModel.loadLoginApiSuccess = { [weak self] in
            self?.loadUserInfoData()
        }
    }
    
    /// 请求用户信息
    private func loadUserInfoData() {
        userInfo.loadUserInfo()
    }
}



/// APP 信息单利
class AppInfo: NSObject {
    static private let shareModel: AppInfo = AppInfo()
    class func share() -> AppInfo {
        return shareModel
    }
    var id: Int?
    var title: String?
    var remark: String?
    var platform: String?
    var version_code: String?
    var package_path: String?
    var share_url: String?
    var share_text: String?
    var potato_invite_link: String? //土豆群跳转地址
    var extend: String?
    var official_url: String?   // 官网
    var static_url: String?   // 上传图片
    var file_upload_url: String? // 上传视频
    var force: ForceUpdate?
    var updated_at: String?
    var help_url: String?
    var wallet_url: String?
    var app_rule: AppRule?
    
}

/// App崩溃日志收集
class TBUncaughtExceptionHandler: NSObject {
    
    static let shared = TBUncaughtExceptionHandler()
    fileprivate override init() {}
    
    private lazy var uploadCrashApi: UploadCrashLogApi = {
       let api = UploadCrashLogApi()
       api.paramSource = self
       api.delegate = self
       return api
    }()
    
    let uploadURL: String = UploadCrashLogApi.kUrlValue
    
    var errorMessage: String = ""
    
    func loadData() {
        let _ = uploadCrashApi.loadData()
    }
    
    public func exceptionLogWithData() {
        setDefaultHandler()
        let path = getdataPath()
        if FileManager.default.fileExists(atPath: path) {
            sendExceptionLogWithData()
        }
        //                let arry:NSArray = ["1"]
        //                print("%@",arry[5])
    }
    
    ///沙盒路径
    fileprivate func getdataPath() -> String{
        let str = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let urlPath = str.appending("/Exception.txt")
        return urlPath
    }

    ///异常回调
    fileprivate func setDefaultHandler() {
        NSSetUncaughtExceptionHandler { (exception) in
            let arr:NSArray = exception.callStackSymbols as NSArray
            let reason:String = exception.reason!
            let name:String = exception.name.rawValue
            let date:NSDate = NSDate()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "YYYY/MM/dd hh:mm:ss SS"
            let strNowTime = timeFormatter.string(from: date as Date) as String
            let url:String = String.init(format: "========异常错误报告========\ntime:%@\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",strNowTime,name,reason,arr.componentsJoined(by: "\n"))
            UserDefaults.standard.set(url, forKey: UserDefaults.kCrashLog)
            UserDefaults.standard.synchronize()
            let documentpath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
            let path = documentpath.appending("/Exception.txt")
            DLog("崩溃日志的路径===CrashLogPath====%@", path)
            do{
                try
                    url.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            }catch{}
        }
    }
    
    fileprivate func sendExceptionLog() {
        loadData()
    }
    
     ///上传
    fileprivate func sendExceptionLogWithData(){
        
        let path = getdataPath()
        let data = NSData.init(contentsOfFile: path)
        
        if data != nil {
            if  let crushStr = String.init(data: data! as Data, encoding: String.Encoding.utf8) {
                self.errorMessage = crushStr
                //上传数据
                loadData()
            }
        }
    }
}

extension TBUncaughtExceptionHandler: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        var params = [String : Any]()
        if let errorMessage = UserDefaults.standard.object(forKey: UserDefaults.kCrashLog) as? String {
            self.errorMessage = errorMessage
            params = [UploadCrashLogApi.kError_message: self.errorMessage,
                      UploadCrashLogApi.kDevice_code: UIDevice.current.getIdfv(),
                      UploadCrashLogApi.kPlatform: "I"]
        }
        return params
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is UploadCrashLogApi {
            UserDefaults.standard.removeObject(forKey: UserDefaults.kCrashLog)
//            FileManager.default.fileExists(atPath: <#T##String#>)
            FileManager.default.remove(atPath: self.getdataPath())
//            XSAlert.show(type: .success, text: "上传日志成功")
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        if manager is UploadCrashLogApi {
//            XSAlert.show(type: .error, text: "上传日志失败")
        }
    }
}
