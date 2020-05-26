//
//  TasksModels.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/5/22.
//  Copyright © 2019年 mac. All rights reserved.
//

import Foundation

/// 任务分类
///
/// - newUser: 新用户注册
/// - daily: 日常
enum TaskGroup: String, Codable {
    case newUser = "new"
    case daily = "daily"
}

/// 任务
///
/// - newUser: 新用户注册
/// - savePhoto: 保存推广码至相册
/// - saveCard: 保存身份卡至相册
/// - bindMobile: 绑定手机号码
/// - clickAd: 点击广告
/// - shareComic: 分享漫画或动漫
/// - collectComic: 收藏漫画或动漫
/// - look_Thirty: 观看动漫30分钟
/// - read_Ten: 阅读漫画10分钟
/// - read_Twenty: 再阅读20分钟
/// - read_Thirty: 再阅读30分钟
/// - read_Sixty: 再阅读60分钟
enum TaskKey: String, Codable {
    case newUser = "REGISTER"
    case savePhoto = "SAVE_PHOTO"
    case saveCard = "SAVE_CARD"
    case bindMobile = "BIND_MOBILE"
    case clickAd = "CLICK_AD"
    case shareComic = "SHARE_COMIC"
    case collectComic = "COLLECT_COMIC"
    
    case look_Thirty = "LOOK_ONE"
    case read_Ten = "READ_ONE"
    case read_Twenty = "READ_THREE"
    case read_Thirty = "READ_FIVE"
}

enum TaskSign: Int, Codable {
    case selected = 1
    case normal = 0
}

class TaskModulesModel: NSObject, Codable {
    var sign: String?
    var coupon: Int?
    var info: [SignInfo]?
    var task: [TaskModel]?
    var rule: [RuleModel]?
    
}

class SignInfo: NSObject, Codable {
    var time: String?
    var sign: Int?
}
class RuleModel: NSObject, Codable {
    var id: Int?
    var person: Int?
    var coupon: String?
    var day: Int?
    var sign: Int?
    var created_at: String?
}

class TaskModel: NSObject, Codable {
    var id: Int?
    var group: TaskGroup?
    var key: TaskKey?
    var group_sort: Int?
    var icon: String?
    var title: String?
    var day: Int?
    var sort: Int?
    var status: Int?  
    var has: Int?
    var sign: TaskSign?  /// 0去做任务 1待领取 2已完成
    var created_at: String?
    var updated_at: String?
}

