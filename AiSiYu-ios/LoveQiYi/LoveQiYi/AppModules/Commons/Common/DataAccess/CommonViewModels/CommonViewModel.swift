//
//  ReginsterLoginViewModel.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/17.
//  Copyright © 2018年 pro5. All rights reserved.
//

import UIKit
import NicooNetwork

class CommonViewModel: NSObject {
    
    private lazy var loginApi: UserLoginApi = {
        let api = UserLoginApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    private lazy var registerApi: UserRegisterApi = {
        let api = UserRegisterApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    private lazy var sendCodeApi: SendCodeApi = {
        let api = SendCodeApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
  
    private lazy var deviceRegisterApi: DeviceRegisterApi = {
        let api = DeviceRegisterApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    private lazy var updateAPI: AppUpdateApi = {
        let api = AppUpdateApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var advAPI: AdvertismentApi = {
        let api = AdvertismentApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    /// 系统公告请求
    private lazy var systemMsgApi: AppMessageApi = {
        let msgApi = AppMessageApi()
        msgApi.delegate = self
        msgApi.paramSource = self
        return msgApi
    }()
    
    /// 参数
    var paramsRegister: [String: Any]?
    var paramsLogin: [String: Any]?
    var paramsSendCode: [String: Any]?
    var paramsChangePsw: [String: Any]?
    /// 注册接口回调
    var loadRegisterApiSuccess:(() ->Void)?
    var loadRegisterApiFail:((_ msg: String) ->Void)?
    /// 登录接口回调
    var loadLoginApiSuccess:(() ->Void)?
    var loadLoginApiFail:((_ msg: String) ->Void)?
    /// 发送验证码接口回掉
    var loadSendCodeApiSuccess:(() ->Void)?
    var loadSendCodeApiFail:((_ msg: String) ->Void)?
    /// 修改密码接口回调
    var loadChangePswApiSuccess:(() ->Void)?
    var loadChangePswApiFail:((_ msg: String) ->Void)?
    /// 检查更新接口回调
    var loadCheckVersionInfoApiSuccess:(() ->Void)?
    var loadCheckVersionInfoApiFail:((_ msg: String) ->Void)?
    /// 公告成功回调
    var loadAppNoticeSuccess:(() -> Void)?
    
    /// 注册成功
    var loadDeviceRegisterSuccess:(() ->Void)?
    var loadDeviceRegisterFail:(() -> Void)?

    var codeModel: CodeModel?
    
    var versionInfo: AppVersionInfo?
    

    /// 检查是否需要更新
    func checkUpdateInfo() {
        let _ = updateAPI.loadData()
    }
    
    /// 请求广告并下载
    func loadAdInfo() {
        let _ = advAPI.loadData()
    }
    
    /// 注册
    func reginsterUser(_ params: [String: Any]) {
        paramsRegister = params
        let _ = registerApi.loadData()
    }
    
    /// 登录
    func loginUser(_ params: [String: Any]) {
        paramsLogin = params
        let _ = loginApi.loadData()
    }
    
    /// 发送验证码
    func sendCode(_ params: [String: Any]) {
        paramsSendCode = params
        let _ = sendCodeApi.loadData()
    }
    
    /// 设备注册
    func registerDevice() {
        let _ = deviceRegisterApi.loadData()
    }
    
    /// 系统公告
    func loadSystemMsg() {
        let _ = systemMsgApi.loadData()
    }
    
    
}

// MARK: - PUBLIC FUNCS
extension CommonViewModel {
    
    func getCodeModel() -> CodeModel {
        if codeModel != nil {
            return codeModel!
        }
        return CodeModel()
    }
    
    func getInviteCode() -> [String: Any]? {
        var params = [String: Any]()
         DLog("inviteCodeFrom : == (bnil)")
        if let paste = UIPasteboard.general.string {
            DLog("inviteCodeFrom : == \(paste)")
            //如果剪贴板中的内容包含邀请码
           params[DeviceRegisterApi.kInviteCode] = paste
        }
        return params
    }
}

// MARK: - Privite Funcs
 private extension CommonViewModel {
    
    func loginSuccess(_ model: LoginInfoModel) {
        DLog("userNickName ---\(model.user?.name ?? "")")
//        if model.user != nil {
//            UserModel.share().api_token = model.user!.api_token
//            UserModel.share().name = model.user!.name
//            UserModel.share().email = model.user!.email
//            UserModel.share().cover_path = model.user!.cover_path
//            UserModel.share().id = model.user!.id
//            UserModel.share().created_at = model.user!.created_at
//            UserModel.share().isLogin = true
//            UserModel.share().isRealUser = true
//        }
//        loadLoginApiSuccess?()
    }
    
    func sendCodeSuccess(_ model: CodeModel) {
        codeModel = model
        loadSendCodeApiSuccess?()
    }
    
    func checkVersionSuccess(_ model: AppVersionInfo) {
        versionInfo = model
        loadCheckVersionInfoApiSuccess?()
    }
    
    func deviceRegisterSuccess(_ model: UserInfoModel) {
        UserModel.share().userInfo = model
        UserModel.share().isLogin = true
        UserDefaults.standard.set(model.api_token, forKey: UserDefaults.kUserToken)
        UserDefaults.standard.set(model.invite_code, forKey: UserDefaults.kUserInviteCode)
        loadDeviceRegisterSuccess?()
    }
}

// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension CommonViewModel: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        if manager is UserLoginApi {
           return paramsLogin
        }
        if manager is UserRegisterApi {
            return paramsRegister
        }
        if manager is SendCodeApi {
            return paramsSendCode
        }
        if manager is DeviceRegisterApi {
            return getInviteCode()
        }
       
        if manager is AppUpdateApi {
            return [AppUpdateApi.kPlatform: AppUpdateApi.kDefaultPlatform]
        }
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is UserLoginApi {
            DLog("UserLoginApi --- success")
            if let model = manager.fetchJSONData(UserReformer()) as? LoginInfoModel {
                loginSuccess(model)
            }
        }
        if manager is UserRegisterApi {
            DLog("RegisterApi --- success")
            loadRegisterApiSuccess?()
        }
        if manager is SendCodeApi {
            DLog("SendCodeApi --- success")
            if let model = manager.fetchJSONData(LoginRegisterReformer()) as? CodeModel {
                sendCodeSuccess(model)
            }
        }
        if manager is AppMessageApi {
            if let msgList = manager.fetchJSONData(AppUpdateReformer()) as? [SystemMsgModel], msgList.count > 0 {
                SystemMsg.share().systemMsgs = msgList
                loadAppNoticeSuccess?()
            }
        }
        if manager is DeviceRegisterApi {
            if let model = manager.fetchJSONData(LoginRegisterReformer()) as? UserInfoModel {
                deviceRegisterSuccess(model)
            }
        }
        if manager is AppUpdateApi {
            if let model = manager.fetchJSONData(AppUpdateReformer()) as? AppVersionInfo {
                checkVersionSuccess(model)
            }
        }
        if manager is AdvertismentApi {
            if let adInfo = manager.fetchJSONData(AppUpdateReformer()) as? AdSplashModel {
                if let adPath = adInfo.startup?.ad_path {
                    if adPath.isEmpty { return }
                    let adfile = AdFileModel(adUrl: adPath, adType: .image, adHerfUrl: adInfo.startup?.href, adId: 0, customSaveKey: nil)
                    /// 下载广告, 下次启动展示
                    SwiftAdFileConfig.downLoadAdData(adfile)
                }
                if let reload = adInfo.reload?.ad_path {
                    if reload.isEmpty { return }
                    let reloadfile = AdFileModel(adUrl: reload, adType: .image, adHerfUrl: adInfo.reload?.href, adId: 0, customSaveKey: UserDefaults.kReloadImg)
                    /// 下载广告, 下次启动展示
                    SwiftAdFileConfig.downLoadAdData(reloadfile)
                }
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        if manager is UserLoginApi {
            loadLoginApiFail?(manager.errorMessage)
        }
        if manager is UserRegisterApi {
            loadRegisterApiFail?(manager.errorMessage)
        }
        if manager is SendCodeApi {
            loadSendCodeApiFail?(manager.errorMessage)
        }
        if manager is DeviceRegisterApi {
            loadDeviceRegisterFail?()
        }
           
    }
}
