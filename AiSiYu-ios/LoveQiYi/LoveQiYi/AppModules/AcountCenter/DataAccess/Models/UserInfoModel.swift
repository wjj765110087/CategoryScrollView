//
//  UserInfoModel.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/19.
//  Copyright © 2018年 pro5. All rights reserved.
//

import Foundation

/// 用户信息model
struct UserInfoModel: Codable {
    var id: String?                     // 用户ID
    var type: UserType?                   // 0: 手机号注册用户   10：设备号注册用户（游客）
    var name: String?                // 用户名称
    var nick_name: String?            // 昵称
    var mobile: String?              // 手机号
   
    var sex: String?                    // 1：男 2 ：女
    var status: String?
    var api_token: String?           // 用户唯一标识
    var salt: String?                // 身份识别字符串
    
    var day_count: String?           // 使用 次数
    var all_count: String?           // 总次数
    var download_count: String?      // 已使用 下载次数
    var download_all_count: String?  // 下载允许次数
    
    var remain_day: Int?             // 任务获取的。 天数
    
    var view_info: String?           // 观看次数信息
    var download_info: String?       // 下载次数信息
    
    var invite_code: String?         // 邀请码
    var invite_me_code: String?      // 邀请我的人 邀请码
    var invite: String?              // 邀请数量
    
    var is_vip: VipUser?             // 是不是会员
    var vip_expire: String?
    
    var free_expire: String?          // 会员 到期时间
    
    var channel: RouterModel?         // 线路
    
}

enum VipUser: Int, Codable {
    case normalUser = 0
    case vipUser = 1
    var boolValue: Bool {
        switch self {
        case .vipUser:
            return true
        case .normalUser:
            return false
        }
    }
}

enum UserType: String, Codable {
    case phoneUser = "0"
    case deviceUser = "10"
}

/// 登录model
struct LoginInfoModel: Codable {
    var user: UserInfoModel?
    var token: String?
}
