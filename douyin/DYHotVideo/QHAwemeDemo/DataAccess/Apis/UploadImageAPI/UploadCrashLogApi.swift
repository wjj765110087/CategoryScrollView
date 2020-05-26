//
//  UploadCrashLogApi.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/21.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork
class UploadCrashLogApi: XSVideoBaseAPI  {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/crash-log"
    static let kMethodValue = "POST"
    
    static let kError_message = "error_message"
    static let kDevice_code = "device_code"
    static let kPlatform = "platform"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/crash-log"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }

    override func reform(_ params: [String : Any]?) -> [String : Any]? {
        var allParams: [String: Any] = [UploadCrashLogApi.kUrl: UploadCrashLogApi.kUrlValue,
                                        UploadCrashLogApi.kMethod: UploadCrashLogApi.kMethodValue]
        allParams[UploadCrashLogApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}


