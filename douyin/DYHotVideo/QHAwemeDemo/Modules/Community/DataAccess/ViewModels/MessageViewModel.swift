//
//  MessageViewModel.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/9.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

class MessageViewModel: NSObject {

    private lazy var messageNewNumApi: MessageApis = {
          let api = MessageApis()
          api.paramSource = self
          api.delegate = self
          return api
    }()
    
    private lazy var systemMessageNoticeApi: SystemMessageListApi = {
        let api = SystemMessageListApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    
    private lazy var feedlsApi: UserFeedLsApi = {
        let api = UserFeedLsApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    /// 所有接口请求的参数
    var apiParams: [String: Any]?
    
    var messageNewNumSuccessHandler: ((MessageNumModel)->())?
    var messageNewNumFailureHandler: ((_ msg: String)->())?
    
    var systemMessageSuccessHandler: ((SystemMessageListModel)->())?
    var systemMessageFailureHandler: ((_ msg: String)->())?
    
    var feedbackMessageSuccessHandler: (([FeedModel])->())?
    var feedbackMessageFailureHandler: ((_ msg: String)->())?
}

// MARK: - LoadData
extension MessageViewModel {
    
    func loadMessageNewNumData(params: [String : Any]?) {
        apiParams = params
        let _ = messageNewNumApi.loadData()
    }
    
    func loadSystemMessageData(params: [String : Any]?) {
        apiParams = params
        let _ = systemMessageNoticeApi.loadData()
    }
    
    func loadFeedBackMessageData(params: [String : Any]?) {
        apiParams = params
        let _ = feedlsApi.loadData()
    }
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension MessageViewModel: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        return apiParams
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is MessageApis {
            if let model = manager.fetchJSONData(MessageReformer()) as? MessageNumModel {
                messageNewNumSuccessHandler?(model)
            }
        }
        
        if manager is SystemMessageListApi {
            if let model = manager.fetchData(MessageReformer()) as? SystemMessageListModel {
                if let data = model.data, data.count > 0 {
                     systemMessageSuccessHandler?(model)
                }
            }
        }
        
        if manager is UserFeedLsApi {
            if let lsModel = manager.fetchJSONData(UserReformer()) as? FeedLsModel {
                if let data = lsModel.data, data.count > 0 {
                    feedbackMessageSuccessHandler?(data)
                }
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        if manager is MessageApis {
            messageNewNumFailureHandler?(manager.errorMessage)
        }
        if manager is SystemMessageListApi {
            systemMessageFailureHandler?(manager.errorMessage)
        }
        if manager is UserFeedLsApi {
            feedbackMessageFailureHandler?(manager.errorMessage)
        }
    }
}
