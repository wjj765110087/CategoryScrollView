//
//  AppUpdateApi.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/28.
//  Copyright © 2018年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork

/// 版本更新信息Api
class AppUpdateApi: XSVideoBaseAPI {
    
    static let kPlatform = "platform"   // A [A:安卓版 I:IOS版]
    
    static let kDefaultPlatform = "I"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/version"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return  ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/version"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [AppUpdateApi.kUrl: AppUpdateApi.kUrlValue,
                                        AppUpdateApi.kMethod: AppUpdateApi.kMethodValue]
        allParams[AppUpdateApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}

/// 系统公告Api
class AppMessageApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/notice"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return  ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/notice"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [AppMessageApi.kUrl: AppMessageApi.kUrlValue,
                                        AppMessageApi.kMethod: AppMessageApi.kMethodValue]
        allParams[AppMessageApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}

