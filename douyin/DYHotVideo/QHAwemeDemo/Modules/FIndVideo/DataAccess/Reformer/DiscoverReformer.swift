//
//  DiscoverReformer.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/7.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import Foundation
import NicooNetwork

class DiscoverReformer: NSObject {
    
    // MARK: - 发现首页title列表
    private func reformFindTitleListDatas(_ data: Data?) -> Any? {
        if let titleList = try? decode(response: data, of: ObjectResponse<FindVideoTitleListModel>.self)?.result {
            return titleList
        }
        return nil
    }
    
    //MARK: - 发现首页内容广告
    private func reformFindAdContentDatas(_ data: Data?) -> Any? {
        if let banners = try? decode(response: data, of: ObjectResponse<FindAdContentListModel>.self)?.result {
            return banners
        }
        return nil
    }
    
    //MARK: - 发现首页视频列表
    private func reformFindVideoListDatas(_ data: Data?) -> Any? {
        if let videoList = try? decode(response: data, of: ObjectResponse<FindVideoListModel>.self)?.result {
            return videoList
        }
        return nil
    }
    
    //MARK: -发现首页排行榜
    private func reformFindRankListDatas(_ data: Data?) -> Any? {
        if let videoRank = try? decode(response: data, of: ObjectResponse<[FindRankModel]>.self)?.result {
            return videoRank
        }
        return nil
    }
    
    //MARK: -发现排行榜详情
    private func reformFindRankDetailDatas(_ data: Data?) -> Any? {
        if let rankDetail = try? decode(response: data, of: ObjectResponse<FindRankDetailListModel>.self)?.result {
            return rankDetail
        }
        return nil
    }
    
    //MARK: -发现排行榜顶部广告
    private func reformFindRankAdDatas(_ data: Data?) -> Any? {
        if let banners = try? decode(response: data, of: ObjectResponse<[FindAdContentModel]>.self)?.result {
            return banners
        }
        return nil
    }
}

// MARK: - NicooAPIManagerDataReformProtocol
extension DiscoverReformer: NicooAPIManagerDataReformProtocol {
    func manager(_ manager: NicooBaseAPIManager, reformData jsonData: Data?) -> Any? {
        
        if manager is DiscoveryTitleListApi {
           return reformFindTitleListDatas(jsonData)
        }
        
        if manager is DiscoverAdContentApi {
            return reformFindAdContentDatas(jsonData)
        }
       
        if manager is DiscoveryVideoListApi {
            return reformFindVideoListDatas(jsonData)
        }
        
        if manager is DiscoverRankListApi {
            return reformFindRankListDatas(jsonData)
        }
        
        if manager is DiscoverRankDetailApi || manager is ActivityRankListApi {
            return reformFindRankDetailDatas(jsonData)
        }
        
        if manager is DiscoverRankAdApi {
            return reformFindRankAdDatas(jsonData)
        }
        
        return nil
    }
}
