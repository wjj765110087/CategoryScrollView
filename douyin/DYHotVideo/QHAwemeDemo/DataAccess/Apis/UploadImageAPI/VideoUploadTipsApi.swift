//
//  VideoUploadTipsApi.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/5/3.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation

/// 视频上传分类列表Api
class VideoUploadTipsApi: XSVideoBaseAPI {
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/upload/type"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return  ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/upload/type"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [VideoUploadTipsApi.kUrl: VideoUploadTipsApi.kUrlValue,
                                        VideoUploadTipsApi.kMethod: VideoUploadTipsApi.kMethodValue]
        allParams[VideoUploadTipsApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
    
}
