//
//  TopicComments.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/9.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation
import NicooNetwork

/// 查询视频评论列表Api
class TopicCommentListApi: XSVideoBaseAPI {
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 20
    
    static let kTopic_Id = "topic_content_id"
    static let kUrlValue = "/\(ConstValue.kApiVersion)/topic/comment-list"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/topic/comment-list"
    }
    override func shouldCache() -> Bool {
        return false
    }
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [TopicCommentListApi.kUrl: TopicCommentListApi.kUrlValue,
                                        TopicCommentListApi.kMethod: TopicCommentListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [TopicCommentListApi.kPageNumber: pageNumber,
                                        TopicCommentListApi.kPageCount: TopicCommentListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[TopicCommentListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
    
}


/// 视频评论Api  （用户发评论）
class TopicCommentApi: XSVideoBaseAPI {
    
    static let kTopic_Id = "topic_content_id"
    static let kContent = "content"
    static let kComment_id = "comment_id"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/topic/comment"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/topic/comment"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ?  super.requestType() : .post
    }
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [TopicCommentApi.kUrl: TopicCommentApi.kUrlValue,
                                        TopicCommentApi.kMethod: TopicCommentApi.kMethodValue]
        allParams[TopicCommentApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

///  查询动态子评论列表Api
class TopicSonCommentListApi: XSVideoBaseAPI {
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 5
    
    static let kComment_id = "comment_id"
    static let kTopic_Id = "topic_content_id"
    static let kUrlValue = "/\(ConstValue.kApiVersion)/topic/comment-list"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/topic/comment-list"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [TopicSonCommentListApi.kUrl: TopicSonCommentListApi.kUrlValue,
                                        TopicSonCommentListApi.kMethod: TopicSonCommentListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [TopicSonCommentListApi.kPageCount: TopicSonCommentListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[TopicSonCommentListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
    
}

/// 视频评论点赞
class TopicCommentLikeApi: XSVideoBaseAPI {
    
    static let kComment_id = "comment_id"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/topic/comment-like"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/topic/comment-like"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ?  super.requestType() : .post
    }
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [TopicCommentLikeApi.kUrl: TopicCommentLikeApi.kUrlValue,
                                        TopicCommentLikeApi.kMethod: TopicCommentLikeApi.kMethodValue]
        allParams[TopicCommentLikeApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}
