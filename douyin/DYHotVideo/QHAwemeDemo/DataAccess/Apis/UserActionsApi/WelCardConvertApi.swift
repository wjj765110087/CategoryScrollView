//
//  WelCardConvertApi.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/5/3.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation
import NicooNetwork

/// 折扣卷兑换Api
class WelCardConvertApi: XSVideoBaseAPI {
    /// 卷码
    static let kCode = "code"
    
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/get-welfare"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/get-welfare"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [WelCardConvertApi.kUrl: WelCardConvertApi.kUrlValue,
                                        WelCardConvertApi.kMethod: WelCardConvertApi.kMethodValue]
        allParams[WelCardConvertApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}

/// 补填邀请码Api
class SetInviteCodeApi: XSVideoBaseAPI {
    
    /// 卷码
    static let kCode = "code"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/invitation/bind-code"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/invitation/bind-code"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [SetInviteCodeApi.kUrl: SetInviteCodeApi.kUrlValue,
                                        SetInviteCodeApi.kMethod: SetInviteCodeApi.kMethodValue]
        allParams[SetInviteCodeApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}


class VipConvertInfoApi: XSVideoBaseAPI {
    /// 卷码
    static let kCode = "code"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/exchange-info"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/exchange-info"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [VipConvertInfoApi.kUrl: VipConvertInfoApi.kUrlValue,
                                        VipConvertInfoApi.kMethod: VipConvertInfoApi.kMethodValue]
        allParams[VipConvertInfoApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}

/// vip兑换Api
class VipCardExChangeApi: XSVideoBaseAPI {
    /// 卷码
    static let kCode = "code"

    static let kUrlValue = "/\(ConstValue.kApiVersion)/exchange"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/exchange"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [VipCardExChangeApi.kUrl: VipCardExChangeApi.kUrlValue,
                                        VipCardExChangeApi.kMethod: VipCardExChangeApi.kMethodValue]
        allParams[VipCardExChangeApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}
