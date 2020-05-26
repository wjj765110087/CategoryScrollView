//
//  VideoModuleListApi.swift
//  XSVideo
//
//  Created by pro5 on 2019/1/11.
//  Copyright © 2019年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork

/// 系列列表
class VideoSeriesListApi: XSVideoBaseAPI {
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kType = "type"       ///XILIE:系列 FAXIAN1:发现1 FAXIAN2:发现2 SEARCH:搜索
    static let kDefaultCount = 12
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/keys/lists"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/keys/lists"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [VideoSeriesListApi.kUrl: VideoSeriesListApi.kUrlValue,
                                        VideoSeriesListApi.kMethod: VideoSeriesListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [VideoSeriesListApi.kPageNumber: pageNumber, VideoSeriesListApi.kPageCount: VideoSeriesListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[VideoSeriesListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
    
}


/// 系列下视频列表
class SeriesVideoListApi: XSVideoBaseAPI {
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 12
    
    /// 外部参数
    static let kKeyId = "view_key_id"
    
    /// 加密借口 统一参数
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/series/video-lists"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/series/video-lists"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [SeriesVideoListApi.kUrl: SeriesVideoListApi.kUrlValue,
                                        SeriesVideoListApi.kMethod: SeriesVideoListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [SeriesVideoListApi.kPageNumber: pageNumber, SeriesVideoListApi.kPageCount: SeriesVideoListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[SeriesVideoListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
    
}

