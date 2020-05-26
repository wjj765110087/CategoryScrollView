//
//  NetworkRouterApi.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/24.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//  线路列表API

import UIKit

///线路保存API
class NetworkRouterSaveApi: XSVideoBaseAPI {
    
    static let kUrlValue = "api/video/channel-save"
    
    static let kKey = "key"
    
    // MARK: - Public method
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return NetworkRouterSaveApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String : Any]?) -> [String : Any]? {
        return super.reform(params)
    }
}

///线路列表API
class NetworkRouterListApi: XSVideoBaseAPI {
    static let kUrlValue = "api/video/channel-list"
    
    // MARK: - Public method
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return NetworkRouterListApi.kUrlValue
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String : Any]?) -> [String : Any]? {
        return super.reform(params)
    }
}
