//
//  UserInvitedListApi.swift
//  XSVideo
//
//  Created by pro5 on 2019/1/5.
//  Copyright © 2019年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork

/// 用户邀请记录
class UserInvitedListApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/invitation/list"
    static let kMethodValue = "GET"
    
    // 分页参数
    static let kPageNumber = "page"
    static let kPageCount = "limit"
    static let kDefaultCount = 15
    
    private var pageNumber: Int = 1
    
    override func loadData() -> Int {
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
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/invitation/list"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    // the optional method may used for pageable API manager
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [UserInvitedListApi.kUrl: UserInvitedListApi.kUrlValue,
                                        UserInvitedListApi.kMethod: UserInvitedListApi.kMethodValue]
        /// 分页参数
        var newParams: [String: Any] = [UserInvitedListApi.kPageNumber: pageNumber,
                                        UserInvitedListApi.kPageCount: UserInvitedListApi.kDefaultCount]
        if params != nil {
            for (key, value) in params! {
                newParams[key] = value
            }
        }
        allParams[UserInvitedListApi.kParams] = newParams
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : newParams)
    }
    
    override func manager(_ manager: NicooBaseAPIManager, beforePerformSuccess response: NicooURLResponse) -> Bool {
        self.pageNumber += 1
        return true
    }
}
