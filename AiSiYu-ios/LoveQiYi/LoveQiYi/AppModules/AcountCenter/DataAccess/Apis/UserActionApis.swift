//
//  UserActionApis.swift
//  YellowBook
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019年 mac. All rights reserved.
//

import Foundation
import NicooNetwork


/// 用户信息找回原账号
class InfoFindAcountApi: XSVideoBaseAPI {
    
    static let kUsername = "username"
    static let kOrder_no = "order_no"
    static let kRegister_at = "register_time"
    static let kRemark = "remark"
    
    static let kUrlValue = "api/recall/msg"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return InfoFindAcountApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
}


/// 用户手机号找回用户信息
class AcountBackWithPhoneApi: XSVideoBaseAPI {
    
    static let kMobile = "mobile"
    static let kDevice_code = "device_code"
    static let kVerification_key = "verification_key"
    static let kCode = "code"
    
    static let kUrlValue = "api/recall/mobile"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return AcountBackWithPhoneApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
}

/// 用户反馈Api
class UserFadeBackApi: XSVideoBaseAPI {
    
    /// 反馈内容
    static let kContent = "remark"
    /// 联系方式
    static let kContact = "contact"
    /// 问题keys
    static let kKeys = "keys"
    /// 上传成功的图片名称
    static let kCover_filename = "cover_filename"
    
    static let kUrlValue = "api/feed/create"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return UserFadeBackApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
    
}

/// idcardFindApi
class RecallByCardApi: XSVideoBaseAPI {
    
    /// token
    static let kToken = "token"   //uid+salt,如:56717gX9ecQx7
    static let kDevice_code = "device_code"
    
    
    static let kUrlValue = "api/recall/card"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return RecallByCardApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        
        return super.reform(params)
    }
    
}

/// 补填邀请码Api
class SetInviteCodeApi: XSVideoBaseAPI {
    
    /// 卷码
    static let kCode = "code"
    
    static let kUrlValue = "api/user/bind-code"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return SetInviteCodeApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
}


/// 用户取消收藏
class UserFavorCancleApi: XSVideoBaseAPI {
    
    static let kVideo_id = "video_id"
    static let kGlobal_type = "global_type"
    
    static let kUrlValue = "api/video/collect-cancel"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return UserFavorCancleApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        
        return super.reform(params)
    }
    
}

/// 用户删除历史
class UserHisCancleApi: XSVideoBaseAPI {
    
    static let kVideo_id = "video_id"
    
    static let kUrlValue = "api/video/history-cancel"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return UserHisCancleApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        
        return super.reform(params)
    }
    
}

/// 用户点赞
class UserFavorAddApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/video/collect-add"
    static let kVideo_id = "video_id"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return UserFavorAddApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
    
}

/// 折扣卷兑换Api
class WelCardConvertApi: XSVideoBaseAPI {
    /// 卷码
    static let kCode = "code"
    
    static let kUrlValue = "api/user/exchange-info"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return WelCardConvertApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
    
}

class CoinConvertApi: XSVideoBaseAPI {
    /// 卷码
    static let kCode = "code"
    
    static let kUrlValue = "api/user/exchange"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return CoinConvertApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
    
}

