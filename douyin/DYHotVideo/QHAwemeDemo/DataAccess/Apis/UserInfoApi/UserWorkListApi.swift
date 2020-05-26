//
//  UserWorkListApi.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/5/3.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation
import NicooNetwork

// 查询用户作品列表Api
class UserWorkListApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/video/upload/lists"
    static let kMethodValue = "GET"
    
    static let kUserId = "target_uid"
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 15
    
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/video/upload/lists"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserWorkListApi.kUrl: UserWorkListApi.kUrlValue,
                                        UserWorkListApi.kMethod: UserWorkListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [UserWorkListApi.kPageNumber: pageNumber,
                                        UserWorkListApi.kPageCount: UserWorkListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[UserWorkListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
    
}

///购买视频列表
class UserBuyVideoListApi: XSVideoBaseAPI {
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/buy/list"
    static let kMethodValue = "GET"
    
    static let kTarget_uid = "target_uid"
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 15
    
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/buy/list"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserBuyVideoListApi.kUrl: UserBuyVideoListApi.kUrlValue,
                                        UserBuyVideoListApi.kMethod: UserBuyVideoListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [UserBuyVideoListApi.kPageNumber: pageNumber,
                                        UserBuyVideoListApi.kPageCount: UserBuyVideoListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[UserBuyVideoListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
}
