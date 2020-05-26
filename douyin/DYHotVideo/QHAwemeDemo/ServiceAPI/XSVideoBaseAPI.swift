//
//  Created by NicooYang on 10/04/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import NicooNetwork
/**
 整个app网络请求的base类，用于做一些公共处理
 */
open class XSVideoBaseAPI: NicooBaseAPIManager, NicooAPIManagerProtocol, NicooAPIManagerValidatorDelegate, NicooAPIManagerInterceptorProtocol {
    /// 最外层Key
    static let kData = "data"
    
    /// 固定参数Key
    static let kUrl = "uri"
    static let kMethod = "method"
    static let kParams = "params"
    static let kHeaders = "headers"
    
    public override init() {
        super.init()
        interceptor = self
        validator = self
    }
    
    // MAKR: - NicooAPIManagerProtocol
    
    open func methodName() -> String {
        return "\(ConstValue.kApiVersion)/accept"
    }
    
    open func serviceType() -> String {
        return ConstValue.kXSVideoService
    }
    
    open func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? .post : .get
    }
    
    open func shouldCache() -> Bool {
        return false
    }
    
    open func reform(_ params: [String: Any]?) -> [String: Any]? {
        guard var allParams = params else { return nil }
        // DLog("<<<<<<<< ---\(String(describing: allParams[XSVideoBaseAPI.kUrl])) -->>>> \(allParams)")
        if ConstValue.kIsEncryptoApi {
            var headerParams = [String : Any]()
            headerParams["Accept"] = "application/json"
            headerParams["version-code"] = XSVideoService.appVersion
            headerParams["device-id"] = UIDevice.current.getIdfv()
            headerParams[AppUpdateApi.kPlatform] = AppUpdateApi.kDefaultPlatform
            if let token = UserModel.share().userInfo?.api_token {
                headerParams["Authorization"] = "Bearer \(token)"
            }
            allParams[XSVideoBaseAPI.kHeaders] = headerParams
           
            var trueParams = [String: Any]()
            if let data = try? JSONSerialization.data(withJSONObject: allParams, options: [])  {
                if let string = String(data: data, encoding: .utf8) {
                    let stringSet = string.aes128EncryptString(withKey: ConstValue.kApiEncryptKey)
                    trueParams[XSVideoBaseAPI.kData] = stringSet?.urlEncoded()
                }
            }
            DLog("<<<<<<<< ---\(String(describing: allParams[XSVideoBaseAPI.kUrl])) -->>>> \(allParams)")
            return trueParams
        }
       return allParams
    }
    
    open func cleanData() {
        
    }
    
    open func parameterEncodingType() -> NicooAPIManagerParameterEncodeing {
        return .json
    }
    
    // MARK: - NicooAPIManagerValidatorDelegate
    
    // 在这里验证参数是否错误，并且给出具体的错误原因
    open func manager(_ manager: NicooBaseAPIManager, isCorrectWithParams params: [String: Any]?) -> Bool {
        return true
    }
    
    open func manager(_ manager: NicooBaseAPIManager, isCorrectWithCallbackData data: [String: Any]?) -> Bool {
        if (data?["code"] as? NSNumber)?.intValue == 0 {
            return true
        }
        return false
    }
    
    // MARK: - NicooAPIManagerInterceptorProtocol
    open func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        return true
    }
    open func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {}
    
    // 在这里根据错误类型，给errorMessage赋值
    open func manager(_ manager: NicooBaseAPIManager, beforePerformFail response: NicooURLResponse?) -> Bool {
        if manager.errorType == .noNetwork {
            self.errorMessage = XSAlertMessages.kNetworkErrorMessage
        } else if manager.errorType == .defaultError {
            self.errorMessage = XSAlertMessages.kNetworkErrorMessage
        } else if manager.errorType == .timeout {
            self.errorMessage = XSAlertMessages.kNetworkErrorMessage
        }
        DLog("<<<<<<<< -- FailRes -- >>>>>>>> \(String(describing: response?.content)) =")
        if (response?.content as? [String: Any]) != nil {
            let content = response!.content as! [String: Any]
            if let errorMsg = content["message"]  {
                manager.errorMessage = errorMsg as? String ?? ""
            }
            /// token失效, 这里可以拦截，service内也可以（）
            if let errorCode = content["code"] as? Int {
                if errorCode == 401 { /// 410  403  401
                    manager.errorMessage = "tokenError"
                } else if errorCode == 403 {
                    manager.errorMessage = "403"
                    ///Code=-1002 /"you do not have permission.
                    DLog("youdo not have permission")
                }
            }
        }
        return true
    }
    open func manager(_ manager: NicooBaseAPIManager, afterPerformFail response: NicooURLResponse?) {}
    
    open func manager(_ manager: NicooBaseAPIManager, shouldCallAPI params: [String: Any]?) -> Bool {
        return true
    }
    open func manager(_ manager: NicooBaseAPIManager, afterCallAPI params: [String: Any]?) {}
    
}


