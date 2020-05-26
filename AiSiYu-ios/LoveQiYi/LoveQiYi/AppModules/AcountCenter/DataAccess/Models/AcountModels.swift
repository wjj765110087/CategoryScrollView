//
//  AcountModels.swift
//  YellowBook
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019年 mac. All rights reserved.
//

import Foundation

/// 用户邀请历史列表 model
struct InviteListModel: Codable {
    var current_page: Int?
    var data: [inviteUserModel]?
}

struct inviteUserModel: Codable {
    var code: String?
    var owner_user_id: Int?
    var name: String?
    var nick_name: String?
    var mobile: String?
    var use_user_id: Int?
    var created_at: String?
}

/// 问题列表
struct QuestionModel: Codable {
    var key: String?
    var value: String?
}

/// 金币列表
struct CoinRecordLsModel: Codable {
    var current_page: Int?
    var data: [CoinRecordModel]?
}

/// 金币记录
struct CoinRecordModel: Codable {
    var _id: String?
    var user_id: Int?
    var event: String?
    var count: Int?
    var value: Int?
    var title: String?
    var status: Int?
    var created_at: String?
    var updated_at: String?
}


/// 邀请规则
struct InvitedRulesModel: Codable {
    var id: Int?
    var begin: Int?
    var end: Int?
    var coins: Int?
    var created_at: String?
    var updated_at: String?
}

/// 反馈列表
struct FeedLsModel: Codable {
    var current_page: Int?
    var data: [FeedModel]?
}

struct FeedModel: Codable {
    var id: Int?
    var keys: [String]?
    var remark: String?
    var contact: String?
    var user_id: Int?
    var nick_name: String?
    var ip: String?
    var cover_url: [String]?
    var created_at: String?
    var updated_at: String?
}


/// 聊天消息列表

struct MsgLsModel: Codable {
    var current_page: Int?
    var data: [MsgModel]?
}
enum MsgType: String, Codable {
    case text = "1"
    case image = "2"
}

struct MsgModel: Codable {
    var user_id: Int?  //  0: 管理员回复。  其他： 用户发送的
    var feed_id: String?
    var content: String?
    var type: MsgType?   /// 1: 普通文本。2: 图片消息
    var created_at: String?
    var updated_at: String?
}

struct ExCoinsInfo: Codable {
    var id: Int?
    var code: String?
    var title: String?
    var remark: String?
    var is_exchange: Int?
    var vip_day: Int?
    var status: Int?
    var created_at: String?
    var updated_at: String?
}



// MARK: - ----- 订单列表model
struct OrderListModel: Codable {
    var current_page: Int?
    var data:[OrderInfoModel]?
}

// MARK: - ----- 订单model
struct OrderInfoModel: Codable {
    var id: Int?
    var order_no: String?  // 订单号
    var order_type: Int? //订单类型
    var price: String?   // 金娥
    var recharge_title: String?
    var vc_title: String?
    var vc_daily_until: Int?
    var pay_status_label: String?
    var pay_status: Int?
    var paid_at: String?
    var price_original: String?
    var price_current: String?
    var status: Int? // ding
    var created_at: String?
    
}

// MARK: - 订单详情
struct OrderDetailModel: Codable {
    var id: Int?
    var title: String?
    var remark: String?
    var price_original: String?
    var price_current: String?
}

// MARK: - 订单model
struct OrderAddModel: Codable {
    var oid: String?
    var payUrl: String?
    var sign: String?
    var target: GoPay?
}

/// 是否强制更新
enum GoPay: Int, Codable {
    case enable = 0
    case disable = 1
    var allowPay: Bool {
        switch self {
        case .enable:
            return true
        case .disable:
            return false
        }
    }
}

/// 支付通道是否可用
enum PayTypeState: Int, Codable {
    case disable = 0
    case enable = 1
    var allowPay: Bool {
        switch self {
        case .enable:
            return true
        case .disable:
            return false
        }
    }
}

// MARK: - 支付方式列表
struct PayTypeModel: Codable {
    var id: Int?
    var title: String?
    var key: String?
    var status: PayTypeState?
    var created_at: String?
    var updated_at: String?
    var selected: Bool? = false
}

struct RechargeModel: Codable {
    var recharge: [ChargeModel]?
    var icon: [VIPWelfareMune]?
}

/// 价格菜单列表
struct ChargeModel: Codable {
    var id: Int?
    var price: String?
    var title: String?
    var description: String?
    var offer: String?
    var sort: Int?
    var created_at: String?
    var updated_at: String?
    var selected: Bool? = false
}

struct VIPWelfareMune: Codable {
    var id: Int?
    var title: String?
    var icon: String?
    var sort: Int?
    var sub_title: String?
}


struct VideoDownLoad {
    var videoDirectory: String?
    var videoDownLoadUrl: String?
    var videoModelString: String?
}
