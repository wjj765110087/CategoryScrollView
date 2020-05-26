//
//  UserDeleteWorksApi.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/5/6.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation
import NicooNetwork

/// 用户删除作品Api
class UserDeleteWordsApi: XSVideoBaseAPI {
    /// 卷码
    static let kVideo_id = "video_id"
    
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/video/upload/destroy"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/video/upload/destroy"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserDeleteWordsApi.kUrl: UserDeleteWordsApi.kUrlValue,
                                        UserDeleteWordsApi.kMethod: UserDeleteWordsApi.kMethodValue]
        allParams[UserDeleteWordsApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}

/// 用户修改昵称
class UserRenameApi: XSVideoBaseAPI {

    static let kName = "name"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/update-info"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/update-info"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserRenameApi.kUrl: UserRenameApi.kUrlValue,
                                        UserRenameApi.kMethod: UserRenameApi.kMethodValue]
        allParams[UserRenameApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}
