//
//  LoginApi.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/17.
//  Copyright © 2018年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork

// 用户登录
class UserLoginApi: XSVideoBaseAPI {
    
    static let kMobile = "mobile"
    static let kType = "type"   // 登录方式：P：密码登录，C：验证码快捷登录
    static let kVerification_key = "verification_key" // 验证码（如果是验证码登录必填）
    static let kPassword = "password"  // 用户密码（如果是密码登录必填
    static let kCode = "code"               // 验证码（如果是验证码登录必填）
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/login"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/login"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserLoginApi.kUrl: UserLoginApi.kUrlValue,
                                        UserLoginApi.kMethod: UserLoginApi.kMethodValue]
        allParams[UserLoginApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}


