//
//  DiscoverAPI.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/7.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import Foundation
import NicooNetwork

/// 发现视频列表
class DiscoveryVideoListApi: XSVideoBaseAPI {
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 12

    static let kUrlValue = "/\(ConstValue.kApiVersion)/video-cat/recommendes"
    static let kMethodValue = "GET"
    
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video-cat/recommendes"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [DiscoveryVideoListApi.kUrl: DiscoveryVideoListApi.kUrlValue,
                                        DiscoveryVideoListApi.kMethod: DiscoveryVideoListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [DiscoveryVideoListApi.kPageNumber: pageNumber,
                                        DiscoveryVideoListApi.kPageCount: DiscoveryVideoListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[DiscoveryVideoListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        return true
    }
    override func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {
        self.pageNumber += 1
    }
    
}

/// 发现顶部分类
class DiscoveryTitleListApi: XSVideoBaseAPI {
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 100
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video-cat/list"
    static let kMethodValue = "GET"
    
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video-cat/list"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [DiscoveryTitleListApi.kUrl: DiscoveryTitleListApi.kUrlValue,
                                        DiscoveryTitleListApi.kMethod: DiscoveryTitleListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [DiscoveryTitleListApi.kPageNumber: pageNumber,
                                        DiscoveryTitleListApi.kPageCount: DiscoveryTitleListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[DiscoveryTitleListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
    
}

///发现首页推荐广告
class DiscoverAdContentApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/ad-banner"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/ad-banner"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [DiscoverAdContentApi.kUrl: DiscoverAdContentApi.kUrlValue,
                                        DiscoverAdContentApi.kMethod: DiscoverAdContentApi.kMethodValue]
        allParams[DiscoverAdContentApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

///排行榜
class DiscoverRankListApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video-rank/list"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
         return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video-rank/list"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [DiscoverRankListApi.kUrl: DiscoverRankListApi.kUrlValue,
                                        DiscoverRankListApi.kMethod: DiscoverRankListApi.kMethodValue]
        allParams[DiscoverRankListApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}


///排行榜详情
class DiscoverRankDetailApi: XSVideoBaseAPI {
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kRankType = "type"
    static let kDefaultCount = 10
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video-rank"
    static let kMethodValue = "GET"
    
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video-rank"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [DiscoverRankDetailApi.kUrl: DiscoverRankDetailApi.kUrlValue,
                                        DiscoverRankDetailApi.kMethod: DiscoverRankDetailApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [DiscoverRankDetailApi.kPageNumber: pageNumber,
                                        DiscoverRankDetailApi.kPageCount: DiscoverRankDetailApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[DiscoverRankDetailApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        return true
    }
    override func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {
        self.pageNumber += 1
    }
}

//MARK: -排行榜顶部广告详情
class DiscoverRankAdApi: XSVideoBaseAPI {
    static let kUrlValue = "/\(ConstValue.kApiVersion)/ad-detail"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/ad-detail"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [DiscoverRankAdApi.kUrl: DiscoverRankAdApi.kUrlValue,
                                        DiscoverRankAdApi.kMethod: DiscoverRankAdApi.kMethodValue]
        allParams[DiscoverRankAdApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

//MARK: -发现的原创
class DiscoverDIYApi: XSVideoBaseAPI {
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/lists"
    static let kMethodValue = "GET"
    static let k_isCoins = "is_coins"
    
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/lists"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [DiscoverDIYApi.kUrl: DiscoverDIYApi.kUrlValue,
                                        DiscoverDIYApi.kMethod: DiscoverDIYApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [DiscoverDIYApi.kPageNumber: pageNumber,
                                        DiscoverDIYApi.kPageCount: DiscoverDIYApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[DiscoverDIYApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
}

//MARK: -推荐用户
class RecommandUserApi: XSVideoBaseAPI {
    static let kUrlValue = "/\(ConstValue.kApiVersion)/recommend/user"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/recommend/user"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [RecommandUserApi.kUrl: RecommandUserApi.kUrlValue,
                                        RecommandUserApi.kMethod: RecommandUserApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [RecommandUserApi.kPageNumber: pageNumber,
                                        RecommandUserApi.kPageCount: RecommandUserApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[RecommandUserApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
}

//MARK: -推荐话题
class RecommandTopicApi: XSVideoBaseAPI {
    static let kUrlValue = "/\(ConstValue.kApiVersion)/recommend/topic"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/recommend/topic"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [RecommandTopicApi.kUrl: RecommandTopicApi.kUrlValue,
                                        RecommandTopicApi.kMethod: RecommandTopicApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [RecommandTopicApi.kPageNumber: pageNumber,
                                        RecommandTopicApi.kPageCount: RecommandTopicApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[RecommandTopicApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
}

//MARK: -推荐动态
class RecommandTrendApi: XSVideoBaseAPI {
    static let kUrlValue = "/\(ConstValue.kApiVersion)/recommend/dynamic"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/recommend/dynamic"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [RecommandTrendApi.kUrl: RecommandTrendApi.kUrlValue,
                                        RecommandTrendApi.kMethod: RecommandTrendApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [RecommandTrendApi.kPageNumber: pageNumber,
                                        RecommandTrendApi.kPageCount: RecommandTrendApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[RecommandTrendApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
}
