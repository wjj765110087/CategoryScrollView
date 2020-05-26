//
//  AcountApis.swift
//  YellowBook
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019年 mac. All rights reserved.
//

import Foundation
import NicooNetwork


// 查询用户信息Api
class UserInfoApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/user/info"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return UserInfoApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
    
}

/// 金币明细 列表
class CoinRecordApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/user/coupon-history"
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 20
    
    var pageNumber: Int = 1
    
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
        return CoinRecordApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        /// 分页参数
        var newParams: [String: Any] = [CoinRecordApi.kPageNumber: pageNumber,
                                        CoinRecordApi.kPageCount: CoinRecordApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        return super.reform(newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        return true
    }
    override func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {
        self.pageNumber += 1
    }
    
}

/// 用户邀请记录
class UserInvitedListApi: XSVideoBaseAPI {
    static let kUrlValue = "api/user/invite-list"
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 30
    
    var pageNumber: Int = 1
    
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
        return UserInvitedListApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        /// 分页参数
        var newParams: [String: Any] = [UserInvitedListApi.kPageNumber: pageNumber,
                                        UserInvitedListApi.kPageCount: UserInvitedListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        return super.reform(newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        return true
    }
    override func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {
        self.pageNumber += 1
    }
}

// 用户反馈问题列表Api
class UserQuestionApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/feed/list"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return UserQuestionApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return true
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        
        return super.reform(params)
    }
    
}

/// 用户反馈列别
class UserFeedLsApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/feed/mine"
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 15
    
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
        return UserFeedLsApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        /// 分页参数
        var newParams: [String: Any] = [UserFeedLsApi.kPageNumber: pageNumber,
                                        UserFeedLsApi.kPageCount: UserFeedLsApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        return super.reform(newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
    
}

/// 用户反馈消息列表
class UserMsgLsApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/feed/reply-list"
    
    static let kFeed_id = "feed_id"
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 3000
    
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
        return UserMsgLsApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        /// 分页参数
        var newParams: [String: Any] = [UserMsgLsApi.kPageNumber: pageNumber,
                                        UserMsgLsApi.kPageCount: UserMsgLsApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        return super.reform(newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
    
}


class FeedReplyApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/feed/reply"
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
        return FeedReplyApi.kUrlValue
    }
    override func shouldCache() -> Bool {
        return true
    }
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
}

// MARK: - : 历史光看 Api
class HistoryApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/video/history"
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 15
    
    var pageNumber: Int = 1
    
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
        return HistoryApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        /// 分页参数
        var newParams: [String: Any] = [HistoryApi.kPageNumber: pageNumber,
                                        HistoryApi.kPageCount: HistoryApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        return super.reform(newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        return true
    }
    override func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {
        self.pageNumber += 1
    }
}

// MARK: - : 收藏列表 Api
class CollectedLsApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/video/collect-list"
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 15
    
    var pageNumber: Int = 1
    
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
        return CollectedLsApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        /// 分页参数
        var newParams: [String: Any] = [CollectedLsApi.kPageNumber: pageNumber,
                                        CollectedLsApi.kPageCount: CollectedLsApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        return super.reform(newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        return true
    }
    override func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {
        self.pageNumber += 1
    }
}



/// 查询用户历史订单列表Api
class UserOrderListApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/order/list"
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 15
    
    var pageNumber: Int = 1
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
        return UserOrderListApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        /// 分页参数
        var newParams: [String: Any] = [UserOrderListApi.kPageNumber: pageNumber,
                                        UserOrderListApi.kPageCount: UserOrderListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        return super.reform(newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        
        return true
    }
    override func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {
        self.pageNumber += 1
    }
    
}

//MARK: -  支付相接口

/// 支付方术 列表
class PayTypeLsApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/recharge/pay-list"
    static let kAmount = "amount"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return PayTypeLsApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
    
}

/// 订单生成
class UserOrderAddApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/order/add"
    
    static let kCharge_id = "recharge_id" // 套餐id 0 没有就传0
    static let kDevice_type = "device_type"  //设备类型  ios android pc
    static let kDevice_code = "device_code"   // 设备号
    static let kPay_type = "pay_type"    // 支付方式
   
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return UserOrderAddApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        
        return super.reform(params)
    }
    
}

/// 支付套餐 + 会员特权 /// 充值金额 列表
class RechargeMenuApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/recharge/list"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return RechargeMenuApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }

    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
}

