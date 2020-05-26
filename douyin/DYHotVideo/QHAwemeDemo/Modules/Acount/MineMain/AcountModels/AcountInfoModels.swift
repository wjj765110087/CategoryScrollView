//
//  AcountInfoModels.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/17.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation


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
    var vc_title: String?
    var vc_daily_until: Int?
    var pay_status_label: String?
    var pay_status: Int?
    var paid_at: String?
    var price_original: String?
    var price_current: String?
    var status: Int? // ding
    var created_at: String?
    var user_id: Int?
    var nikename: String?
    var mobile: String?
}

struct OrderDateModel: Codable {
    var date: String?
    var timezone_type: Int?
    var timezone: String?
}

struct VipCardListModel: Codable {
//    var current_page: Int?
    var vip: [VipCardModel]?
    var vip_message: String?
}

// MARK: - -----  VIP cards
class VipCardModel: Codable {
    var id: Int?
    var title: String?  // 卡片名
    var key: String? //卡片类型
    var remark: String?
    var daily_until: Int? // 使用天数
    var view_count_daily: Int? // 每天使用次数 ,0 表示无限次数 或者没有次数。取决于卡的类型
    var price_original: String? // 正常价格
    var price_current: String?  // 当前价格
    var level: Int? // 卡等级 1 - 6
    var sort: Int? // 排序号
    var status: Int? //
    var display: Int?
    var created_at: String?
    var updated_at: String?
    var selected: Bool? = false
    var color: String?
}

/// VIP 卡类型
///
/// - card_Novice: 新手卡
/// - card_Normal: 游客卡
/// - card_TiYan: 体验卡
/// - card_YouXiang: 优享卡
/// - card_GuiBing: 贵宾卡
/// - card_ZhiZun: 至尊卡
enum VipKey: String, Codable {
    case card_Novice = "NOVICE"
    case card_Normal = "NORMAL"
    case card_TiYan  = "TIYAN"
    case card_YouXiang = "YOUXIANG"
    case card_GuiBing  = "GUIBING"
    case card_ZhiZun  = "ZHIZUN"
}

struct UpDoorServerListModel: Codable {
//    var current_page: Int?
    var service: [UpDoorServerModel]?
    var service_message: String?
}

// MARK: - -----  VIP cards
class UpDoorServerModel: Codable {
    var id: Int?
    var title: String?  // 卡片名
    var key: String? //卡片类型
    var remark: String?
    var daily_until: Int? // 使用天数
    var view_count_daily: Int? // 每天使用次数 ,0 表示无限次数 或者没有次数。取决于卡的类型
    var price_original: String? // 正常价格
    var price_current: String?  // 当前价格
    var level: Int? // 卡等级 1 - 6
    var sort: Int? // 排序号
    var status: Int? //
    var display: Int?
    var created_at: String?
    var updated_at: String?
    var selected: Bool? = false
    var color: String?
}

//MARK: - 金币套餐
class CoinListModel: Codable {
    var coins: [CoinModel]?
    var coins_message: String?
}

//MARK: - 金币套餐
class CoinModel: Codable {
    var id: Int?
    var coins: Int?
    var price: String?
    var intro: String?
    var sort: Int?
    var created_at: String?
    var updated_at: String?
}

//MARK: - 余额明细
class MoneyDetailModel: Codable {
    var _id: String?
    var user_id: Int?
    var title: String?
    var balance: String?
    var status: DrawStatus?
    var msg: String?
    var status_name: String?
    var created_at: String?
    var updated_at: String?
}

enum DrawStatus: Int, Codable {
    case drawCenter = 0
    case drawFailure = -1
    case drawSuccess = 2
}

class MoneyDetailList: Codable {
    var current_page: Int?
    var data: [MoneyDetailModel]?
    var total: Int?
}

//MARK: -金币明细
class CoinDetailModel: Codable {
    var _id: String?
    var user_id: Int?
    var title: String?
    var coins: String?
    var created_at: String?
    var updated_at: String?
}

class CoinDetailListModel: Codable {
    var current_page: Int?
    var data: [CoinDetailModel]?
    var total: Int?
}

// MARK: - 已获得 折扣卡 列表
struct  WelfareGetCardList: Codable {
    var current_page: Int?
    var data:[WelfareGetCard]?
}

// MARK: - 折扣卡 统一
struct WelfareGetCard: Codable {
    var id: Int?
    var vc_id: Int?
    var wc_id: Int?
   
    var title: String?
    var remark: String?
    var discount: String?   // 折扣
    var invite_mini: Int?
    
    var user_id: Int?
    var created_at: String?
    var status: Int?
    var expire: String? // 有效期
}

// MARK: - 未获得卡
struct WelfareUnowedCard: Codable {
    var id: Int?
    var invite_count: Int?
    var title: String?
    var remark: String?
    var discount: String?   // 折扣
    var invite_mini: Int?

}


// MARK: - 用户邀请历史列表 model
struct InviteListModel: Codable {
    var current_page: Int?
    var data: [inviteUserModel]?
}

struct inviteUserModel: Codable {
    var code: String?
    var owner_user_id: Int?
    var name: String?
    var nikename: String?
    var mobile: String?
    var use_user_id: Int?
    var created_at: String?
}


// MARK: - 订单详情
struct OrderDetailModel: Codable {
    var id: Int?
    var title: String?
    var remark: String?
    var price_original: String?
    var price_current: String?
    var welfareCard: [WelfareGetCard]?
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
// MARK: - 订单model
struct OrderAddModel: Codable {
    var oid: String?
    var payUrl: String?
    var sign: String?
    var target: GoPay?
}

/// 是否强制更新
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
class PayTypeModel: Codable {
    var id: Int?
    var title: String?
    var key: String?
    var status: PayTypeState?
    var created_at: String?
    var updated_at: String?
    var selected: Bool? = false
}


// MARK: - 问题列表
struct QuestionModel: Codable {
    var key: String?
    var value: String?
}

/// 审核状态
///
/// - reviewFailed: 审核失败
/// - newReviewStatu: 咩有申请过资质
/// - waitForReview: 等待审核
/// - passedReview: 通过审核
enum UploadReviewStatu: Int, Codable {
    case reviewFailed = -1      // 审核失败
    case newReviewStatu = 0     // 没有申请过
    case waitForReview = 1      // 等待审核
    case passedReview =  2      // 审核通过
}

// MARK: - 上传资质校验
struct ApplyCheckInfoModel: Codable {
    var upload_review_fail: Int?                     // 审核已失败次数
    var upload_review_max_fail: Int?                 // 最大允许审核失败次数
    var upload_review: UploadReviewStatu?            // 审核状态 -1： 审核失败 0:未审核 1:待审核 2:已审核
}


// MARK: - 个人分销金额详情

enum UserWalletLevel: String, Codable {
    case daRen = "P"
    case normal = "A"
}
struct WalletInfo: Codable {
    var id: Int?
    var user_id: Int?
    var money: String?
    var coins: Int?
    var coins_income: Int?     //废弃
    var money_income: String?  //废弃
    var bonus: String?
    var bonus_a: String?
    var bonus_b: String?
    var bonus_c: String?
    var bonus_extra: String?
    var sales_type: UserWalletLevel?
    var created_at: String?
    var updated_at: String?
}

// MARK: - 个人收益提现历史
struct WalletRecordLs: Codable {
    var current_page: Int?
    var data: [WalletRecord]?
    var total: Int?
}
struct WalletRecord: Codable {
    var user_id: Int?
    var record_sn: String?
    var record_type: String?
    var record_event: Int?
    var money: String?
    var record_type_label: String?
    var created_at: String?
}

/// 反馈列表
struct FeedLsModel: Codable {
    var current_page: Int?
    var data: [FeedModel]?
}

struct FeedModel: Codable {
    var id: Int?
    var title: String?
    var status: Int?
    var keys: [String]?
    var remark: String?
    var contact: String?
    var user_id: Int?
    var nikename: String?
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
    var coupon: Int?
    var status: Int?
    var title: String?
    var remark: String?
    var is_exchange: Int?
    var vip_day: Int?
    
    var created_at: String?
    var updated_at: String?
}


class FollowListModel: Codable {
    var item: [FlowUsers]?
    var p: Int?
    var pt: Int?
}

class FlowUsers: Codable {
    var id: Int?
    var nikename: String?
    var cover_path: String?
    var uid: String?
    var flag: RelationShip?
    
    var count: Int?
    
    var mobile: String?
    var created_at: String?
    var _realation: FollowOrCancelModel?
}

/// 关系
///
/// - notRelate: 无关系
/// - myFollow: 我关注他
/// - follwMe: 我的粉丝
/// - followEachOther: 相互关注
/// - isMySelf: 是我自己
enum RelationShip: Int, Codable {
    case notRelate = 0
    case myFollow = 1
    case follwMe = 2
    case followEachOther = 3
    case isMySelf = 4
}

///是否关注该视频的作者
enum FocusVideoUploader: Int, Codable {
    case notFocus = 0 //未关注
    case focus = 1 //已关注
}

///关注状态
struct FollowStatu: Codable {
    var status: Int?
}

/////关注和取消关注的模型
struct FollowOrCancelModel: Codable {
    var uid: Int?
    var flag: RelationShip?
}
