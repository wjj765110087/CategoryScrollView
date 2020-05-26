//
//  VideoListApi.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/23.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit
import NicooNetwork

//热门视频列表（包含广告）API
class HotListApi: XSVideoBaseAPI {
    
   static let kUrlValue = "api/video/video-ad-list"
    
    static let kType_id = "type_id"        ///类型id指定分类的视频
    static let kSort = "sort"               ///按照什么排序:online_time最新排序 play_count:最热排序
    
    static let kSort_new = "online_time"   ///最新排序 value
    static let kSort_hot = "play_count"    ///最热排序 value
    
    //分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 20
    
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
        return HotListApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String : Any]?) -> [String : Any]? {
        var newParams: [String: Any] = [HotListApi.kPageNumber: pageNumber, HotListApi.kPageCount: HotListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        return super.reform(newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        return true
    }
    override func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {
        self.pageNumber += 1
    }
    
}












