//
//  MainVideoApis.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/22.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import Foundation
import NicooNetwork

// MARK: - 首页顶部分类
class MainTypeApi: XSVideoBaseAPI {

    static let kUrlValue = "api/video/type-list"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    override func methodName() -> String {
        return MainTypeApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return true
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform(params)
    }
    
}

// MARK: - : bookshop  模块 Api
class MainModulesApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/video/home"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return MainModulesApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform( params)
    }
}

// MARK: - : 猜你喜欢Api
class GuessLikeApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/video/guess-like"
    
    static let kVideo_id = "video_id"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return GuessLikeApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return true
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        return super.reform( params)
    }
    
}

//MARK: - modules(模块更多)API
class ModulesMoreApi: XSVideoBaseAPI {
    static let kUrlValue = "api/video/home-more"
    
    static let kModule_id = "module_id"
    
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
        return ModulesMoreApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String : Any]?) -> [String : Any]? {
        var newParams: [String: Any] = [ModulesMoreApi.kPageNumber: pageNumber, ModulesMoreApi.kPageCount: ModulesMoreApi.kDefaultCount]
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

