//
//  File.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/14.
//  Copyright © 2018年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork

// 查询用户信息Api
class UserInfoApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/info"
    static let kMethodValue = "GET"
    
    static let kUserId = "uid"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/info"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserInfoApi.kUrl: UserInfoApi.kUrlValue,
                                        UserInfoApi.kMethod: UserInfoApi.kMethodValue]
        allParams[UserInfoApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}

// 查询用户信息Api
class UserInfoOtherApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/info"
    static let kMethodValue = "GET"
    
    static let kUserId = "uid"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/info"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserInfoOtherApi.kUrl: UserInfoOtherApi.kUrlValue,
                                        UserInfoOtherApi.kMethod: UserInfoOtherApi.kMethodValue]
        allParams[UserInfoOtherApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}

// 查询用户分销金额信息Api
class UserWalletApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/wallet/info"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/wallet/info"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserWalletApi.kUrl: UserWalletApi.kUrlValue,
                                        UserWalletApi.kMethod: UserWalletApi.kMethodValue]
        allParams[UserWalletApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}

// 金币套餐
class CoinListApi: XSVideoBaseAPI {
    static let kUrlValue = "/\(ConstValue.kApiVersion)/coins-list"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/coins-list"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String : Any]?) -> [String : Any]? {
        var allParams: [String: Any] = [CoinListApi.kUrl: CoinListApi.kUrlValue,
                                        CoinListApi.kMethod: CoinListApi.kMethodValue]
        allParams[CoinListApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}


class FeedReplyApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/feed-reply"
    static let kMethodValue = "POST"
    
    static let kFeed_id = "feed_id"
    static let kType = "type"    /// 字符串 1: 文字。2:图片
    static let kContent = "content"   /// 字符串。 文字 或者图片名
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/feed-reply"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [FeedReplyApi.kUrl: FeedReplyApi.kUrlValue,
                                        FeedReplyApi.kMethod: FeedReplyApi.kMethodValue]
        allParams[FeedReplyApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

/// 用户反馈消息列表
class UserMsgLsApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/feed-reply-list"
    
    static let kFeed_id = "feed_id"
    static let kMethodValue = "GET"
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 30
    
    private var pageNumber: Int = 1
    // MARK: - Public method
    
    override func loadData() -> Int {
        self.pageNumber = 1
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    func loadNextPage() -> Int {
        if self.isLoading {
            return 0
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/feed-reply-list"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserMsgLsApi.kUrl: UserMsgLsApi.kUrlValue,
                                        UserMsgLsApi.kMethod: UserMsgLsApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [UserMsgLsApi.kPageNumber: pageNumber,
                                        UserMsgLsApi.kPageCount: UserMsgLsApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[UserMsgLsApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
    
}


/// 用户反馈列别
class UserFeedLsApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/feedback/mine"
    
    static let kMethodValue = "GET"
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 500
    
    private var pageNumber: Int = 1
    // MARK: - Public method
    
    override func loadData() -> Int {
        self.pageNumber = 1
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    func loadNextPage() -> Int {
        if self.isLoading {
            return 0
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/feedback/mine"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserFeedLsApi.kUrl: UserFeedLsApi.kUrlValue,
                                        UserFeedLsApi.kMethod: UserFeedLsApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [UserFeedLsApi.kPageNumber: pageNumber,
                                        UserFeedLsApi.kPageCount: UserFeedLsApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[UserFeedLsApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
    
}

// 查询用户关注数量Api
class UserFollowCountApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user-follow/count"
    static let kMethodValue = "GET"
    static let kUserId = "target_uid"
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user-follow/count"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserFollowCountApi.kUrl: UserFollowCountApi.kUrlValue,
                                        UserFollowCountApi.kMethod: UserFollowCountApi.kMethodValue]
        allParams[UserFollowCountApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}

// 查询用户粉丝数量Api
class UserFansCountApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user-fans/count"
    static let kMethodValue = "GET"
    
    static let kUserId = "target_uid"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user-fans/count"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserFansCountApi.kUrl: UserFansCountApi.kUrlValue,
                                        UserFansCountApi.kMethod: UserFansCountApi.kMethodValue]
        allParams[UserFansCountApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}

// 编辑资料
class UserUpdateInfoApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/update-info"
    static let kMethodValue = "POST"
    static let kKey = "key"
    static let kValue = "value"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/update-info"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserUpdateInfoApi.kUrl: UserUpdateInfoApi.kUrlValue,
                                        UserUpdateInfoApi.kMethod: UserUpdateInfoApi.kMethodValue]
        allParams[UserUpdateInfoApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

//推广交流群
class UserInviteLinkApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/invite-link"
    static let kMethodValue = "GET"

    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/invite-link"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
//    override func requestType() -> NicooAPIManagerRequestType {
//        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
//    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserInviteLinkApi.kUrl: UserInviteLinkApi.kUrlValue,
                                        UserInviteLinkApi.kMethod: UserInviteLinkApi.kMethodValue]
        allParams[UserInviteLinkApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}
