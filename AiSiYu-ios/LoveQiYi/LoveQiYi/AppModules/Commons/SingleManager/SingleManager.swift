//
//  UserModel.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/14.
//  Copyright © 2018年 pro5. All rights reserved.
//

import UIKit

/// 用户单利
class UserModel: Codable {
    
    static private let shareModel: UserModel = UserModel()
    class func share() -> UserModel {
        return shareModel
    }
    var userInfo: UserInfoModel?
    /// 是否需要刷新任务列表
    var needRefreshTask: Bool = false
    /// 是否已登录
    var isLogin: Bool = false
    /// 是否是真实注册用户
    var isRealUser: Bool = false
    /// 已观看时间
    var watchedTime: Int = 0
    
    func getUserHeader() -> UIImage {
        if let userIdLast = Int(UserModel.share().userInfo?.id ?? "0") {
            let cc = userIdLast%10
            return UIImage(named: "he\(cc)") ?? UIImage()
        }
        return UIImage()
    }
}

/// 系统单利
class SystemMsg: Codable {
    static private let shareMsg: SystemMsg = SystemMsg()
    class func share() -> SystemMsg {
        return shareMsg
    }
    var systemMsgs: [SystemMsgModel]?
    var videoChannels: [VideoChannelModel]?
}

/// APP 信息单利
class AppInfo: NSObject {
    static private let shareModel: AppInfo = AppInfo()
    class func share() -> AppInfo {
        return shareModel
    }
    var appInfo: AppVersionInfo?
    
}

/// 首页大分类
class MainType: NSObject {
    
    static private let shareType: MainType = MainType()
    class func share() -> MainType {
        return shareType
    }
    
    var typeModels: [MainTypeModel]?
    
    func typeTitles() -> [String] {
        if let models = typeModels, models.count > 0 {
            var typeTitles = [String]()
            for model in models {
                if model.title != nil {
                    typeTitles.append(model.title!)
                }
            }
            return typeTitles
        }
        return [String]()
    }
    
}
