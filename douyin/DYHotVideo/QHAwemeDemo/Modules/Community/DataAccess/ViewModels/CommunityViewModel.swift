//
//  CommunityViewModel.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

/// 社区ViewModel
class CommunityViewModel: NSObject {
    ///话题推荐列表
    private lazy var talksListApi: TalksListApi = {
        let api = TalksListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    ///话题关注列表
    private lazy var talksCollectListApi: TalksCollectListApi = {
        let api = TalksCollectListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    ///话题搜索列表
    private lazy var talksSearchListApi: TalksSearchListApi = {
        let api = TalksSearchListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    ///话题关注
    private lazy var talksAddFollowApi: TalksAddFollowApi = {
        let api = TalksAddFollowApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    ///话题取消关注
    private lazy var talksDelFollowApi: TalksDeleteFollowApi = {
        let api = TalksDeleteFollowApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    ///用户动态列表
    private lazy var userTopicListApi: UserTopicListApi = {
        let api = UserTopicListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    ///搜索动态列表
    private lazy var searchTopicListApi: TopicSearchListApi = {
        let api = TopicSearchListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    ///动态点赞
    private lazy var topicFavorApi: TopicFavorApi = {
        let api = TopicFavorApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    ///动态详情
    private lazy var topicDetailApi: TopicDetailApi = {
        let api = TopicDetailApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    ///动态删除
    private lazy var topicDelApi: TopicDeleteApi = {
        let api = TopicDeleteApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    
    /// 所有接口请求的参数
    var apiParams: [String: Any]?
    
    /// 用户话题列表回调
    var talksListApiSuccess:((_ listModels: [TalksModel]?, _ pageNumber: Int) -> Void)?
    var talksListApiApiFail:(() ->Void)?
    /// 话题加入关注 / 取消关注
    var talksAddOrDelFollowSuccess:((_ isAdd: Bool) ->Void)?
    var talksAddOrDelFollowFail:((_ msg: String, _ isAdd: Bool) ->Void)?
    /// 动态列表
    var topicListApiSuccess:((_ listModels: [TopicModel]?, _ pageNumber: Int, _ total: Int?) -> Void)?
    var topicListApiApiFail:(() ->Void)?
    /// 动态点赞
    var topicFavorSuccess:(() ->Void)?
    /// 动态详情
    var topicDetailApiSuccess:((_ model: TopicModel) -> Void)?
    var topicDetailApiApiFail:(() ->Void)?
    /// 动态删除
    var topicDeleteApiSuccess:(()->Void)?
    var topicDeleteApiFailed:((_ msg:String)->Void)?

}

// MARK: - 公开方法，为外部提供获取数据的api
extension CommunityViewModel {
    /// 话题推荐列表
    func loadTalksList(_ params: [String: Any]?) {
        apiParams = params
        _ = talksListApi.loadData()
    }
    func loadTalksNextPage(_ params: [String: Any]?) {
        apiParams = params
        _ = talksListApi.loadNextPage()
    }
    /// 话题关注列表
    func loadTalksCollectList(_ params: [String: Any]?) {
        apiParams = params
        _ = talksCollectListApi.loadData()
    }
    func loadTalksCollectNextPage(_ params: [String: Any]?) {
        apiParams = params
        _ = talksCollectListApi.loadNextPage()
    }
    /// 话题搜索列表
    func loadTalksSearchList(_ params: [String: Any]?) {
        apiParams = params
        _ = talksSearchListApi.loadData()
    }
    func loadTalksSearchNextPage(_ params: [String: Any]?) {
        apiParams = params
        _ = talksSearchListApi.loadNextPage()
    }
    /// 话题添加关注
    func loadTalksAddFollow(_ params: [String: Any]?) {
        apiParams = params
        _ = talksAddFollowApi.loadData()
    }
    /// 话题取消关注
    func loadTalksDelFollow(_ params: [String: Any]?) {
        apiParams = params
        _ = talksDelFollowApi.loadData()
    }
    /// 用户动态列表
    func loadUserTopicList(_ params: [String: Any]?) {
        apiParams = params
        _ = userTopicListApi.loadData()
    }
    func loadUserTopicListNextPage(_ params: [String: Any]?) {
        apiParams = params
        _ = userTopicListApi.loadNextPage()
    }
    /// 搜索动态列表
    func loadSearchTopicList(_ params: [String: Any]?) {
        apiParams = params
        _ = searchTopicListApi.loadData()
    }
    func loadSearchTopicListNextPage(_ params: [String: Any]?) {
        apiParams = params
        _ = searchTopicListApi.loadNextPage()
    }
    /// 动态点赞
    func loadTopicFavor(_ params: [String: Any]?) {
        apiParams = params
        _ = topicFavorApi.loadData()
    }
    func loadTopicDetail(_ params: [String: Any]?) {
        apiParams = params
        _ = topicDetailApi.loadData()
    }
    func loadTopicDelApi(_ params: [String :Any]?) {
        apiParams = params
        _ = topicDelApi.loadData()
    }
}

// MARK: - 私有方法，用于处理一些业务逻辑
private extension CommunityViewModel {
    
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension CommunityViewModel: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        return apiParams
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is TalksListApi || manager is TalksSearchListApi {
            if let model = manager.fetchJSONData(CommunityReformer()) as? TalksListModel {
                talksListApiSuccess?(model.data, manager is TalksListApi ? talksListApi.pageNumber : talksSearchListApi.pageNumber)
            }
        }
        if manager is TalksCollectListApi  {
            if let models = manager.fetchJSONData(CommunityReformer()) as? TalksListModel {
                talksListApiSuccess?(models.data, talksCollectListApi.pageNumber)
            }
        }
        if manager is TalksAddFollowApi || manager is TalksDeleteFollowApi  {
            talksAddOrDelFollowSuccess?(manager is TalksAddFollowApi)
        }
        if manager is UserTopicListApi  || manager is TopicSearchListApi {
            if let model = manager.fetchJSONData(CommunityReformer()) as? TopicListModel {
                topicListApiSuccess?(model.data, manager is UserTopicListApi ? userTopicListApi.pageNumber : searchTopicListApi.pageNumber, model.total)
            }
        }
        if manager is TopicFavorApi {
            topicFavorSuccess?()
        }
        if manager is TopicDetailApi {
            if let model = manager.fetchJSONData(CommunityReformer()) as? TopicModel {
                topicDetailApiSuccess?(model)
            }
        }
        if manager is TopicDeleteApi {
            topicDeleteApiSuccess?()
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        if manager is TalksAddFollowApi || manager is TalksDeleteFollowApi {
            talksAddOrDelFollowFail?(manager.errorMessage, manager is TalksAddFollowApi)
        }
        if manager is TalksListApi || manager is TalksCollectListApi || manager is TalksSearchListApi {
            talksListApiApiFail?()
        }
        if manager is UserTopicListApi {
            topicListApiApiFail?()
        }
        if manager is TopicDetailApi {
            topicDetailApiApiFail?()
        }
        if manager is TopicDeleteApi {
            topicDeleteApiFailed?(manager.errorMessage)
        }
    }
}
