//
//  UserResetPswApi.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/27.
//  Copyright © 2018年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork

 // 搜索联想Api
class SearchMagicApi: XSVideoBaseAPI {
    
    static let kKeyword = "keywords"  // 关键词
    
    /// 固定参数，不需要外部传入
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/search/lists"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/search/lists"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [SearchMagicApi.kUrl: SearchMagicApi.kUrlValue,
                                        SearchMagicApi.kMethod: SearchMagicApi.kMethodValue]
        allParams[SearchMagicApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
   
}
