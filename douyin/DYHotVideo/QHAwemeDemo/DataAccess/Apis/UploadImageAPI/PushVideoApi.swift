//
//  PushVideoApi.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/5/3.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation
import NicooNetwork

/// 视频上传提交Api
class PushVideoApi: XSVideoBaseAPI {
    
    static let kTitle = "title"           // 视屏标题
    static let kCoverName = "cover_oss_filename"  // 封面图 名称 : xxx.ceb
    static let kDuration  = "duration"    // 时长
    static let kKey_id    = "key_id"      // [1,2,3]
    static let kFile_name = "file_name"   // 视频文件名
    static let kFile_path = "file_path"   // 视频路径
    static let kTalks_id  = "topic_id"    // 话题Id
    static let kCoins     = "coins"       // 视频定价
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/video/upload/data"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/video/upload/data"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [PushVideoApi.kUrl: PushVideoApi.kUrlValue,
                                        PushVideoApi.kMethod: PushVideoApi.kMethodValue]
        allParams[PushVideoApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}


/// 视频上传资质审核Api
class ApplyCheckApi: XSVideoBaseAPI {
    
    static let kContent = "content"           // 申请理由
    static let kContact = "contact"           // 联系方式
    static let kCoverName = "cover_oss_filename"  // 封面图 名称 : xxx.ceb
    static let kFile_name = "file_name"   // 视频文件名
    static let kFile_path = "file_path"   // 视频路径
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/user/upload/review-data"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/user/upload/review-data"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [ApplyCheckApi.kUrl: ApplyCheckApi.kUrlValue,
                                        ApplyCheckApi.kMethod: ApplyCheckApi.kMethodValue]
        allParams[ApplyCheckApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}


/// 动态上传提交Api
class PushTopicApi: XSVideoBaseAPI {
    
    static let kTitle = "title"           // 动态文字内容
    static let kResource = "resource"     // 图片数组 名称 : 【xxx.ceb】
    static let kTalks_id  = "topic_id"    // 话题Id
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/topic/content-add"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/topic/content-add"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [PushTopicApi.kUrl: PushTopicApi.kUrlValue,
                                        PushTopicApi.kMethod: PushTopicApi.kMethodValue]
        allParams[PushTopicApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}
