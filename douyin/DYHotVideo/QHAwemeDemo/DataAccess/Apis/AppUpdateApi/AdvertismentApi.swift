//
//  UserDeleteWatchedApi.swift
//  XSVideo
//
//  Created by pro5 on 2019/1/5.
//  Copyright © 2019年 pro5. All rights reserved.
//

import Foundation

/// 闪屏广告
class AdvertismentApi: XSVideoBaseAPI {
    
    static let kVideo_ids = "video_id"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/startup"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/startup"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [AdvertismentApi.kUrl: AdvertismentApi.kUrlValue,
                                        AdvertismentApi.kMethod: AdvertismentApi.kMethodValue]
        allParams[AdvertismentApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}
