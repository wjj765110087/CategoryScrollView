//
//  VipCardsApi.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/15.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation
import NicooNetwork

/// VIP卡 列表
class VipCardsApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/vip/list"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/vip/list"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    // post 请求写这个方法 ，因为加密后 的外层Api 是post, 非加密时不走外层Api
    
//    override func requestType() -> NicooAPIManagerRequestType {
//        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
//    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [VipCardsApi.kUrl: VipCardsApi.kUrlValue,
                                        VipCardsApi.kMethod: VipCardsApi.kMethodValue]
        allParams[VipCardsApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}

/// 上门服务 列表
class UpDoorServerApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/service/list"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/service/list"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    // post 请求写这个方法 ，因为加密后 的外层Api 是post, 非加密时不走外层Api
    
//    override func requestType() -> NicooAPIManagerRequestType {
//        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
//    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UpDoorServerApi.kUrl: UpDoorServerApi.kUrlValue,
                                        UpDoorServerApi.kMethod: UpDoorServerApi.kMethodValue]
        allParams[UpDoorServerApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}
