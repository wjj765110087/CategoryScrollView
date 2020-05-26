//
//  SearchRefromer.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/10.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation
import NicooNetwork

class SearchReformer: NSObject {
    //MARK: - 搜索推荐关键字
    private func searchKeyRecommendListDatas(_ data: Data?) -> Any? {
        if let keyList = try? decode(response: data, of: ObjectResponse<[SearchLikeKey]>.self)?.result {
            return keyList
        }
        return nil
    }
    
    //MARK: - 搜索视频
    private func searchVideoListDatas(_ data: Data?) -> Any? {
        if let videoList = try? decode(response: data, of: ObjectResponse<VideoListModel>.self)?.result {
            return videoList
        }
        return nil
    }
    
    ///MARK: -搜索用户
    private func searchUserListDatas(_ data: Data?) -> Any? {
        if let userList = try? decode(response: data, of: ObjectResponse<SearchUserListModel>.self)?.result {
            return userList
        }
        return nil
    }
    
    //MARK: -推荐用户
    private func recommandUserListDatas(_ data: Data?) -> Any? {
        if let userList = try? decode(response: data, of: ObjectResponse<SearchUserListModel>.self)?.result {
            return userList
        }
        return nil
    }
    
    //MARK: -推荐话题
    private func recommandTopicListDatas(_ data: Data?) -> Any? {
        if let topicList = try? decode(response: data, of: ObjectResponse<TalksListModel>.self)?.result {
            return topicList
        }
        return nil
    }
    
    // MARK: - 推荐动态
    private func recommandTrendListDatas(_ data: Data?) -> Any? {
        if let loginInfo = try? decode(response: data, of: ObjectResponse<TopicListModel>.self)?.result {
            return loginInfo
        }
        return nil
    }
}
// MARK: - NicooAPIManagerDataReformProtocol
extension SearchReformer: NicooAPIManagerDataReformProtocol {
    func manager(_ manager: NicooBaseAPIManager, reformData jsonData: Data?) -> Any? {
        if manager is SearchKeyRecommendApi {
            return searchKeyRecommendListDatas(jsonData)
        }
        if manager is SearchVideoApi {
            return searchVideoListDatas(jsonData)
        }
        if manager is SearchUserApi {
            return searchUserListDatas(jsonData)
        }
        if manager is RecommandUserApi {
            return recommandUserListDatas(jsonData)
        }
        if manager is RecommandTopicApi {
            return recommandTopicListDatas(jsonData)
        }
        if manager is RecommandTrendApi {
            return recommandTrendListDatas(jsonData)
        }
        return nil
    }
}
