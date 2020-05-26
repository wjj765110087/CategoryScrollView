//
//  UserFavorAddApi.swift
//  XSVideo
//
//  Created by pro5 on 2019/1/5.
//  Copyright © 2019年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork


/// 用户点赞
class UserFavorAddApi: XSVideoBaseAPI {
    
    static let kAction = "action"  // recommend
    static let kVideo_id = "video_id"
    static let kStatus = "status" // 用于区分是否点赞 或者取消点赞。 0取消。 1添加
    static let kDefaultAction = "recommend"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/user/appraise"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/user/appraise"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserFavorAddApi.kUrl: UserFavorAddApi.kUrlValue,
                                        UserFavorAddApi.kMethod: UserFavorAddApi.kMethodValue]
        allParams[UserFavorAddApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}


/// 用户对广告点赞
class UserAdFavorAddApi: XSVideoBaseAPI {
    
    static let kAction = "action"  // recommend
    static let kAd_id = "ad_id"
    static let kStatus = "status" // 用于区分是否点赞 或者取消点赞。 0取消。 1添加
    static let kDefaultAction = "recommend"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/user/ad/appraise"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/user/ad/appraise"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserAdFavorAddApi.kUrl: UserAdFavorAddApi.kUrlValue,
                                        UserAdFavorAddApi.kMethod: UserAdFavorAddApi.kMethodValue]
        allParams[UserAdFavorAddApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}
