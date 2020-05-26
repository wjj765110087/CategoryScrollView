//
//  WelfareCardApi.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation
import NicooNetwork

/// 折扣福利卡   未获得 列表
class WelfareUnownedCardApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/welfare/unowned-lists"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/welfare/unowned-lists"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [WelfareUnownedCardApi.kUrl: WelfareUnownedCardApi.kUrlValue,
                                        WelfareUnownedCardApi.kMethod: WelfareUnownedCardApi.kMethodValue]
        allParams[WelfareUnownedCardApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}


/// 折扣福利卡     未使用 列表
class WelfareUnusedCardApi: XSVideoBaseAPI {
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 15
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/welfare/unused-lists"
    static let kMethodValue = "GET"
    
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/welfare/unused-lists"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [WelfareUnusedCardApi.kUrl: WelfareUnusedCardApi.kUrlValue,
                                        WelfareUnusedCardApi.kMethod: WelfareUnusedCardApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [WelfareUnusedCardApi.kPageNumber: pageNumber,
                                        WelfareUnusedCardApi.kPageCount: WelfareUnusedCardApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[WelfareUnusedCardApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
    
}

/// 折扣福利卡   已失效 列表
class WelfareInvailCardApi: XSVideoBaseAPI {
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 15
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/welfare/invalid-lists"
    static let kMethodValue = "GET"
    
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/welfare/invalid-lists"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [WelfareInvailCardApi.kUrl: WelfareInvailCardApi.kUrlValue,
                                        WelfareInvailCardApi.kMethod: WelfareInvailCardApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [WelfareInvailCardApi.kPageNumber: pageNumber,
                                        WelfareInvailCardApi.kPageCount: WelfareInvailCardApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[WelfareInvailCardApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
    
}
