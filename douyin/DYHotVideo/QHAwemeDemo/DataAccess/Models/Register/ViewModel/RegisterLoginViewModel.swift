//
//  ReginsterLoginViewModel.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/17.
//  Copyright © 2018年 pro5. All rights reserved.
//

import UIKit
import NicooNetwork

class RegisterLoginViewModel: NSObject {
    
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
    
    
}

// MARK: - PUBLIC FUNCS
extension RegisterLoginViewModel {
    
    func getCodeModel() -> CodeModel {
        if codeModel != nil {
            return codeModel!
        }
        return CodeModel()
    }
    
    func getInviteCode() -> [String: Any]? {
        //识别剪贴板中的内容
        let pastesss = UIPasteboard.general.string
        DLog("inviteCodeFrom : == \(pastesss ?? "")")
        if let paste = UIPasteboard.general.string, (paste.hasPrefix("DY_")) {
            //如果剪贴板中的内容包含邀请码
            DLog("inviteCodeFrom : == \(paste)")
            if let paramString = paste.components(separatedBy: "DY_").last {
                DLog("inviteCodeFrom : == \(paramString)")
                var params = [String: Any]()
                let paramsValues = paramString.components(separatedBy: "#")
                if paramsValues.count >= 3 {
                    params[DeviceRegisterApi.kInviteCode] = paramsValues[0]
                    params[DeviceRegisterApi.kChannel] = paramsValues[1]
                    params[DeviceRegisterApi.kFrom] = paramsValues[2]
                } else if 2 <= paramsValues.count && paramsValues.count < 3 {
                    params[DeviceRegisterApi.kInviteCode] = paramsValues[0]
                    params[DeviceRegisterApi.kChannel] = paramsValues[1]
                } else if 1 <= paramsValues.count && paramsValues.count < 2 {
                    params[DeviceRegisterApi.kInviteCode] = paramsValues[0]
                }
                return params
            }
        }
        return nil
    }
    /// 绑定手机成功
    func binkMobileSuccess(_ oldUser: UserInfoModel) {
        UserModel.share().userInfo = oldUser
        UserModel.share().isRealUser = oldUser.type == 0
        UserModel.share().isLogin = true
        UserDefaults.standard.set(oldUser.code, forKey: UserDefaults.kUserInviteCode)
        UserDefaults.standard.set(oldUser.api_token, forKey: UserDefaults.kUserToken)
        loadRegisterApiSuccess?()
    }
}

// MARK: - Privite Funcs
 private extension RegisterLoginViewModel {
    
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
        UserModel.share().isRealUser = model.type == 0
        UserModel.share().isLogin = true
        UserDefaults.standard.set(model.api_token, forKey: UserDefaults.kUserToken)
        UserDefaults.standard.set(model.code, forKey: UserDefaults.kUserInviteCode)
        UserDefaults.standard.set(model.vip_id, forKey: UserDefaults.kVipCardLevel)
        loadDeviceRegisterSuccess?()
    }
}

// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension RegisterLoginViewModel: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
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
             DLog("deviceId = \(UIDevice.current.getIdfv())")
            if var params = getInviteCode(), params.count > 0 {
                params[DeviceRegisterApi.kDevice_code] = UIDevice.current.getIdfv()
                return params
            } else {
                return [DeviceRegisterApi.kDevice_code: UIDevice.current.getIdfv()]
            }
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
            if let userInfo = manager.fetchJSONData(UserReformer()) as? UserInfoModel {
                binkMobileSuccess(userInfo)
            }
        }
        if manager is SendCodeApi {
            DLog("SendCodeApi --- success")
            if let model = manager.fetchJSONData(LoginRegisterReformer()) as? CodeModel {
                sendCodeSuccess(model)
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
                guard let adPath = adInfo.ad_path else { return }
                if adPath.isEmpty { return }
                if let saveAdSplashUrl = UserDefaults.standard.string(forKey: UserDefaults.kAdDataUrl), saveAdSplashUrl == adPath {
                    return
                }
                // 下载广告图片
                if let url = URL(string: adPath) {
                    /// 测试 URL ： https://cdn.zeplin.io/5c82767424592b2737df15ff/screens/BF3345C2-BC1F-444E-8546-0AF35D0A53D0.png
                    AdvertisementView.downLoadImageDataWith(url)
                }
                // c保存广告跳转链接
                if let href = adInfo.href, !href.isEmpty {
                    UserDefaults.standard.set(URL(string: href), forKey: UserDefaults.kAdHrefUrl)
                }
            } else {
                if UserDefaults.standard.string(forKey: UserDefaults.kAdDataUrl) != nil {
                    UserDefaults.standard.removeObject(forKey: UserDefaults.kAdDataUrl)
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
