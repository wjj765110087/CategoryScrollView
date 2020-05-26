//
//  AcountViewModel.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import Foundation
import NicooNetwork

/// 用户ViewModel
class AcountViewModel: NSObject {
    
    // MARK: - APIs
    private lazy var userInfoApi: UserInfoApi = {
        let api = UserInfoApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    ///  手机号找回
    private lazy var acountBackApi: AcountBackWithPhoneApi =  {
        let api = AcountBackWithPhoneApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    /// 填写资料找回
    private lazy var infoFindApi: InfoFindAcountApi = {
        let api = InfoFindAcountApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    /// 身份卡找回
    private lazy var sortFindApi: RecallByCardApi = {
        let api = RecallByCardApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    /// 用户反馈
    private lazy var userFadeBackApi: UserFadeBackApi = {
        let api = UserFadeBackApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    /// 反馈消息 回复
    private lazy var replyApi: FeedReplyApi = {
        let api = FeedReplyApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    /// 做任务
    private lazy var taskDoneApi: TaskDoneApi = {
        let api = TaskDoneApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    /// 兑换Cbi详情
    private lazy var exchangeApi: WelCardConvertApi = {
        let api = WelCardConvertApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    /// 兑换Cbi
    private lazy var convertApi: CoinConvertApi = {
        let api = CoinConvertApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    /// 历史记录
    private lazy var hisLsApi: HistoryApi = {
        let api = HistoryApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    /// 删除历史记录
    private lazy var hisCancleApi: UserHisCancleApi = {
        let api = UserHisCancleApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    /// 取消收藏
    private lazy var cancleFavorApi: UserFavorCancleApi = {
        let api = UserFavorCancleApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    
    // MARK: - Params
    
    /// 用户反馈Api参数
    var paramsFadeBack: [String: Any]?
    /// 用户手机号找回账号信息
    var paramsAcountBack: [String: Any]?
    /// 用户原信息找回账号信息
    var paramsAcountInfo: [String: Any]?
    /// 用户盐找回
    var paramsSort: [String: Any]?
    /// 用户回复反馈消息
    var paramsReply: [String: Any]?
    /// 用户任务参数
    var paramsTaskDone: [String: Any]?
    var paramsExchange:[String: Any]?
    /// 历史删除 + 取消收藏
    var paramsCancle: [String: Any]?
    
    // MARK: - CallBack
    
    /// 用户信息请求
    var loadUserInfoSuccessHandler:(() ->Void)?
    var loadUserInfoFailHandler:(() ->Void)?
    /// 用户找回原账号
    var loadUserFindBackSuccessHandler:(() ->Void)?
    var loadUserFindBackFailHandler:((_ msg: String) ->Void)?
    /// 用户提交原信息找回账号毁掉
    var infoFindApiSuccessHandler:(() ->Void)?
    var infoFindApiFailHandler:(() ->Void)?
    /// 用户sort回账号毁掉
    var sortFindApiSuccessHandler:(() ->Void)?
    var sortFindApiFailHandler:(() ->Void)?
    /// 用户反馈
    var fadeBackSuccessHandler:(() ->Void)?
    var fadeBackFailHandler:((_ msg: String) ->Void)?
    /// 用户回复反馈消息 回调
    var replyApiSuccessHandler:((_ msgModel: MsgModel) ->Void)?
    var replyApiFailHandler:((_ msg: String) ->Void)?
    // 用户兑换金币
    var exchangeApiSuccessHandler:((_ model: ExCoinsInfo) ->Void)?
    var exchangeApiFailHandler:((_ msg: String) ->Void)?
    /// 兑换结果
    var convertCoinsSuccessHandler:((_ model: ExCoinsInfo) ->Void)?
    var convertCoinsFailHandler:((_ msg: String) ->Void)?
    /// 取消收藏 和 删除历史记录
    var cancleApiSuccessHandler:(() ->Void)?
    var cancleApiFailHandler:((_ msg: String) ->Void)?
    /// 历史记录
    var loadHistoryListSuccessHandler:(() ->Void)?
    var loadHistoryListFailHandler:(() ->Void)?
    
    var videoList = [VideoModel]()
    
    

    
}

// MARK: - 请求接口
extension AcountViewModel {
    /// 请求用户信息
    func loadUserInfo() {
        let _ = userInfoApi.loadData()
    }
    /// 用户反馈
    func fadeBack(_ params: [String: Any]) {
        paramsFadeBack = params
        let _ = userFadeBackApi.loadData()
    }
    /// 用户通过手机号找回用户信息
    func findAcountBack(_ params: [String: Any]){
        paramsAcountBack = params
        let _ = acountBackApi.loadData()
    }
    /// 用户通过用户信息找回原账号
    func findAcountWithInfo(_ params: [String: Any]){
        paramsAcountInfo = params
        let _ = infoFindApi.loadData()
    }
    /// 利用身份卡二维码找回
    func findAcountWithSort(_ params: [String: Any]){
        paramsSort = params
        let _ = sortFindApi.loadData()
    }
    /// 消息回复
    func replyFeedMsg(_ params: [String: Any]) {
        paramsReply = params
        let _ = replyApi.loadData()
    }
    /// 做任务
    func taskDone(_ params: [String: Any]) {
        paramsTaskDone = params
        let _ = taskDoneApi.loadData()
    }
    /// 兑换Cn币
    func exchangeCoins(_ params: [String: Any]) {
        paramsExchange = params
        let _ = exchangeApi.loadData()
    }
    
    func convertCoins() {
        let _ = convertApi.loadData()
    }
    
    /// 删除收藏
    func cancelFavorList() {
        let _ = cancleFavorApi.loadData()
    }
    /// 删除历史
    func cancelHisList() {
        let _ = hisCancleApi.loadData()
    }
    /// 历史记录
    func loadHisListVideo() {
        let _ = hisLsApi.loadData()
    }
    
    
}

// MARK: - 请求用户信息
private extension AcountViewModel {
    /// 请求成功，给单利赋值
    func requestUserInfoSuccess(_ user: UserInfoModel) {
        UserModel.share().userInfo = user
        UserModel.share().isLogin = true
        UserDefaults.standard.set(user.invite_code, forKey: UserDefaults.kUserInviteCode)
        UserDefaults.standard.set(user.api_token, forKey: UserDefaults.kUserToken)
        loadUserInfoSuccessHandler?()
    }
    /// 找回用户成功
    func findAcountBackSuccess(_ oldUser: UserInfoModel) {
        UserModel.share().userInfo = oldUser
        UserModel.share().isLogin = true
        UserDefaults.standard.set(oldUser.invite_code, forKey: UserDefaults.kUserInviteCode)
        UserDefaults.standard.set(oldUser.api_token, forKey: UserDefaults.kUserToken)
        loadUserFindBackSuccessHandler?()
    }
}


// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension AcountViewModel: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        
        if manager is UserFadeBackApi {
            return paramsFadeBack
        }
        if manager is AcountBackWithPhoneApi {
            return paramsAcountBack
        }
        if manager is InfoFindAcountApi {
            return paramsAcountInfo
        }
        if manager is RecallByCardApi {
            return paramsSort
        }
        if manager is FeedReplyApi {
            return paramsReply
        }
        if manager is TaskDoneApi {
            return paramsTaskDone
        }
        if manager is WelCardConvertApi || manager is CoinConvertApi {
            return paramsExchange
        }
        if manager is UserFavorCancleApi || manager is UserHisCancleApi {
            return paramsCancle
        }
        
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is UserInfoApi {
            if let userInfo = manager.fetchJSONData(UserReformer()) as? UserInfoModel {
                requestUserInfoSuccess(userInfo)
            }
        }
        if manager is UserFadeBackApi {
            fadeBackSuccessHandler?()
        }
        if manager is AcountBackWithPhoneApi {
            if let userInfo = manager.fetchJSONData(UserReformer()) as? UserInfoModel {
                findAcountBackSuccess(userInfo)
            }
        }
        if manager is InfoFindAcountApi {
            infoFindApiSuccessHandler?()
        }
        if manager is RecallByCardApi {
            if let userInfo = manager.fetchJSONData(UserReformer()) as? UserInfoModel {
                findAcountBackSuccess(userInfo)
            }
        }
        if manager is FeedReplyApi {
            if let msgModel = manager.fetchJSONData(UserReformer()) as? MsgModel {
                replyApiSuccessHandler?(msgModel)
            }
        }
        if manager is TaskDoneApi {
            NotificationCenter.default.post(name: Notification.Name.kLoadTaskListNotification, object: nil)
        }
        if manager is WelCardConvertApi {
            if let coinsInfo = manager.fetchJSONData(UserReformer()) as? ExCoinsInfo {
                exchangeApiSuccessHandler?(coinsInfo)
            }
        }
        if manager is CoinConvertApi {
            if let coinsInfo = manager.fetchJSONData(UserReformer()) as? ExCoinsInfo {
                convertCoinsSuccessHandler?(coinsInfo)
            }
        }
        
        if manager is UserFavorCancleApi || manager is UserHisCancleApi {
            cancleApiSuccessHandler?()
        }
        if manager is HistoryApi {
            if let videoModel = manager.fetchJSONData(HotReformer()) as? VideoListModel {
                if let videoList = videoModel.data {
                    self.videoList = videoList
                    loadHistoryListSuccessHandler?()
                }
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        if manager is UserInfoApi {
            loadUserInfoFailHandler?()
        }
        if manager is UserFadeBackApi {
            fadeBackFailHandler?(manager.errorMessage)
        }
        if manager is AcountBackWithPhoneApi {
            loadUserFindBackFailHandler?(manager.errorMessage)
        }
        if manager is InfoFindAcountApi {
            infoFindApiFailHandler?()
        }
        if manager is RecallByCardApi {
            loadUserFindBackFailHandler?(manager.errorMessage)
        }
        if manager is FeedReplyApi {
            replyApiFailHandler?(manager.errorMessage)
        }
        if manager is WelCardConvertApi  {
            exchangeApiFailHandler?(manager.errorMessage)
        }
        if manager is CoinConvertApi {
            convertCoinsFailHandler?(manager.errorMessage)
        }
        if manager is UserFavorCancleApi || manager is UserHisCancleApi {
            cancleApiFailHandler?(manager.errorMessage)
        }
    }
    
}
