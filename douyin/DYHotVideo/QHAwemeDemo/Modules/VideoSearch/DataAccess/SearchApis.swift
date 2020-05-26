//
//  SearchApis.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/10.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation
import NicooNetwork

/// 搜多推荐关键字
class SearchKeyRecommendApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/search/key-word"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/search/key-word"
    }
    
    override func shouldCache() -> Bool {
        return true
    }
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [SearchKeyRecommendApi.kUrl: SearchKeyRecommendApi.kUrlValue,
                                        SearchKeyRecommendApi.kMethod: SearchKeyRecommendApi.kMethodValue]
        allParams[SearchKeyRecommendApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

/// 搜索视频
class SearchVideoApi: XSVideoBaseAPI {
    // 分页参数
    static let kTitle = "title"
    static let kKeywords = "keywords"
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 15
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/search/video"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/search/video"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [SearchVideoApi.kUrl: SearchVideoApi.kUrlValue,
                                        SearchVideoApi.kMethod: SearchVideoApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [SearchVideoApi.kPageNumber: pageNumber,
                                        SearchVideoApi.kPageCount: SearchVideoApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[SearchVideoApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        return true
    }
    override func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {
        self.pageNumber += 1
    }
}

///搜索用户
class SearchUserApi: XSVideoBaseAPI {
    static let kw = "w"
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 15
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/search/user"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/search/user"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [SearchUserApi.kUrl: SearchUserApi.kUrlValue,
                                        SearchUserApi.kMethod: SearchUserApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [SearchUserApi.kPageNumber: pageNumber,
                                        SearchUserApi.kPageCount: SearchUserApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[SearchUserApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
}
