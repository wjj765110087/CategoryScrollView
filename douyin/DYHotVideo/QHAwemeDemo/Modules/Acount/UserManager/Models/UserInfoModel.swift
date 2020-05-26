//
//  UserInfoModel.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/19.
//  Copyright © 2018年 pro5. All rights reserved.
//

import Foundation

/// 用户信息model
class UserInfoModel: Codable {
    var id: Int?                     // 用户ID
    var type: Int?                   // 0: 手机号注册用户   10：设备号注册用户（游客）
    var name: String?                // 用户名称
    var nikename: String?            // 昵称
    var mobile: String?              // 手机号
    var email: String?
    var birth: String?               // 生日
    var intro: String?               // 个性签名
    var sex: Int?                    // 1：男 2 ：女
    var status: Int? 
    var api_token: String?           // 用户唯一标识
    var vip_id: Int?                 // 对应 卡 的level
   // var wc_count: Int?               // 我的折扣卡张数
    

    var avatar: String?           ///在发现的排行榜详情后台返回的头像

    var flow: Int?                   // 关注
    var fans: Int?
    var like: Int?
    var invite_count: Int?           // 邀请人数

    
    var view_daily_count_total: Int? // 总共的次数
    var view_daily_count_use: Int?   // 使用次数
    
    var remain_count: String?        // 展示在页面上的次数
    var vip_remain_day: String?      // 会员卡剩余天数
    var vip_title: String?           // VIP卡名称
    var vip_expire: String?          // 会员到期时间
    
    var code: String?                // 邀请码
    var invite_me_code: String?      // 邀请我的人（的邀请码）
    
    var vip_key: String?             // 会员key
    var favorite_count: Int?         // 喜欢视频数量
    var own_video_count: Int?        // 用户自己拍摄的作品数量
    
    var followed: FocusVideoUploader?      //对视频的作者之间的关注关系
    
    var salt: String?                // 身份识别字符串
    
    var vip_card: VipCardModel?      // 会员卡
    var channel: VideoChannelModel?  // 用户当前线路
    var cover_path: String?         //头像
    
    var top: Int?                    // 排名
    var count:  Int?                 // 数量
    
}

class UserListModel: Codable {
    var current_page: Int?
    var data: [UserInfoModel]?
}

/// 登录model
struct LoginInfoModel: Codable {
    var user: UserInfoModel?
    var token: String?
}


struct UserFollowOrFansCountModel: Codable {
    var count: Int?
}
