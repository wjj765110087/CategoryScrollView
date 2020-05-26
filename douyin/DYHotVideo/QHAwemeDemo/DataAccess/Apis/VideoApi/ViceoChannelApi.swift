//
//  ViceoChannelApi.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/22.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation
import NicooNetwork

/// 服务器线路Api
class VideoChannelApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/channel"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return  ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/channel"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [VideoChannelApi.kUrl: VideoChannelApi.kUrlValue,
                                        VideoChannelApi.kMethod: VideoChannelApi.kMethodValue]
        allParams[VideoChannelApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}

/// 服务器线路选择切换Api
class VideoChannelSaveApi: XSVideoBaseAPI {
    
    static let kKey = "key"    // 线路Key
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/channel/save"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/channel/save"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [VideoChannelSaveApi.kUrl: VideoChannelSaveApi.kUrlValue,
                                        VideoChannelSaveApi.kMethod: VideoChannelSaveApi.kMethodValue]
        allParams[VideoChannelSaveApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}


