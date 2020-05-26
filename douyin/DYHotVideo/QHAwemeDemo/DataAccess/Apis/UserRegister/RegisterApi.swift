//
//  RegisterApi.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/17.
//  Copyright © 2018年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork

// 用户注册
class UserRegisterApi: XSVideoBaseAPI {
    
    static let kMobile = "mobile"
    static let kDevice_code = "device_code"
    static let kPassword = "password"
    static let kVerification_key = "verification_key"
    static let kCode = "code"
    static let kPassword_confirmation = "password_confirmation"
    static let kInvite_code = "invite_code"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/bind-mobile"
    static let kMethodValue = "POST"
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/bind-mobile"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserRegisterApi.kUrl: UserRegisterApi.kUrlValue,
                                        UserRegisterApi.kMethod: UserRegisterApi.kMethodValue]
        allParams[UserRegisterApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}



