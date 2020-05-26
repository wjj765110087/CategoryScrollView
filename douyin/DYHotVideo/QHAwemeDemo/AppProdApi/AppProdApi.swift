//
//  AppProdApi.swift
//  XSVideo
//
//  Created by pro5 on 2019/1/9.
//  Copyright © 2019年 pro5. All rights reserved.
//

import UIKit
import NicooNetwork
/**
  App 请求有效域名Api
 */
open class XSVideoProdAPI: NicooBaseAPIManager, NicooAPIManagerProtocol, NicooAPIManagerValidatorDelegate, NicooAPIManagerInterceptorProtocol {
  
    public override init() {
        super.init()
        interceptor = self
        validator = self
    }
    
    // MAKR: - NicooAPIManagerProtocol
    
    override open func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }

    open func methodName() -> String {
        return "\(ConstValue.kApiVersion)/domain"
    }
    
    open func serviceType() -> String {
        return ConstValue.kAppProdService
    }
    
    open func requestType() -> NicooAPIManagerRequestType {
        return .get
    }
    
    open func shouldCache() -> Bool {
        return false
    }
    
    open func reform(_ params: [String: Any]?) -> [String: Any]? {
        guard let allParams = params else { return nil }
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
        DLog(" -- FailAppProdRes -- >>>>>>>> \(String(describing: response?.content)) =")
        if (response?.content as? [String: Any]) != nil {
            let content = response!.content as! [String: Any]
            if let errorMsg = content["message"]  {
                manager.errorMessage = errorMsg as? String ?? ""
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

