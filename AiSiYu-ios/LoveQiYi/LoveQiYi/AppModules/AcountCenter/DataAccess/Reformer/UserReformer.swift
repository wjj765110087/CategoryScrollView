//
//  UserReformer.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/14.
//  Copyright © 2018年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork

/// 用户信息数据解析器
class UserReformer: NSObject {
    
    /// 用户信息
    private func reformUserInfoDatas(_ data: Data?) -> Any? {
        if let user = try? decode(response: data, of: ObjectResponse<UserInfoModel>.self)?.result {
            return user
        }
        return nil
    }


//    /// 邀请规则
//    private func reformJuanDetailDatas(_ data: Data?) -> Any? {
//        if let juans = try? decode(response: data, of: ObjectResponse<[InviteRuleModel]>.self)?.result {
//            return juans'
//        }
//        return nil
//    }

    /// 邀请记录
    private func reformInvitedListDatas(_ data: Data?) -> Any? {
        if let invitedList = try? decode(response: data, of: ObjectResponse<InviteListModel>.self)?.result {
            return invitedList
        }
        return nil
    }

    /// 通过手机号找回原账号
    private func reformAcountBackWithPhoneDatas(_ data: Data?) -> Any? {
        if let oldUser = try? decode(response: data, of: ObjectResponse<UserInfoModel>.self)?.result {
            return oldUser
        }
        return nil
    }

    /// 反馈的默认可选问题列表
    private func reformUserFadeBackquestionsDatas(_ data: Data?) -> Any? {
        if let oldUser = try? decode(response: data, of: ObjectResponse<[QuestionModel]>.self)?.result {
            return oldUser
        }
        return nil
    }
    
    /// 阅读卷记录
    private func coinsRecordDatas(_ data: Data?) -> Any? {
        if let taskList = try? decode(response: data, of: ObjectResponse<CoinRecordLsModel>.self)?.result {
            return taskList
        }
        return nil
    }
    
    
    /// 反馈记录
    private func feedLsRecordDatas(_ data: Data?) -> Any? {
        if let list = try? decode(response: data, of: ObjectResponse<FeedLsModel>.self)?.result {
            return list
        }
        return nil
    }
    
    /// 反馈消息列表
    private func msglistRecordDatas(_ data: Data?) -> Any? {
        if let list = try? decode(response: data, of: ObjectResponse<MsgLsModel>.self)?.result {
            return list
        }
        return nil
    }
    
    /// 反馈消息回复
    private func feedReplyDatas(_ data: Data?) -> Any? {
        if let list = try? decode(response: data, of: ObjectResponse<MsgModel>.self)?.result {
            return list
        }
        return nil
    }
    /// 兑换金币
    private func welCardConvertCoins(_ data: Data?) -> Any? {
        if let taskList = try? decode(response: data, of: ObjectResponse<ExCoinsInfo>.self)?.result {
            return taskList
        }
        return nil
    }
    
    // MARK: - 用户订单列表
    private func reformOrderListDatas(_ data: Data?) -> Any? {
        if let loginInfo = try? decode(response: data, of: ObjectResponse<OrderListModel>.self)?.result {
            return loginInfo
        }
        return nil
    }
    
    // MARK: - 点击付款 ，订单生成
    private func reformOrderAddDatas(_ data: Data?) -> Any? {
        if let invitedList = try? decode(response: data, of: ObjectResponse<OrderAddModel>.self)?.result {
            return invitedList
        }
        return nil
    }
    
    // MARK: - 获取支付菜单列表
    private func reformRechargeModelDatas(_ data: Data?) -> Any? {
        if let rechargeModel = try? decode(response: data, of: ObjectResponse<RechargeModel>.self)?.result {
            return rechargeModel
        }
        return nil
    }
    
    // MARK: - 获取支付通道列表
    private func reformPayTypeListDatas(_ data: Data?) -> Any? {
        if let invitedList = try? decode(response: data, of: ObjectResponse<[PayTypeModel]>.self)?.result {
            return invitedList
        }
        return nil
    }
    
}

extension UserReformer: NicooAPIManagerDataReformProtocol {
    
    func manager(_ manager: NicooBaseAPIManager, reformData jsonData: Data?) -> Any? {
        
        if manager is UserInvitedListApi {
            return reformInvitedListDatas(jsonData)
        }
        if manager is UserInfoApi {
            return reformUserInfoDatas(jsonData)
        }

        if manager is AcountBackWithPhoneApi || manager is RecallByCardApi {
            return reformAcountBackWithPhoneDatas(jsonData)
        }
        if manager is UserQuestionApi {
            return reformUserFadeBackquestionsDatas(jsonData)
        }
//        /// coins
        if manager is CoinRecordApi {
            return coinsRecordDatas(jsonData)
        }
        if manager is UserFeedLsApi {
            return feedLsRecordDatas(jsonData)
        }
//
        if manager is UserMsgLsApi {
            return msglistRecordDatas(jsonData)
        }
        if manager is FeedReplyApi {
            return feedReplyDatas(jsonData)
        }
        if manager is CoinConvertApi || manager is WelCardConvertApi {
            return welCardConvertCoins(jsonData)
        }
        /// 订单列表
        if manager is UserOrderListApi {
            return reformOrderListDatas(jsonData)
        }
        /// 添加订单
        if manager is UserOrderAddApi {
            return reformOrderAddDatas(jsonData)
        }
        if manager is RechargeMenuApi {
            return reformRechargeModelDatas(jsonData)
        }
        /// 支付通道
        if manager is PayTypeLsApi {
            return reformPayTypeListDatas(jsonData)
        }
        return nil
    }
}


