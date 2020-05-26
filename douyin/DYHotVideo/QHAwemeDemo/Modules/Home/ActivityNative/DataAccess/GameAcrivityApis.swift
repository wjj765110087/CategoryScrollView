//
//  GameAcrivityApis.swift
//  QHAwemeDemo
//
//  Created by mac on 2019-12-21.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import Foundation
import NicooNetwork

///游戏主页api
class GameActivityMainApi: XSVideoBaseAPI {

    static let kUrlValue = "/\(ConstValue.kApiVersion)/game/index-tiger"
    static let kMethodValue = "POST"
    
    static let kActivity_id = "activity_id"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/game/index-tiger"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [GameActivityMainApi.kUrl: GameActivityMainApi.kUrlValue,
                                        GameActivityMainApi.kMethod: GameActivityMainApi.kMethodValue]
        allParams[GameActivityMainApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

///游戏主页 广播 api
class GameNoticesApi: XSVideoBaseAPI {

    static let kUrlValue = "/\(ConstValue.kApiVersion)/game/index-news"
    static let kMethodValue = "POST"
    
    static let kActivity_id = "activity_id"
    static let kLimit = "limit"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/game/index-news"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }

    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [GameNoticesApi.kUrl: GameNoticesApi.kUrlValue,
                                        GameNoticesApi.kMethod: GameNoticesApi.kMethodValue]
        allParams[GameNoticesApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}


///兑换奖品列表 api
class GameConvertListApi: XSVideoBaseAPI {

    static let kUrlValue = "/\(ConstValue.kApiVersion)/game/convert-list"
    static let kMethodValue = "POST"
    
    static let kActivity_id = "activity_id"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/game/convert-list"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }

    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [GameConvertListApi.kUrl: GameConvertListApi.kUrlValue,
                                        GameConvertListApi.kMethod: GameConvertListApi.kMethodValue]
        allParams[GameConvertListApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}


/// 任务列表
class GameTaskListApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/game/task"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    override func methodName() -> String {
        
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/game/task"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [GameTaskListApi.kUrl: GameTaskListApi.kUrlValue,
                                        GameTaskListApi.kMethod: GameTaskListApi.kMethodValue]
        allParams[GameTaskListApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

/// 领取任务奖品
class GetTaskRewardApi: XSVideoBaseAPI {
    
       static let kUrlValue = "/\(ConstValue.kApiVersion)/user/task/get"
       static let kMethodValue = "POST"
       
       static let kTaskId = "task_id"
    
       override func loadData() -> Int {
           if self.isLoading {
               self.cancelAllRequests()
           }
           return super.loadData()
       }
       
       override func methodName() -> String {
           return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/task/get"
       }
       
       override func shouldCache() -> Bool {
           return false
       }

       override func requestType() -> NicooAPIManagerRequestType {
           return ConstValue.kIsEncryptoApi ? super.requestType() : .post
       }
       
       override func reform(_ params: [String: Any]?) -> [String: Any]? {
           var allParams: [String: Any] = [GetTaskRewardApi.kUrl: GetTaskRewardApi.kUrlValue,
                                           GetTaskRewardApi.kMethod: GetTaskRewardApi.kMethodValue]
           allParams[GetTaskRewardApi.kParams] = params ?? [String: Any]()
           return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
       }
}

//获取中奖结果 api
class GamePlayApi: XSVideoBaseAPI {

    static let kUrlValue = "/\(ConstValue.kApiVersion)/game/play"
    static let kMethodValue = "POST"
    
    static let kActivity_id = "activity_id"
    static let kJson_data = "json_data"
 
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/game/play"
    }
    
    override func shouldCache() -> Bool {
        return false
    }

    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [GamePlayApi.kUrl: GamePlayApi.kUrlValue,
                                        GamePlayApi.kMethod: GamePlayApi.kMethodValue]
        allParams[GamePlayApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

/// 兑换奖品 api
class ConvertGiftApi: XSVideoBaseAPI {

    static let kUrlValue = "/\(ConstValue.kApiVersion)/game/convert-prize"
    static let kMethodValue = "POST"
    
    static let kActivity_id = "activity_id"
    static let kPrizero_sid = "prizero_sid"
 
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/game/convert-prize"
    }
    
    override func shouldCache() -> Bool {
        return false
    }

    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [ConvertGiftApi.kUrl: ConvertGiftApi.kUrlValue,
                                        ConvertGiftApi.kMethod: ConvertGiftApi.kMethodValue]
        allParams[ConvertGiftApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

/// 我的奖品接口
class GameGiftListApi: XSVideoBaseAPI {
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 20
  
    static let kUrlValue = "/\(ConstValue.kApiVersion)/game/my-prize"
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/game/my-prize"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [GameGiftListApi.kUrl: GameGiftListApi.kUrlValue,
                                        GameGiftListApi.kMethod: GameGiftListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [GameGiftListApi.kPageNumber: pageNumber,
                                        GameGiftListApi.kPageCount: GameGiftListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[GameGiftListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        return true
    }
    override func manager(_ manager: NicooBaseAPIManager, afterPerformSuccess response: NicooURLResponse) {
        self.pageNumber += 1
    }
    
}
