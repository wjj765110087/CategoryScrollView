//
//  UserInfoViewModel.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/14.
//  Copyright © 2018年 pro5. All rights reserved.
//

import UIKit
import NicooNetwork

struct CellEditModel {
    var videoModel: VideoModel?
    var isSelected: Bool?   // 此属性是本地为了区分数据Model的选中状态而加的，初始值应该为nil
    
}

/// 用户信息ViewModel
class UserInfoViewModel: NSObject {
    
    private lazy var userInfoApi: UserInfoApi = {
        let api = UserInfoApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var userInfoOtherApi: UserInfoOtherApi = {
        let api = UserInfoOtherApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var collectListApi: UserFavorListApi = {
        let api = UserFavorListApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    
    private lazy var cancleFavorApi: UserFavorCancleApi = {
        let api = UserFavorCancleApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
   
    private lazy var userFadeBackApi: UserFadeBackApi = {
        let api = UserFadeBackApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    private lazy var videoFavorApi: UserFavorAddApi =  {
        let api = UserFavorAddApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var userFollowCountApi: UserFollowCountApi = {
        let api = UserFollowCountApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var userFansCountApi: UserFansCountApi = {
        let api = UserFansCountApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var followStatuApi: UserFollowStatuApi = {
        let api = UserFollowStatuApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var userAddFollowApi: UserAddFollowApi = {
        let api = UserAddFollowApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var userCancleFollowApi: UserCancleFollowApi = {
        let api = UserCancleFollowApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    /// 反馈消息 回复
    private lazy var replyApi: FeedReplyApi = {
        let api = FeedReplyApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    private lazy var adFavorApi: UserAdFavorAddApi =  {
        let api = UserAdFavorAddApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var acountBackApi: AcountBackWithPhoneApi =  {
        let api = AcountBackWithPhoneApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var infoFindApi: InfoFindAcountApi = {
        let api = InfoFindAcountApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    private lazy var sortFindApi: RecallByCardApi = {
        let api = RecallByCardApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    private lazy var recordCheckApi: UserApplyCheckApi = {
        let api = UserApplyCheckApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    /// 兑换vip详情
    private lazy var convertInfoApi: VipConvertInfoApi = {
        let api = VipConvertInfoApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    /// 兑换vip
    private lazy var convertApi: VipCardExChangeApi = {
        let api = VipCardExChangeApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    private lazy var inviteLinkApi: UserInviteLinkApi = {
        let api = UserInviteLinkApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    private lazy var walletApi: UserWalletApi = {
        let api = UserWalletApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var coinsBuyVideoApi: UseBuyVideoApi = {
        let api = UseBuyVideoApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    var videoList = [VideoModel]()
    var cellEditModelList = [CellEditModel]()
    var recordCheckInfoModel = ApplyCheckInfoModel()
    
    
    /// 批量删除 视频Id列表(收藏，历史观看)
    var cancleVideoIds: [Int]?
    /// 用户详情
    var paramsUserInfo: [String: Any]?
    /// 用户反馈Api参数
    var paramsFadeBack: [String: Any]?
    /// 用户回复反馈消息
    var paramsReply: [String: Any]?
    /// 用户点赞视频Api参数
    var paramsFavor: [String: Any]?
    /// 用户手机号找回账号信息
    var paramsAcountBack: [String: Any]?
    /// 用户原信息找回账号信息
    var paramsAcountInfo: [String: Any]?
    /// 用户盐找回
    var paramsSort: [String: Any]?
    /// paramsForuser
    var paramsUserCenter: [String: Any]?
    /// 关注相关参数
    var paramsFollow: [String: Any]?
    /// 兑换vip
    var paramsExchange:[String: Any]?
    var paramsAddGroup: [String : Any]?
    /// 金币购买视频
    var paramsCoinsBuyVideo: [String : Any]?
    
    /// 用户收藏列表,观看历史记录 回调
    var loadUserVideoListApiSuccess:((_ dataCount: Int) -> Void)?
    var loadUserVideoListApiFail: (() ->Void)?
    
    /// 历史观看删除成功回调（用于回调用户主页，刷新历史观看列表）
    var loadDeletedWatchedListSuccessHandler:(() ->Void)?
    /// 用户信息请求
    var loadUserInfoSuccessHandler:(() ->Void)?
    var loadUserInfoFailHandler:(() ->Void)?
    /// 用户别人信息请求
    var loadUserOtherInfoSuccessHandler:((_ user: UserInfoModel) ->Void)?
    var loadUserOtherInfoFailHandler:(() ->Void)?
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
    /// 用户上传资质校验
    var recordCheckApiSuccessHandler:(() ->Void)?
    var recordCheckApiFailHandler:((_ msg: String) ->Void)?
    /// 用户关注粉丝数量回调
    var fansOrFollowCountApiSuccessHandler:((_ count: Int, _ isFollow: Bool) ->Void)?
    var fansOrFollowApiFailHandler:((_ msg: String) ->Void)?
    
    /// 钱包信息
    var loadWalletInfoSuccessHandler:(() ->Void)?
    var loadWalletInfoFailedHandler:(() ->Void)?
    
    /// 关注状态回调
    var followStatuCallBackhandler:((_ statu:FollowStatu) -> Void)?

    /// 添加关注 取消关注回调
    var followAddOrCancelSuccessHandler:((_ isAdd: Bool, _ followModel: FollowOrCancelModel?)->())?
    var followOrCancelFailureHandler:((_ isAdd: Bool, _ msg: String)->())?
    // 用户兑换会员卡
    var exchangeInfoApiSuccessHandler:((_ model: ExCoinsInfo) ->Void)?
    var exchangeIndoApiFailHandler:((_ msg: String) ->Void)?
    /// 兑换结果
    var convertVipSuccessHandler:((_ model: ExCoinsInfo) ->Void)?
    var convertVipFailHandler:((_ msg: String) ->Void)?
    
    var addGroupLinkSuccessHandler: ((_ models: [AddGroupLinkModel])->())?
    var addGroupLinkFailureHandelr: ((_ msg: String)->())?
    
    /// 购买视频
    var coinsBuyVideoSuccessHandler:(() ->Void)?
    var coinsBuyVideovFailedHandler:((_ msg: String) ->Void)?
    
    /// 请求用户信息
    func loadUserInfo() {
        let _ = userInfoApi.loadData()
    }
    /// 请求用户信息
    func loadUserOtherInfo(_ userParams: [String: Any]?) {
        paramsUserInfo = userParams
        let _ = userInfoOtherApi.loadData()
    }
    /// 请求用户收藏列表第一页
    func loadUserCollectedListApi() {
        let _ = collectListApi.loadData()
    }
    
    /// 请求用户收藏列表下一页
    func loadUserCollectedNextPage() {
        let _ = collectListApi.loadNextPage()
    }
    
    /// 批量删除收藏
    ///
    /// - Parameter videoIds: 视屏Id集合
    func cancleFavor(_ videoIds: [Int]) {
        cancleVideoIds = videoIds
        let _ = cancleFavorApi.loadData()
    }
    
    /// 用户反馈
    func fadeBack(_ params: [String: Any]) {
        paramsFadeBack = params
        let _ = userFadeBackApi.loadData()
    }
    
    /// 消息回复
    func replyFeedMsg(_ params: [String: Any]) {
        paramsReply = params
        let _ = replyApi.loadData()
    }
    
    /// 视频添加点赞
    func addVideoFavor(_ params: [String: Any]) {
        paramsFavor = params
        let _ = videoFavorApi.loadData()
    }
    
    ///广告添加点赞
    func addAdFavor(_ params: [String: Any]) {
        paramsFavor = params
        let _ = adFavorApi.loadData()
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
    
    /// 用户上传视频资质校验
    func recordCheck() {
        let _ = recordCheckApi.loadData()
    }
    
    func loadFollowCount(_ params: [String: Any]) {
        paramsUserCenter = params
        let _  = userFollowCountApi.loadData()
    }
    func loadFansCount(_ params: [String: Any]) {
        paramsUserCenter = params
        let _  = userFansCountApi.loadData()
    }
    
    /// 获取关注状态
    func loadFollowStatu(_ params: [String: Any]) {
        paramsFollow = params
        let _ = followStatuApi.loadData()
    }
    
    /// 添加关注
    func loadAddFollowApi(_ params: [String: Any]) {
        paramsFollow = params
        let _ = userAddFollowApi.loadData()
    }
    
    /// 取消关注
    func loadCancleFollowApi(_ params: [String: Any]) {
        paramsFollow = params
        let _ = userCancleFollowApi.loadData()
    }
    /// 兑换Vip
    func exchangeVip(_ params: [String: Any]) {
        paramsExchange = params
        let _ = convertApi.loadData()
    }
    /// 兑换卷详情
    func exchangeInfo(_ params: [String: Any]) {
        paramsExchange = params
        let _ = convertInfoApi.loadData()
    }
    
    ///推广交流
    func inviteLinkInfo(_ params: [String : Any]?) {
        paramsAddGroup = params
        let _ = inviteLinkApi.loadData()
    }
    
    /// 拉取钱包信息
    func loadWalletInfo(params: [String : Any]? ,succeedHandler: @escaping () -> (),
                           failHandler: @escaping () -> ()) {
        loadWalletInfoFailedHandler = failHandler
        loadWalletInfoSuccessHandler = succeedHandler
         _ = walletApi.loadData()
    }
    
    /// 金币购买视频
    func coinsBuyVideo(params: [String : Any]? ,succeedHandler: @escaping () -> (),
                        failHandler: @escaping (_ failMessage: String) -> ()) {
        paramsCoinsBuyVideo = params
        coinsBuyVideovFailedHandler = failHandler
        coinsBuyVideoSuccessHandler = succeedHandler
        _ = coinsBuyVideoApi.loadData()
    }
    
}

// MARK: - 收藏 , 历史观看 列表
extension UserInfoViewModel {
    
    private func requestVideoListSuccess(_ listModel: VideoListModel) {
        if let list = listModel.data, let pageNumber = listModel.current_page {
            if pageNumber == 1 {
                videoList = list
                cellEditModelList = createFakeModel(list)
            } else {
                videoList.append(contentsOf: list)
                cellEditModelList.append(contentsOf: createFakeModel(list))
            }
            loadUserVideoListApiSuccess?(list.count)
        }
    }
    
    /// 创建表编辑model
    private func createFakeModel(_ videoList: [VideoModel]) -> [CellEditModel] {
        var fakeModelList = [CellEditModel]()
        for video in videoList {
            let fakeModel = CellEditModel(videoModel: video, isSelected: false)
            fakeModelList.append(fakeModel)
        }
        return fakeModelList
    }
    
    /// 获取视频列表
    func getVideoList() -> [VideoModel] {
        return videoList
    }
   
    /// 获取视频Model
    func getVideoModel(_ index: Int) -> VideoModel {
        if videoList.count > index {
            return videoList[index]
        }
        return VideoModel()
    }
    
    /// 获取表编辑对象和Model
    func getCellEditModelList() -> [CellEditModel] {
        return cellEditModelList
    }
    
    func getCellEditModel(_ index: Int) -> CellEditModel {
        if cellEditModelList.count > index {
            return cellEditModelList[index]
        }
        return CellEditModel()
    }
}

// MARK: - 请求用户信息
extension UserInfoViewModel {
    /// 请求成功，给单利赋值
    func requestUserInfoSuccess(_ user: UserInfoModel) {
      //DLog("user ========== \(user)")
        UserModel.share().userInfo = user
        UserModel.share().isRealUser = user.type == 0
        UserModel.share().isLogin = true
        UserDefaults.standard.set(user.code, forKey: UserDefaults.kUserInviteCode)
        UserDefaults.standard.set(user.api_token, forKey: UserDefaults.kUserToken)
        loadUserInfoSuccessHandler?()
    }
    /// 找回用户成功
    func findAcountBackSuccess(_ oldUser: UserInfoModel) {
        UserModel.share().userInfo = oldUser
        UserModel.share().isRealUser = oldUser.type == 0
        UserModel.share().isLogin = true
        UserDefaults.standard.set(oldUser.code, forKey: UserDefaults.kUserInviteCode)
        UserDefaults.standard.set(oldUser.api_token, forKey: UserDefaults.kUserToken)
        loadUserFindBackSuccessHandler?()
    }
    /// 请求成功，给单利赋值
    func requestUserOtherInfoSuccess(_ user: UserInfoModel) {
        loadUserOtherInfoSuccessHandler?(user)
    }
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension UserInfoViewModel: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        var params = [String: Any]()
        if manager is UserFavorCancleApi  {
            params[UserFavorCancleApi.kVideo_ids] = cancleVideoIds
            return params
        }
        if manager is UserFadeBackApi {
            return paramsFadeBack
        }
        if manager is UserFavorAddApi || manager is UserAdFavorAddApi {
            return paramsFavor
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
        if manager is UserFansCountApi || manager is UserFollowCountApi {
            return paramsUserCenter
        }
        if manager is UserFollowStatuApi || manager is UserAddFollowApi || manager is UserCancleFollowApi {
            return paramsFollow
        }
        if manager is VipCardExChangeApi || manager is VipConvertInfoApi {
            return paramsExchange
        }
        
        if manager is UserInviteLinkApi {
            return paramsAddGroup
        }
        if manager is UserInfoOtherApi {
            return paramsUserInfo
        }
        if manager is UseBuyVideoApi {
            return paramsCoinsBuyVideo
        }
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is UserInfoApi {
            if let userInfo = manager.fetchJSONData(UserReformer()) as? UserInfoModel {
                requestUserInfoSuccess(userInfo)
            }
        }
        if manager is UserInfoOtherApi {
            if let userInfo = manager.fetchJSONData(UserReformer()) as? UserInfoModel {
                requestUserOtherInfoSuccess(userInfo)
            }
        }
        if manager is UserFavorListApi {
            if let list = manager.fetchJSONData(VideoReformer()) as? VideoListModel {
                requestVideoListSuccess(list)
            }
        }
        if manager is UserFavorCancleApi {
            loadUserCollectedListApi()
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
        if manager is UserApplyCheckApi {
            if let applyInfo = manager.fetchJSONData(UserReformer()) as? ApplyCheckInfoModel {
                recordCheckInfoModel = applyInfo
                recordCheckApiSuccessHandler?()
            }
        }
        if manager is FeedReplyApi {
            if let msgModel = manager.fetchJSONData(UserReformer()) as? MsgModel {
                replyApiSuccessHandler?(msgModel)
            }
        }
        if manager is UserFansCountApi || manager is UserFollowCountApi {
            if let model = manager.fetchJSONData(UserReformer()) as? UserFollowOrFansCountModel {
               fansOrFollowCountApiSuccessHandler?(model.count ?? 0, manager is UserFollowCountApi)
            }
        }
        if manager is UserFollowStatuApi {
            if let model = manager.fetchJSONData(UserReformer()) as? FollowStatu {
                followStatuCallBackhandler?(model)
            }
        }
        if manager is UserAddFollowApi || manager is UserCancleFollowApi {
            if let model = manager.fetchJSONData(UserReformer()) as? FollowOrCancelModel {
                 followAddOrCancelSuccessHandler?((manager is UserAddFollowApi), model)
            }
        }
        if manager is VipConvertInfoApi {
            if let coinsInfo = manager.fetchJSONData(UserReformer()) as? ExCoinsInfo {
                exchangeInfoApiSuccessHandler?(coinsInfo)
            }
        }
        if manager is VipCardExChangeApi {
            if let coinsInfo = manager.fetchJSONData(UserReformer()) as? ExCoinsInfo {
                convertVipSuccessHandler?(coinsInfo)
            }
        }
        
        if manager is UserInviteLinkApi {
            if let inviteLinks = manager.fetchJSONData(UserReformer()) as? [AddGroupLinkModel] {
                addGroupLinkSuccessHandler?(inviteLinks)
            }
        }
        if manager is UserWalletApi {
            if let wallet = manager.fetchJSONData(UserReformer()) as? WalletInfo {
                UserModel.share().wallet = wallet
                loadWalletInfoSuccessHandler?()
            }
        }
        if manager is UseBuyVideoApi {
            coinsBuyVideoSuccessHandler?()
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        if manager is UserInfoApi {
            loadUserInfoFailHandler?()
        }
        if manager is UserFavorListApi {
            loadUserVideoListApiFail?()
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
        if manager is UserApplyCheckApi {
            recordCheckApiFailHandler?(manager.errorMessage)
        }
        if manager is FeedReplyApi {
            replyApiFailHandler?(manager.errorMessage)
        }
        
        if manager is UserAddFollowApi || manager is UserCancleFollowApi {
            followOrCancelFailureHandler?(manager is UserAddFollowApi, manager.errorMessage)
        }
        if manager is VipConvertInfoApi {
            exchangeIndoApiFailHandler?(manager.errorMessage)
        }
        if manager is VipCardExChangeApi {
            convertVipFailHandler?(manager.errorMessage)
        }
        if manager is UserInviteLinkApi {
            addGroupLinkFailureHandelr?(manager.errorMessage)
        }
        if manager is UserWalletApi {
            loadWalletInfoFailedHandler?()
        }
        if manager is UseBuyVideoApi {
            coinsBuyVideovFailedHandler?(manager.errorMessage)
        }
    }
}
