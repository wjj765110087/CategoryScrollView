//
//  VideoRecommentApi.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/13.
//  Copyright © 2018年 pro5. All rights reserved.
//

import Foundation

// 视频观看h鉴权Api
class VideoAuthApi: XSVideoBaseAPI {
    
    static let kVideo_id = "video_id"
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/view/auth"
    static let kMethodValue = "GET"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/view/auth"
    }
    override func shouldCache() -> Bool {
        return false
    }
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [VideoAuthApi.kUrl: VideoAuthApi.kUrlValue,
                                        VideoAuthApi.kMethod: VideoAuthApi.kMethodValue]
        allParams[VideoAuthApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}
