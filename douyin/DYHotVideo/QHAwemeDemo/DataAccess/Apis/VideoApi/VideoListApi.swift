//
//  VideoListApi.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/12.
//  Copyright © 2018年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork

/// 视频分类筛选中的  视频列表
class VideoListApi: XSVideoBaseAPI {
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 12
    
 
    static let key_id = "key_id" // 视频关键字Id
    static let kVideo_title = "video_title"  // 视频名称
    static let kUpdateded_at  = "updateded_at"  // 默认值 desc
    static let kPlay_count = "play_count" // 默认值 desc
    static let kKeyword = "keywords"   // 按关键词查询
    
    static let kDefaultCreat_at = "desc" // created_at 默认值
    static let kDefaultPlay_count = "desc" // 播放数： 默认值
    
    
   
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/lists"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/lists"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [VideoListApi.kUrl: VideoListApi.kUrlValue,
                                        VideoListApi.kMethod: VideoListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [VideoListApi.kPageNumber: pageNumber,
                                        VideoListApi.kPageCount: VideoListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[VideoListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
   
}



/// 视频分类筛选中的  视频列表
class VideoHomeListApi: XSVideoBaseAPI {
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 15
    
    
    static let key_id = "key_id" // 视频关键字Id
    static let kVideo_title = "video_title"  // 视频名称
    static let kUpdateded_at  = "updateded_at"  // 默认值 desc
    static let kPlay_count = "play_count" // 默认值 desc
    static let kKeyword = "keywords"   // 按关键词查询
    
    static let kDefaultCreat_at = "desc" // created_at 默认值
    static let kDefaultPlay_count = "desc" // 播放数： 默认值
    
    
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/home-recommend"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/home-recommend"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [VideoHomeListApi.kUrl: VideoHomeListApi.kUrlValue,
                                        VideoHomeListApi.kMethod: VideoHomeListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [VideoHomeListApi.kPageNumber: pageNumber,
                                        VideoHomeListApi.kPageCount: VideoHomeListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[VideoHomeListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
    
}


/// 首页关注 视频列表
class VideoAttentionListApi: XSVideoBaseAPI {
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 15
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/home-flow"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/home-flow"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [VideoAttentionListApi.kUrl: VideoAttentionListApi.kUrlValue,
                                        VideoAttentionListApi.kMethod: VideoAttentionListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [VideoAttentionListApi.kPageNumber: pageNumber,
                                        VideoAttentionListApi.kPageCount: VideoAttentionListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[VideoAttentionListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
    
}

/// 活动点赞列表
class VideoActivityListApi: XSVideoBaseAPI {
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 100
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/rank"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/rank"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [VideoActivityListApi.kUrl: VideoActivityListApi.kUrlValue,
                                        VideoActivityListApi.kMethod: VideoActivityListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [VideoActivityListApi.kPageNumber: pageNumber,
                                        VideoActivityListApi.kPageCount: VideoActivityListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[VideoActivityListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
}

// 活动页Api
class VideoActivityApi: XSVideoBaseAPI {

    static let kUrlValue = "/\(ConstValue.kApiVersion)/activity/items"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/activity/items"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [VideoActivityApi.kUrl: VideoActivityApi.kUrlValue,
                                        VideoActivityApi.kMethod: VideoActivityApi.kMethodValue]
        allParams[VideoActivityApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}


/// 活动视频点赞排行列表
class ActivityRankListApi: XSVideoBaseAPI {
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 10
    
    
    static let kKey = "key" // 排行类型
    static let kTopic = "topic"
  
    static let kUrlValue = "/\(ConstValue.kApiVersion)/activity/rank"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/activity/rank"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [ActivityRankListApi.kUrl: ActivityRankListApi.kUrlValue,
                                        ActivityRankListApi.kMethod: ActivityRankListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [ActivityRankListApi.kPageNumber: pageNumber,
                                        ActivityRankListApi.kPageCount: ActivityRankListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[VideoHomeListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        return true
    }
    override func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {
        self.pageNumber += 1
    }
    
}


/// 活动视频上传数量排行列表
class ActivityRankUploadApi: XSVideoBaseAPI {
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 10
    
    
    static let kKey = "key" // 排行类型
    static let kTopic = "topic"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/activity/rank"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/activity/rank"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [ActivityRankUploadApi.kUrl: ActivityRankUploadApi.kUrlValue,
                                        ActivityRankUploadApi.kMethod: ActivityRankUploadApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [ActivityRankUploadApi.kPageNumber: pageNumber,
                                        ActivityRankUploadApi.kPageCount: ActivityRankUploadApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[ActivityRankUploadApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        return true
    }
    override func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {
        self.pageNumber += 1
    }
    
}

