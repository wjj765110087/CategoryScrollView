//
//  ComunityApis.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation
import NicooNetwork

/// 话题推荐列表
class TalksListApi: XSVideoBaseAPI {
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 15
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/topic"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/topic"
    }
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [TalksListApi.kUrl: TalksListApi.kUrlValue,
                                        TalksListApi.kMethod: TalksListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [TalksListApi.kPageNumber: pageNumber,
                                        TalksListApi.kPageCount: TalksListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[TalksListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        return true
    }
    override func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {
        pageNumber += 1
    }
}

/// 话题关注列表
class TalksCollectListApi: XSVideoBaseAPI {
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 15
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/topic/collect-items"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/topic/collect-items"
    }
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [TalksCollectListApi.kUrl: TalksCollectListApi.kUrlValue,
                                        TalksCollectListApi.kMethod: TalksCollectListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [TalksCollectListApi.kPageNumber: pageNumber,
                                        TalksCollectListApi.kPageCount: TalksCollectListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[TalksCollectListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        return true
    }
    override func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {
        pageNumber += 1
    }
    
}

/// 话题搜索列表
class TalksSearchListApi: XSVideoBaseAPI {
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 15
    
    static let kTitle = "title"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/search/topic"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/search/topic"
    }
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [TalksSearchListApi.kUrl: TalksSearchListApi.kUrlValue,
                                        TalksSearchListApi.kMethod: TalksSearchListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [TalksSearchListApi.kPageNumber: pageNumber,
                                        TalksSearchListApi.kPageCount: TalksSearchListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[TalksSearchListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        return true
    }
    override func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {
        pageNumber += 1
    }
    
}

/// 用户动态列表
class UserTopicListApi: XSVideoBaseAPI {
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 15
  
    /// 外部参数
    static let kUserId = "uid" // -1: 所有人
    static let kIs_recommend = "is_recommend"
    static let kIs_attention = "is_attention"
    static let kTopic_id = "topic_id"
    static let kType = "type"
    static let kOrder = "order"    // 排序
    
    
    static let kCreated_at = "created_at"  // 最新
    static let kLike = "like"              // 最热
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/topic/user"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/topic/user"
    }
    override func shouldCache() -> Bool {
        return false
    }
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserTopicListApi.kUrl: UserTopicListApi.kUrlValue,
                                        UserTopicListApi.kMethod: UserTopicListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [UserTopicListApi.kPageNumber: pageNumber,
                                        UserTopicListApi.kPageCount: UserTopicListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[UserTopicListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        return true
    }
    override func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {
        pageNumber += 1
    }
    
}
/// 搜索动态列表
class TopicSearchListApi: XSVideoBaseAPI {
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 15
    
    /// 外部参数
    static let kTitle = "keyword" // -1: 所有人
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/search/dynamic"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/search/dynamic"
    }
    override func shouldCache() -> Bool {
        return false
    }
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [TopicSearchListApi.kUrl: TopicSearchListApi.kUrlValue,
                                        TopicSearchListApi.kMethod: TopicSearchListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [TopicSearchListApi.kPageNumber: pageNumber,
                                        TopicSearchListApi.kPageCount: TopicSearchListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[TopicSearchListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        return true
    }
    override func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {
        pageNumber += 1
    }
    
}


/// 话题加入关注
class TalksAddFollowApi: XSVideoBaseAPI {
    
    static let kTalkId = "topic_id"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/topic/collect-add"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/topic/collect-add"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [TalksAddFollowApi.kUrl: TalksAddFollowApi.kUrlValue,
                                        TalksAddFollowApi.kMethod: TalksAddFollowApi.kMethodValue]
        allParams[TalksAddFollowApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

/// 话题取消关注
class TalksDeleteFollowApi: XSVideoBaseAPI {
    
    static let kTalkId = "topic_id"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/topic/collect-del"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/topic/collect-del"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [TalksDeleteFollowApi.kUrl: TalksDeleteFollowApi.kUrlValue,
                                        TalksDeleteFollowApi.kMethod: TalksDeleteFollowApi.kMethodValue]
        allParams[TalksDeleteFollowApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

/// 动态点赞
class TopicFavorApi: XSVideoBaseAPI {
    
    static let kTopicId = "topic_id"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/topic/like"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/topic/like"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [TopicFavorApi.kUrl: TopicFavorApi.kUrlValue,
                                        TopicFavorApi.kMethod: TopicFavorApi.kMethodValue]
        allParams[TopicFavorApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

///动态详情
class TopicDetailApi: XSVideoBaseAPI {
    
    static let kTopicId = "id"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/topic/info"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/topic/info"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [TopicDetailApi.kUrl: TopicDetailApi.kUrlValue,
                                        TopicDetailApi.kMethod: TopicDetailApi.kMethodValue]
        allParams[TopicDetailApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

/// 动态删除
class TopicDeleteApi: XSVideoBaseAPI {
    
    static let kTopicId = "id"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/topic/content-del"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/topic/content-del"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [TopicDeleteApi.kUrl: TopicDeleteApi.kUrlValue,
                                        TopicDeleteApi.kMethod: TopicDeleteApi.kMethodValue]
        allParams[TopicDeleteApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

