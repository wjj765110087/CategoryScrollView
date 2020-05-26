//
//  SendCodeApi.swift
//  XSVideo
//
//  Created by pro5 on 2019/1/5.
//  Copyright © 2019年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork

/// 发送验证码
class SendCodeApi: XSVideoBaseAPI {
    
    static let kMobile = "mobile"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/mobile/verify-code"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/mobile/verify-code"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [SendCodeApi.kUrl: SendCodeApi.kUrlValue,
                                        SendCodeApi.kMethod: SendCodeApi.kMethodValue]
        allParams[SendCodeApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}
