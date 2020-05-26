//
//  CommonApis.swift
//  YellowBook
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019年 mac. All rights reserved.
//

import Foundation
import NicooNetwork


// MARK: - 设备号注册
class DeviceRegisterApi: XSVideoBaseAPI {
    
    static let kInviteCode = "invite_code" // 剪切板内容
    
    static let kUrlValue = "api/common/register-device"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    override func methodName() -> String {
        return DeviceRegisterApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
}

// MARK: - 用户注册(手机号注册)
class UserRegisterApi: XSVideoBaseAPI {
    
    static let kMobile = "mobile"
    static let kPassword = "password"
    static let kVerification_key = "verification_key"
    static let kCode = "code"
    static let kPassword_confirmation = "password_confirmation"
    static let kInvite_code = "invite_code"
    
    static let kUrlValue = "api/user/bind-mobile"
    
    override func methodName() -> String {
        return UserRegisterApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
}

// 用户登录
class UserLoginApi: XSVideoBaseAPI {
    
    static let kMobile = "mobile"
    static let kType = "type"   // 登录方式：P：密码登录，C：验证码快捷登录
    static let kVerification_key = "verification_key" // 验证码（如果是验证码登录必填）
    static let kPassword = "password"  // 用户密码（如果是密码登录必填
    static let kCode = "code"               // 验证码（如果是验证码登录必填）
    
    static let kUrlValue = "/api/login"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    override func methodName() -> String {
        return UserLoginApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
}


// MARK: - 发送验证码
class SendCodeApi: XSVideoBaseAPI {
    
    static let kMobile = "mobile"
    
    static let kUrlValue = "api/common/verify-code"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    override func methodName() -> String {
        return SendCodeApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
    
}

// MARK: -  版本更新信息Api
class AppUpdateApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/common/version"
    static let kPlatform = "platform"   // A [A:安卓版 I:IOS版]
    
    static let kDefaultPlatform = "I"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return AppUpdateApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform( params)
    }
    
}

// MARK: -  系统公告Api
class AppMessageApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/common/notice"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return AppMessageApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
    
}


// MARK: -  闪屏广告
class AdvertismentApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/common/startup"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return AdvertismentApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
    
}
