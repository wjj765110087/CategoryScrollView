//
//  UserWatchedApi.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/14.
//  Copyright © 2018年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork

/// 查询用户历史订单列表Api
class UserOrderListApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/order/list"
    static let kMethodValue = "GET"
    
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/order/list"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserOrderListApi.kUrl: UserOrderListApi.kUrlValue,
                                        UserOrderListApi.kMethod: UserOrderListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [UserOrderListApi.kPageNumber: pageNumber,
                                        UserOrderListApi.kPageCount: UserOrderListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[UserOrderListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
    
}


/// 订单生成
class UserOrderAddApi: XSVideoBaseAPI {
    
    static let kOrder_type = "order_type"  // 1:系统订单 2:用户订单 传2        会员订单2 金币订单3
    static let kVc_id = "vc_id"   // vipCard id
    //static let kU_wc_id = "u_wc_id" // 福利卡id 0 没有就传0
    static let kDevice_type = "device_type"  //设备类型  ios android pc
    static let kDevice_code = "device_code"   // 设备号
    static let kPay_type = "pay_type"    // 支付方式
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/order/add"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/order/add"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserOrderAddApi.kUrl: UserOrderAddApi.kUrlValue,
                                        UserOrderAddApi.kMethod: UserOrderAddApi.kMethodValue]
        allParams[UserOrderAddApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

// MARK: - 余额明细
class UserBalanceDetailApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/money/details"
    static let kMethodValue = "GET"
    
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/money/details"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserBalanceDetailApi.kUrl: UserBalanceDetailApi.kUrlValue,
                                        UserBalanceDetailApi.kMethod: UserBalanceDetailApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [UserBalanceDetailApi.kPageNumber: pageNumber,
                                        UserBalanceDetailApi.kPageCount: UserBalanceDetailApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[UserBalanceDetailApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
}

// MARK- 金币明细
class UserCoinsDetailApi: XSVideoBaseAPI {
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/coins/details"
    static let kMethodValue = "GET"
    
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/coins/details"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserCoinsDetailApi.kUrl: UserCoinsDetailApi.kUrlValue,
                                        UserCoinsDetailApi.kMethod: UserCoinsDetailApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [UserCoinsDetailApi.kPageNumber: pageNumber,
                                        UserCoinsDetailApi.kPageCount: UserCoinsDetailApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[UserCoinsDetailApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
}

//MARK:-金币兑换余额
class CoinChangeMoneyApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/money/coins"
    static let kMethodValue = "POST"
    static let kCoins = "coins"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/money/coins"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [CoinChangeMoneyApi.kUrl: CoinChangeMoneyApi.kUrlValue,
                                        CoinChangeMoneyApi.kMethod: CoinChangeMoneyApi.kMethodValue]
        allParams[CoinChangeMoneyApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

/// 查询用户历史钱包账单列表Api
class UserWalletRecordsApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/wallet/record/list"
    static let kMethodValue = "GET"
    
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/wallet/record/list"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserWalletRecordsApi.kUrl: UserWalletRecordsApi.kUrlValue,
                                        UserWalletRecordsApi.kMethod: UserWalletRecordsApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [UserWalletRecordsApi.kPageNumber: pageNumber,
                                        UserWalletRecordsApi.kPageCount: UserWalletRecordsApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[UserWalletRecordsApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
    
}
