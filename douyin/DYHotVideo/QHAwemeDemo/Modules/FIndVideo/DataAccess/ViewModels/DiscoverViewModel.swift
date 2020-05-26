//
//  DiscoverViewModel.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/7.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

/// 发现ViewModel
class DiscoverViewModel: NSObject {
    
    ///发现顶部title列表
    private lazy var titleListApi: DiscoveryTitleListApi = {
        let api = DiscoveryTitleListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    private lazy var adContentApi: DiscoverAdContentApi = {
        let api = DiscoverAdContentApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    ///发现首页视频列表
    private lazy var findVideoList: DiscoveryVideoListApi = {
        let api = DiscoveryVideoListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    ///发现排行榜列表
    private lazy var findRankList: DiscoverRankListApi = {
        let api = DiscoverRankListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    ///发现排行榜详情
    private lazy var findRankDetailApi: DiscoverRankDetailApi = {
       let api = DiscoverRankDetailApi()
       api.delegate = self
       api.paramSource = self
       return api
    }()
    
    ///发现排行榜顶部广告
    private lazy var findRankAdApi: DiscoverRankAdApi = {
        let api = DiscoverRankAdApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    private lazy var recommandTrendApi: RecommandTrendApi = {
        let api = RecommandTrendApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    /// 所有接口请求的参数
    var apiParams: [String: Any]?
    
    var requestTitleListSuccessHandler: ((FindVideoTitleListModel, _ pageNum: Int)->())?
    var requestTitleListFailureHandler: ((_ msg: String)->())?
    
    var requestRankListSuccessHandler: (([FindRankModel])->())?
    var requestRankListFailureHandler: ((_ msg: String)->())?
    
    var requestVidoListSuccessHandler: ((FindVideoListModel, _ pageNum: Int)->())?
    var requestVideoListFailureHandler: ((_ msg: String)->())?
    
    var requestRankDetailSuccessHandler: ((FindRankDetailListModel, _ pageNum: Int)->())?
    var requestRankDetailFailureHandler: ((_ msg: String)->())?
    
    var requestAdContentSuccessHandler: (([FindAdContentModel])->())?
    var requestAdContentFailureHandler: ((_ msg: String)->())?
    
    var requestRankAdSuccessHandler: (([FindAdContentModel])->())?
    var requestRankAdFailureHandler: ((_ msg: String)->())?
    
    var requestRecommandTrendSuccessHandler: ((TopicListModel)->())?
    var requestRecommandTrendFailureHandler: ((_ msg: String)->())?}

// MARK: - 公开方法，为外部提供获取数据的api
extension DiscoverViewModel {
    func loadTitleListData(_ params: [String: Any]?) {
        apiParams = params
        _ = titleListApi.loadData()
    }
    func loadTitleListNextPage(_ params: [String: Any]?) {
        apiParams = params
        _ = titleListApi.loadNextPage()
    }
    func loadFindVideoListData(_ params: [String: Any]?) {
        apiParams = params
        _ = findVideoList.loadData()
    }
    func loadFindVideoListNextPage(_ params: [String: Any]?) {
        apiParams = params
        _ = findVideoList.loadNextPage()
    }
    
    func loadFindRankList(_ params: [String: Any]?) {
        apiParams = params
        _ = findRankList.loadData()
    }
    
    func loadFindRankDetailData(_ params: [String: Any]?) {
        apiParams = params
        _ = findRankDetailApi.loadData()
    }
    
    func loadRankDetailNextPage(_ params: [String: Any]?) {
        apiParams = params
        _ = findRankDetailApi.loadNextPage()
    }
    
    func loadAdContentData(_ params: [String: Any]?) {
        apiParams = params
        _ = adContentApi.loadData()
    }
    
    func loadRankAdContentData(_ params: [String: Any]?) {
        apiParams = params
        _ = findRankAdApi.loadData()
    }
    
    func loadRecommandTrendData(_ params: [String: Any]?) {
        apiParams = params
        _ = recommandTrendApi.loadData()
    }
    
    func loadRecommandTrendNextPage(_ params: [String: Any]?) {
        apiParams = params
        _ = recommandTrendApi.loadNextPage()
    }
}

// MARK: - 私有方法，用于处理一些业务逻辑
private extension DiscoverViewModel {
    
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension DiscoverViewModel: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
 
        return apiParams
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is DiscoveryTitleListApi {
            if let model = manager.fetchJSONData(DiscoverReformer()) as? FindVideoTitleListModel {
                requestTitleListSuccessHandler?(model, titleListApi.pageNumber)
            }
        }
        
        if manager is DiscoverAdContentApi {
            if let model = manager.fetchJSONData(DiscoverReformer()) as? FindAdContentListModel {
                if let data = model.data {
                    requestAdContentSuccessHandler?(data)
                }
            }
        }
        
        if manager is DiscoveryVideoListApi {
            if let model = manager.fetchJSONData(DiscoverReformer()) as? FindVideoListModel {
                requestVidoListSuccessHandler?(model, findVideoList.pageNumber)
            }
        }
        
        if manager is DiscoverRankListApi {
            if let model = manager.fetchJSONData(DiscoverReformer()) as? [FindRankModel] {
                requestRankListSuccessHandler?(model)
            }
        }
        
        if manager is DiscoverRankDetailApi {
            if let model = manager.fetchJSONData(DiscoverReformer()) as? FindRankDetailListModel {
                requestRankDetailSuccessHandler?(model, findRankDetailApi.pageNumber)
            }
        }
        
        if manager is DiscoverRankAdApi {
            if let model = manager.fetchJSONData(DiscoverReformer()) as? [FindAdContentModel] {
                requestRankAdSuccessHandler?(model)
            }
        }
        
        if manager is RecommandTrendApi {
            if let model = manager.fetchJSONData(SearchReformer()) as? TopicListModel {
                requestRecommandTrendSuccessHandler?(model)
            }
        }
        
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        
        if manager is DiscoveryTitleListApi {
            requestTitleListFailureHandler?(manager.errorMessage)
        }
        
        if manager is DiscoverAdContentApi {
            requestAdContentFailureHandler?(manager.errorMessage)
        }
        
        if manager is DiscoveryVideoListApi {
            requestVideoListFailureHandler?(manager.errorMessage)
        }
        
        if manager is DiscoverRankListApi {
            requestRankListFailureHandler?(manager.errorMessage)
        }
        
        if manager is DiscoverRankDetailApi {
            requestRankDetailFailureHandler?(manager.errorMessage)
        }
        
        if manager is DiscoverRankAdApi {
            requestRankAdFailureHandler?(manager.errorMessage)
        }
        
        if manager is RecommandTrendApi {
           requestRecommandTrendFailureHandler?(manager.errorMessage)
        }
    }
}
