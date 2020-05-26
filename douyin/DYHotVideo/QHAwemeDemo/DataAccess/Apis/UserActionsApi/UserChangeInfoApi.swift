//
//  UserChangeInfoApi.swift
//  XSVideo
//
//  Created by pro5 on 2019/1/5.
//  Copyright © 2019年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork

/// 用户邀请规则借口
class InvitationRulesApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/invitation/rules"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/invitation/rules"
    }
    
    override func shouldCache() -> Bool {
        return true
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [InvitationRulesApi.kUrl: InvitationRulesApi.kUrlValue,
                                        InvitationRulesApi.kMethod: InvitationRulesApi.kMethodValue]
        allParams[InvitationRulesApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

/// 用户手机号找回用户信息
class AcountBackWithPhoneApi: XSVideoBaseAPI {
    
    static let kMobile = "mobile"
    static let kDevice_code = "device_code"
    static let kVerification_key = "verification_key"
    static let kCode = "code"
    
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/account/recallByMobile"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/account/recallByMobile"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [AcountBackWithPhoneApi.kUrl: AcountBackWithPhoneApi.kUrlValue,
                                        AcountBackWithPhoneApi.kMethod: AcountBackWithPhoneApi.kMethodValue]
        allParams[AcountBackWithPhoneApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

/// 用户信息找回原账号
class InfoFindAcountApi: XSVideoBaseAPI {
    
    static let kUsername = "username"
    static let kOrder_no = "order_no"
    static let kRegister_at = "register_at"
    static let kRemark = "remark"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/find-msg"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/find-msg"
    }
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [InfoFindAcountApi.kUrl: InfoFindAcountApi.kUrlValue,
                                        InfoFindAcountApi.kMethod: InfoFindAcountApi.kMethodValue]
        allParams[InfoFindAcountApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

