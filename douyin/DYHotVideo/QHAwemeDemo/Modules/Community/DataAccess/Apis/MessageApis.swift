//
//  MessageApis.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/8.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

///最新数量
class MessageApis: XSVideoBaseAPI {

    static let kUrlValue = "/\(ConstValue.kApiVersion)/message/new-num"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/message/new-num"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .get
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [MessageApis.kUrl: MessageApis.kUrlValue,
                                        MessageApis.kMethod: MessageApis.kMethodValue]
        allParams[MessageApis.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}


///更新消息最大的max-Id
class UpdateMessageMaxIdApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/message/update"
    static let kTopic_id = "topic_id"
    static let kAlias = "alias"
    static let kMax_id = "max_id"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/message/update"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UpdateMessageMaxIdApi.kUrl: UpdateMessageMaxIdApi.kUrlValue,
                                        UpdateMessageMaxIdApi.kMethod: UpdateMessageMaxIdApi.kMethodValue]
        allParams[UpdateMessageMaxIdApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

///通知消息列表
class NoticeMessageListApi: XSVideoBaseAPI {
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 12
    static let kAlias = "alias"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/message/list?alias=NOTICE-MSG"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/message/list?alias=NOTICE-MSG"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [NoticeMessageListApi.kUrl: NoticeMessageListApi.kUrlValue,
                                        NoticeMessageListApi.kMethod: NoticeMessageListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [NoticeMessageListApi.kPageNumber: pageNumber,
                                        NoticeMessageListApi.kPageCount: NoticeMessageListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[NoticeMessageListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
}

/// 点赞通知
class PraiseMessageListApi: XSVideoBaseAPI {
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 12
    static let kAlias = "alias"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/message/list?alias=PRAISE-MSG"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/message/list?alias=PRAISE-MSG"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [PraiseMessageListApi.kUrl: PraiseMessageListApi.kUrlValue,
                                        PraiseMessageListApi.kMethod: PraiseMessageListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [PraiseMessageListApi.kPageNumber: pageNumber,
                                        PraiseMessageListApi.kPageCount: PraiseMessageListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[PraiseMessageListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
}

///评论通知
class CommentMessageListApi: XSVideoBaseAPI {
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 12
    static let kAlias = "alias"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/message/list?alias=COMMENT-MSG"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/message/list?alias=COMMENT-MSG"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [CommentMessageListApi.kUrl: CommentMessageListApi.kUrlValue,
                                        CommentMessageListApi.kMethod: CommentMessageListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [CommentMessageListApi.kPageNumber: pageNumber,
                                        CommentMessageListApi.kPageCount: CommentMessageListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[CommentMessageListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
}

///粉丝通知
class FansMessageListApi: XSVideoBaseAPI {
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 12
    static let kAlias = "alias"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/message/list?alias=FOLLOWER-MSG"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/message/list?alias=FOLLOWER-MSG"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [FansMessageListApi.kUrl: FansMessageListApi.kUrlValue,
                                        FansMessageListApi.kMethod: FansMessageListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [FansMessageListApi.kPageNumber: pageNumber,
                                        FansMessageListApi.kPageCount: FansMessageListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[FansMessageListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
}

///系统消息列表
class SystemMessageListApi: XSVideoBaseAPI {
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 12
    static let kAlias = "alias"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/message/list?alias=SYSTEM-MSG"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/message/list?alias=SYSTEM-MSG"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [SystemMessageListApi.kUrl: SystemMessageListApi.kUrlValue,
                                        SystemMessageListApi.kMethod: SystemMessageListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [SystemMessageListApi.kPageNumber: pageNumber,
                                        SystemMessageListApi.kPageCount: SystemMessageListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[SystemMessageListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
}
