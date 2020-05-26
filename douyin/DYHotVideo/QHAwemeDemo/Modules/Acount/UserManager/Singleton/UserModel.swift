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
    var wallet: WalletInfo?
    var gameBeiCount: Int = 1
    /// 是否已登录
    var isLogin: Bool = false
    /// 是否是真实注册用户
    var isRealUser: Bool = false
    /// 将要分享的图片链接
    var shareImageLink: String?
    /// 将要分享的文本
    var shareText: String?
    
    func getUserHeader(_ userId: Int? = UserModel.share().userInfo?.id) -> UIImage {
        if let userlasId = userId {
            let cc = userlasId%100
            return UIImage(named:"\(cc + 1)H") ?? ConstValue.kDefaultHeader ?? UIImage()
        } else {
            let userIdLast = UserModel.share().userInfo?.id ?? 0
            let cc = userIdLast%100
            return UIImage(named:"\(cc + 1)H") ?? ConstValue.kDefaultHeader ?? UIImage()
        }
    }
}

/// 上传任务管理单利
class UploadTask: NSObject {
    static private let task: UploadTask = UploadTask()
    class func shareTask() -> UploadTask {
        return task
    }
    /// 保存暂未发布的视频任务
    var tasks: [PushPresenter]?
    /// 保存发布主页 选择的 话题
    var talksModel: TalksModel?
    /// 保存发布主页 填写的 发布文字
    var content:String?
}

/// 系统单利
class SystemMsg: Codable {
    static private let shareMsg: SystemMsg = SystemMsg()
    class func share() -> SystemMsg {
        return shareMsg
    }
    var systemMsgs: [SystemMsgModel]?
    var videoChannels: [VideoChannelModel]?
    var addGroupLinkModels: [AddGroupLinkModel]?
}

/// 系统公告
struct SystemMsgModel: Codable {
    var id: Int?
    var message: String?
    var status: Int?
    var created_at: String?
    var updated_at: String?
}

/// 线路
struct VideoChannelModel: Codable {
    var id: Int?
    var title: String?
    var key: String?
    var domain: String?
    var status: Int?
    var sort: Int?
    var remark: String?
    var created_at: String?
    var updated_at: String?
}
