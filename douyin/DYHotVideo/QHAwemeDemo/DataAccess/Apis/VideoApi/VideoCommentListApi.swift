//
//  VideoCommentListApi.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/14.
//  Copyright © 2018年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork

/// 查询视频评论列表Api
class VideoCommentListApi: XSVideoBaseAPI {
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 20
    
    static let kVideo_Id = "video_id"
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/comment-list"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/comment-list"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
 
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [VideoCommentListApi.kUrl: VideoCommentListApi.kUrlValue,
                                        VideoCommentListApi.kMethod: VideoCommentListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [VideoCommentListApi.kPageNumber: pageNumber,
                                        VideoCommentListApi.kPageCount: VideoCommentListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[VideoCommentListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
    
}


/// 视频评论Api  （用户发评论）
class VideoCommentApi: XSVideoBaseAPI {
    
    static let kVideo_Id = "video_id"
    static let kContent = "content"
    static let kComment_id = "comment_id"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/comment"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/comment"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ?  super.requestType() : .post
    }
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [VideoCommentApi.kUrl: VideoCommentApi.kUrlValue,
                                        VideoCommentApi.kMethod: VideoCommentApi.kMethodValue]
        allParams[VideoCommentApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

///  查询子视频列表Api
class VideoSonCommentListApi: XSVideoBaseAPI {
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 5
    
    static let kComment_id = "comment_id"
    static let kVideo_Id = "video_id"
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/comment-list"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/comment-list"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [VideoSonCommentListApi.kUrl: VideoSonCommentListApi.kUrlValue,
                                        VideoSonCommentListApi.kMethod: VideoSonCommentListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [VideoSonCommentListApi.kPageCount: VideoSonCommentListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[VideoSonCommentListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
    
}

/// 视频评论点赞
class VideoCommentLikeApi: XSVideoBaseAPI {
    
    static let kComment_id = "comment_id"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/comment-like"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/comment-like"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ?  super.requestType() : .post
    }
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [VideoCommentLikeApi.kUrl: VideoCommentLikeApi.kUrlValue,
                                        VideoCommentLikeApi.kMethod: VideoCommentLikeApi.kMethodValue]
        allParams[VideoCommentLikeApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}




/// 查询广告评论列表Api
class AdCommentListApi: XSVideoBaseAPI {

    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 20

    static let kAd_id = "ad_id"
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/ad/comment/lists"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/ad/comment/lists"
    }

    override func shouldCache() -> Bool {
        return false
    }

    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [AdCommentListApi.kUrl: AdCommentListApi.kUrlValue,
                                        AdCommentListApi.kMethod: AdCommentListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [AdCommentListApi.kPageNumber: pageNumber,
                                        AdCommentListApi.kPageCount: AdCommentListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[AdCommentListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }

    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }

}


///     对广告发起评论Api  （用户发评论）
class AdCommentApi: XSVideoBaseAPI {

    static let kAd_id = "ad_id"
    static let kContent = "content"

    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/user/ad/comment"
    static let kMethodValue = "POST"

    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }

    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/user/ad/comment"
    }

    override func shouldCache() -> Bool {
        return false
    }

    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ?  super.requestType() : .post
    }
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [AdCommentApi.kUrl: AdCommentApi.kUrlValue,
                                        AdCommentApi.kMethod: AdCommentApi.kMethodValue]
        allParams[AdCommentApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}
