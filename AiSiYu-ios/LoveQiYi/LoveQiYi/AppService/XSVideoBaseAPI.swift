

import UIKit
import NicooNetwork
/**
 整个app网络请求的base类，用于做一些公共处理
 */
open class XSVideoBaseAPI: NicooBaseAPIManager, NicooAPIManagerProtocol, NicooAPIManagerValidatorDelegate, NicooAPIManagerInterceptorProtocol {
    
    /// 最外层Key
    static let kData = "data"
    
    public override init() {
        super.init()
        interceptor = self
        validator = self
    }
    
    // MAKR: - NicooAPIManagerProtocol
    
    open func methodName() -> String {
        return ""
    }
    
    open func serviceType() -> String {
        return ConstValue.kXSVideoService
    }
    
    open func requestType() -> NicooAPIManagerRequestType {
        return .post
    }
    
    open func shouldCache() -> Bool {
        return false
    }
   
    open func reform(_ params: [String: Any]?) -> [String: Any]? {
        if !ConstValue.kIsEncryptoApi {
            return params
        }
        var newParams = [String: Any]()
        if params != nil {
            for (key, value) in params! {
                 newParams[key] = value
            }
        }
        let dateNow = Date()
        let timeInterval: TimeInterval = dateNow.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        print("timeStamp =============\(timeStamp)")
        newParams["timestamp"] = timeStamp
        /// 排序
        let sign = getParamsEncrypto(newParams)
        newParams["sign"] = sign
        var trueParams = [String: Any]()
        if let data = try? JSONSerialization.data(withJSONObject: newParams, options: [])  {
            if let string = String(data: data, encoding: .utf8) {
                let stringSet = string.aes128EncryptString(withKey: ConstValue.kApiEncryptKey)
                trueParams[XSVideoBaseAPI.kData] = stringSet //?.urlEncoded()
                 //DLog("paramsData = \(trueParams)")
            }
        }
       return trueParams
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
                    print("youdo not have permission")
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

// MARK: - 参数处理
extension XSVideoBaseAPI {
    
    /// 字典key按ASCLL码排序
    func getParamsEncrypto(_ params: [String: Any]) -> String {
        
        let allKeys = Array(params.keys)
        let sortedKeys = allKeys.sorted { (a, b) -> Bool in
            return a < b
        }
        let stringSign = NSMutableString()
        for key in sortedKeys {
            if let valueStr = params[key] {
                stringSign.append("\(key)=\(valueStr)&")
            }
        }
        stringSign.append("key=\(appApiSignKey())")
        let stringForSign = (stringSign as String)
        let sign = (stringForSign.md5()?.uppercased() ?? "") as String
        return sign
    }
    
    func appApiSignKey() -> String {
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: filePath!)
        return dictionary!["CustomSignKey"] as! String
    }
    
}
