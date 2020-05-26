//
//  UserThumAddApi.swift
//  XSVideo
//
//  Created by pro5 on 2019/1/5.
//  Copyright © 2019年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork

/// 用户 点击购买调用
class UserBuyVipActionApi: XSVideoBaseAPI {

    static let kVip_id = "vip_id"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/vip"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/vip"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserBuyVipActionApi.kUrl: UserBuyVipActionApi.kUrlValue,
                                        UserBuyVipActionApi.kMethod: UserBuyVipActionApi.kMethodValue]
        allParams[UserBuyVipActionApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}


/// 用户 支付通道列表
class UserPayTypeListApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/auto-pay-list"
    static let kMethodValue = "GET"
    
    static let kAmount = "amount"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/auto-pay-list"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserPayTypeListApi.kUrl: UserPayTypeListApi.kUrlValue,
                                        UserPayTypeListApi.kMethod: UserPayTypeListApi.kMethodValue]
        allParams[UserPayTypeListApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}


/// 用户 提现 api
class UserGetCashApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/wallet/withdraw"
    static let kMethodValue = "POST"
    
    static let kDevice_Code = "device_code"
    static let kDevice_type = "device_type"
    
    static let kmoney = "money"
    static let kWithdraw_type = "withdraw_type" // 1:支付宝 2:银行卡
    static let kWithdraw_name = "withdraw_name"
    
    
    static let kWithdraw_cardno = "withdraw_cardno" //提现者银行卡号
    static let kWithdraw_banknam = "withdraw_banknam" // 银行名
    static let kWithdraw_bankopen = "withdraw_bankopen" // 开户行
    
    static let kWithdraw_alipayno = "withdraw_alipayno" // 提现者支付宝账号

    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/wallet/withdraw"
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserGetCashApi.kUrl: UserGetCashApi.kUrlValue,
                                        UserGetCashApi.kMethod: UserGetCashApi.kMethodValue]
        allParams[UserGetCashApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}

/// 金币购买视频
class UseBuyVideoApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/video/buy"
    static let kMethodValue = "POST"
    
    static let kVideoId = "video_id"
    
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/video/buy"
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UseBuyVideoApi.kUrl: UseBuyVideoApi.kUrlValue,
                                        UseBuyVideoApi.kMethod: UseBuyVideoApi.kMethodValue]
        allParams[UseBuyVideoApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}

