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
    
    // MARK: - 用户订单列表
    private func reformOrderListDatas(_ data: Data?) -> Any? {
        if let loginInfo = try? decode(response: data, of: ObjectResponse<OrderListModel>.self)?.result {
            return loginInfo
        }
        return nil
    }
    // MARK: - 用户信息
    private func reformUserInfoDatas(_ data: Data?) -> Any? {
        if let videoList = try? decode(response: data, of: ObjectResponse<UserInfoModel>.self)?.result {
            return videoList
        }
        return nil
    }
    // MARK: - 卡片列表
    private func reformVipCardsDatas(_ data: Data?) -> Any? {
        if let videoList = try? decode(response: data, of: ObjectResponse<VipCardListModel>.self)?.result {
            return videoList
        }
        return nil
    }
    // MARK: - 上门服务列表
    private func reformUpDoorServerDatas(_ data: Data?) -> Any? {
        if let videoList = try? decode(response: data, of: ObjectResponse<UpDoorServerListModel>.self)?.result {
            return videoList
        }
        return nil
    }
    // MARK: - 折扣卡 为获得 列表
    private func reformWelfareCardsDatas(_ data: Data?) -> Any? {
        if let videoList = try? decode(response: data, of: ObjectResponse<[WelfareUnowedCard]>.self)?.result {
            return videoList
        }
        return nil
    }
    // MARK: - 折扣卡 未使用 列表
    private func reformWelfareUnusedCardsDatas(_ data: Data?) -> Any? {
        if let videoList = try? decode(response: data, of: ObjectResponse<WelfareGetCardList>.self)?.result {
            return videoList
        }
        return nil
    }
    // MARK: - 折扣卡 已失效 列表
    private func reformWelfareInvailCardsDatas(_ data: Data?) -> Any? {
        if let videoList = try? decode(response: data, of: ObjectResponse<WelfareGetCardList>.self)?.result {
            return videoList
        }
        return nil
    }
    // MARK: - 邀请规则
    private func reformInviteRulesDatas(_ data: Data?) -> Any? {
        if let videoList = try? decode(response: data, of: ObjectResponse<[InviteRuleModel]>.self)?.result {
            return videoList
        }
        return nil
    }
    // MARK: - 邀请记录
    private func reformInvitedListDatas(_ data: Data?) -> Any? {
        if let invitedList = try? decode(response: data, of: ObjectResponse<InviteListModel>.self)?.result {
            return invitedList
        }
        return nil
    }
    // MARK: - 点击购买
    private func reformBuyActionDataListDatas(_ data: Data?) -> Any? {
        if let invitedList = try? decode(response: data, of: ObjectResponse<OrderDetailModel>.self)?.result {
            return invitedList
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
    // MARK: - 获取支付通道列表
    private func reformPayTypeListDatas(_ data: Data?) -> Any? {
        if let invitedList = try? decode(response: data, of: ObjectResponse<[PayTypeModel]>.self)?.result {
            return invitedList
        }
        return nil
    }
    // MARK: - 通过手机号找回原账号
    private func reformAcountBackWithPhoneDatas(_ data: Data?) -> Any? {
        if let oldUser = try? decode(response: data, of: ObjectResponse<UserInfoModel>.self)?.result {
            return oldUser
        }
        return nil
    }
    // MARK: - 反馈的默认可选问题列表
    private func reformUserFadeBackquestionsDatas(_ data: Data?) -> Any? {
        if let oldUser = try? decode(response: data, of: ObjectResponse<[QuestionModel]>.self)?.result {
            return oldUser
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
    // MARK: - 用户校验上传资质Api
    private func reformUserApplyCheckDatas(_ data: Data?) -> Any? {
        if let oldUser = try? decode(response: data, of: ObjectResponse<ApplyCheckInfoModel>.self)?.result {
            return oldUser
        }
        return nil
    }
    // MARK: - 用户校验剩余次数Api
    private func reformUserUploadCountDatas(_ data: Data?) -> Any? {
        if let count = try? decode(response: data, of: ObjectResponse<Int>.self)?.result {
            return count
        }
        return nil
    }
    // MARK: - 用户金钱信息
    private func reformUserWalletInfoDatas(_ data: Data?) -> Any? {
        if let wallet = try? decode(response: data, of: ObjectResponse<WalletInfo>.self)?.result {
            return wallet
        }
        return nil
    }
    // MARK: - 用户金钱账单信息
    private func reformUserWalletRecordsDatas(_ data: Data?) -> Any? {
        if let wallet = try? decode(response: data, of: ObjectResponse<WalletRecordLs>.self)?.result {
            return wallet
        }
        return nil
    }
    // MARK: - 用户关注数 和用户粉丝数
    private func reformUserFollowOrFansDatas(_ data: Data?) -> Any? {
        if let oldUser = try? decode(response: data, of: ObjectResponse<UserFollowOrFansCountModel>.self)?.result {
            return oldUser
        }
        return nil
    }
    // MARK: - 用户关注列表 和用户粉丝列表
    private func reformUserFollowOrFansList(_ data: Data?) -> Any? {
        if let oldUser = try? decode(response: data, of: ObjectResponse<FollowListModel>.self)?.result {
            return oldUser
        }
        return nil
    }
    // 用户关注状态
    private func reforUserFollowStatuDatas(_ data: Data?) -> Any? {
        if let oldUser = try? decode(response: data, of: ObjectResponse<FollowStatu>.self)?.result {
            return oldUser
        }
        return nil
    }
    ///关注 | 取消关注
    private func  reformUserFollowOrCancelFollowDatas(_ data: Data?) -> Any? {
        if let followOrCancel = try? decode(response: data, of: ObjectResponse<FollowOrCancelModel>.self)?.result {
            return followOrCancel
        }
        return nil
    }
    /// 兑换Vip
    private func vipCardConvertData(_ data: Data?) -> Any? {
        if let taskList = try? decode(response: data, of: ObjectResponse<ExCoinsInfo>.self)?.result {
            return taskList
        }
        return nil
    }
    
    ///加群交流
    private func addGroupLinkData(_ data: Data?) -> Any? {
        if let groupLink = try? decode(response: data, of: ObjectResponse<[AddGroupLinkModel]>.self)?.result {
            return groupLink
        }
        return nil
    }
    /// 活动上传排行列表
    private func activityUserUploadRankData(_ data: Data?) -> Any? {
        if let groupLink = try? decode(response: data, of: ObjectResponse<UserListModel>.self)?.result {
            return groupLink
        }
        return nil
    }
    
    /// 金币套餐
    private func reformCoinListData(_ data: Data?) -> Any? {
        if let coinList = try? decode(response: data, of: ObjectResponse<CoinListModel>.self)?.result {
            return coinList
        }
        return nil
    }
    
    ///余额明细
    private func reformMoneyDetaiListData(_ data: Data?) -> Any? {
        if let moneyDetailList = try? decode(response: data, of: ObjectResponse<MoneyDetailList>.self)?.result {
            return moneyDetailList
        }
        return nil
    }
    
    ///金币明细
    private func reformCoinDetailListData(_ data: Data?) -> Any? {
        if let coinDetailList = try? decode(response: data, of: ObjectResponse<CoinDetailListModel>.self)?.result {
            return coinDetailList
        }
        return nil
    }
}

extension UserReformer: NicooAPIManagerDataReformProtocol {
    
    func manager(_ manager: NicooBaseAPIManager, reformData jsonData: Data?) -> Any? {
        if manager is UserInfoApi || manager is UserInfoOtherApi {
            return reformUserInfoDatas(jsonData)
        }
        if manager is UserOrderListApi {
            return reformOrderListDatas(jsonData)
        }
        if manager is VipCardsApi {
            return reformVipCardsDatas(jsonData)
        }
        if manager is UpDoorServerApi {
            return reformUpDoorServerDatas(jsonData)
        }
        if manager is WelfareUnownedCardApi {
            return reformWelfareCardsDatas(jsonData)
        }
        if manager is WelfareUnusedCardApi {
            return reformWelfareUnusedCardsDatas(jsonData)
        }
        if manager is WelfareInvailCardApi {
            return reformWelfareInvailCardsDatas(jsonData)
        }
        if manager is InvitationRulesApi {
            return reformInviteRulesDatas(jsonData)
        }
        if manager is UserInvitedListApi {
            return reformInvitedListDatas(jsonData)
        }
        
        if manager is UserBuyVipActionApi {
            return reformBuyActionDataListDatas(jsonData)
        }
        
        if manager is UserOrderAddApi {
            return reformOrderAddDatas(jsonData)
        }
        if manager is UserPayTypeListApi {
            return reformPayTypeListDatas(jsonData)
        }
        if manager is AcountBackWithPhoneApi || manager is RecallByCardApi || manager is UserRegisterApi {
            return reformAcountBackWithPhoneDatas(jsonData)
        }
        if manager is UserQuestionApi {
            return reformUserFadeBackquestionsDatas(jsonData)
        }
        if manager is UserApplyCheckApi {
            return reformUserApplyCheckDatas(jsonData)
        }
        if manager is UserUploadCountApi {
            return reformUserUploadCountDatas(jsonData)
        }
        if manager is UserWalletApi {
            return reformUserWalletInfoDatas(jsonData)
        }
        if manager is UserWalletRecordsApi {
            return reformUserWalletRecordsDatas(jsonData)
        }
        if manager is UserFeedLsApi {
            return feedLsRecordDatas(jsonData)
        }

        if manager is UserMsgLsApi {
            return msglistRecordDatas(jsonData)
        }
        if manager is FeedReplyApi {
            return feedReplyDatas(jsonData)
        }
        if manager is UserFansCountApi || manager is UserFollowCountApi {
            return reformUserFollowOrFansDatas(jsonData)
        }
        if manager is UserFollowListApi || manager is UserFansListApi {
            return reformUserFollowOrFansList(jsonData)
        }
        if manager is UserFollowStatuApi {
            return reforUserFollowStatuDatas(jsonData)
        }
        
        if manager is UserAddFollowApi || manager is UserCancleFollowApi {
            return reformUserFollowOrCancelFollowDatas(jsonData)
        }
        if manager is VipCardExChangeApi || manager is VipConvertInfoApi {
            return vipCardConvertData(jsonData)
        }
        if manager is UserInviteLinkApi {
            return addGroupLinkData(jsonData)
        }
        
        if manager is ActivityRankUploadApi {
            return activityUserUploadRankData(jsonData)
        }
        
        if manager is CoinListApi {
            return reformCoinListData(jsonData)
        }
        
        if manager is UserBalanceDetailApi {
            return reformMoneyDetaiListData(jsonData)
        }
        
        if manager is UserCoinsDetailApi {
            return reformCoinDetailListData(jsonData)
        }
        return nil
    }
}


