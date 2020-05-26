//
//  CommunityReformer.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

/// 社区数据解析
class CommunityReformer: NSObject {
    // MARK: - 话题列表
    private func reformTalksListDatas(_ data: Data?) -> Any? {
        if let loginInfo = try? decode(response: data, of: ObjectResponse<TalksListModel>.self)?.result {
            return loginInfo
        }
        return nil
    }
    // MARK: - 话题关注列表
    private func reformTalksFollowListDatas(_ data: Data?) -> Any? {
        if let loginInfo = try? decode(response: data, of: ObjectResponse<TalksListModel>.self)?.result {
            return loginInfo
        }
        return nil
    }
    // MARK: - 用户动态列表
    private func reformUserTopicListDatas(_ data: Data?) -> Any? {
        if let loginInfo = try? decode(response: data, of: ObjectResponse<TopicListModel>.self)?.result {
            return loginInfo
        }
        return nil
    }
    // MARK: - 动态详情列表
    private func reformTopicDetailDatas(_ data: Data?) -> Any? {
        if let model = try? decode(response: data, of: ObjectResponse<TopicModel>.self)?.result {
            return model
        }
        return nil
    }
    // MARK: - 活动动态排行列表
    private func reformTopicRankListDatas(_ data: Data?) -> Any? {
        if let loginInfo = try? decode(response: data, of: ObjectResponse<TopicRankLsModel>.self)?.result {
            return loginInfo
        }
        return nil
    }
    
}

// MARK: - NicooAPIManagerDataReformProtocol
extension CommunityReformer: NicooAPIManagerDataReformProtocol {
    
    func manager(_ manager: NicooBaseAPIManager, reformData jsonData: Data?) -> Any? {
        if manager is TalksListApi || manager is TalksSearchListApi {
            return reformTalksListDatas(jsonData)
        }
        if manager is TalksCollectListApi {
            return reformTalksFollowListDatas(jsonData)
        }
        if manager is UserTopicListApi || manager is TopicSearchListApi {
            return reformUserTopicListDatas(jsonData)
        }
        if manager is TopicDetailApi {
            return reformTopicDetailDatas(jsonData)
        }
        if  manager is ActivityRankListApi  {
            return reformTopicRankListDatas(jsonData)
        }
        
        return nil
    }
}


