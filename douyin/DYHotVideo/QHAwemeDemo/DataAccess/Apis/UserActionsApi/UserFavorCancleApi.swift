//
//  UserFavorCancleApi.swift
//  XSVideo
//
//  Created by pro5 on 2019/1/5.
//  Copyright © 2019年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork


/// 用户取消收藏
class UserFavorCancleApi: XSVideoBaseAPI {
    
    static let kVideo_ids = "video_id"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/user/collect/cancel"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/user/collect/cancel"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserFavorCancleApi.kUrl: UserFavorCancleApi.kUrlValue,
                                        UserFavorCancleApi.kMethod: UserFavorCancleApi.kMethodValue]
        allParams[UserFavorCancleApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}

/// 用户关注 状态借口
class UserFollowStatuApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user-follow/status"
    static let kMethodValue = "GET"
    
    static let kUserId = "target_uid"
    static let kSelfId = "current_uid"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user-follow/status"
    }
    
    override func shouldCache() -> Bool {
        return true
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserFollowStatuApi.kUrl: UserFollowStatuApi.kUrlValue,
                                        UserFollowStatuApi.kMethod: UserFollowStatuApi.kMethodValue]
        allParams[UserFollowStatuApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}

/// 用户加关注
class UserAddFollowApi: XSVideoBaseAPI {
    
    static let kUserId = "target_uid"
    static let kSelfId = "current_uid"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user-follow"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user-follow"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserAddFollowApi.kUrl: UserAddFollowApi.kUrlValue,
                                        UserAddFollowApi.kMethod: UserAddFollowApi.kMethodValue]
        allParams[UserAddFollowApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}


/// 用户取消关注
class UserCancleFollowApi: XSVideoBaseAPI {
    
    static let kUserId = "target_uid"
    static let kSelfId = "current_uid"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user-unfollow"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user-unfollow"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserCancleFollowApi.kUrl: UserCancleFollowApi.kUrlValue,
                                        UserCancleFollowApi.kMethod: UserCancleFollowApi.kMethodValue]
        allParams[UserCancleFollowApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}
