//
//  UserFeedBackApi.swift
//  XSVideo
//
//  Created by pro5 on 2019/1/5.
//  Copyright © 2019年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork

/// 用户反馈Api
class UserFadeBackApi: XSVideoBaseAPI {
    
    /// 反馈内容
    static let kContent = "title"
    /// 联系方式
    static let kContact = "contact"
    /// 问题keys
    static let kKeys = "keys"
    /// 上传成功的图片名称
    static let kCover_filename = "cover_filename"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/feedback/create"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/feedback/create"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserFadeBackApi.kUrl: UserFadeBackApi.kUrlValue,
                                        UserFadeBackApi.kMethod: UserFadeBackApi.kMethodValue]
        allParams[UserFadeBackApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}

// 用户反馈问题列表Api
class UserQuestionApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/question/lists"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/question/lists"
    }
    
    override func shouldCache() -> Bool {
        return true
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserQuestionApi.kUrl: UserQuestionApi.kUrlValue,
                                        UserQuestionApi.kMethod: UserQuestionApi.kMethodValue]
        allParams[UserQuestionApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}


/// idcardFindApi
class RecallByCardApi: XSVideoBaseAPI {
    
    /// token
    static let kToken = "token"   //uid+salt,如:56717gX9ecQx7
    static let kDevice_code = "device_code"
    
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/account/recallByCard"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/account/recallByCard"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [RecallByCardApi.kUrl: RecallByCardApi.kUrlValue,
                                        RecallByCardApi.kMethod: RecallByCardApi.kMethodValue]
        allParams[RecallByCardApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}
