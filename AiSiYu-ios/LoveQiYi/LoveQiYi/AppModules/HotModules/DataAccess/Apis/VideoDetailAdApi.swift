//
//  VideoDetailAdApi.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/24.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit
import NicooNetwork

///视频详情广告获取API
class VideoDetailAdApi: XSVideoBaseAPI {

    static let kUrlValue = "api/video/ad-list"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return VideoDetailAdApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String : Any]?) -> [String : Any]? {
        return super.reform(params)
    }
}

///视频详情的猜你喜欢API
class VideoGuessLikeApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/video/guess-like"
    static let kVideoId = "video_id"
    
    //分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 20
    
    var pageNumber: Int = 1
    
    override func loadData() -> Int {
        pageNumber = 1
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    func loadNextPage() -> Int {
        self.pageNumber += 1
        if self.isLoading {
            return 0
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return VideoGuessLikeApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String : Any]?) -> [String : Any]? {
        return super.reform(params)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        return true
    }
    override func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {
        self.pageNumber += 1
    }
}

/// 视频详情API
class HotVideoDetailApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/video/info"
    static let kVideoId = "video_id"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return HotVideoDetailApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String : Any]?) -> [String : Any]? {
        return super.reform(params)
    }
}

/// 视频详情广告信息配置API
class VipAdInfoApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/common/vip-ad-info"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return VipAdInfoApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String : Any]?) -> [String : Any]? {
        return super.reform(params)
    }
}

/// 视频详情记录观看时间
class VideoViewTimeApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/video/view-time"
    
    static let kVideo_id = "video_id"
    static let kTime = "t"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return VideoViewTimeApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String : Any]?) -> [String : Any]? {
        return super.reform(params)
    }
}

/// 视频详情记录观看时间
class DownloadAuthApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/video/download-auth"
    
    static let kVideo_id = "video_id"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return DownloadAuthApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String : Any]?) -> [String : Any]? {
        return super.reform(params)
    }
}

