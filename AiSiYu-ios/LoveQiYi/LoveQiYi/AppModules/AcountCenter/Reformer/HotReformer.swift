//
//  HotReformer.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/20.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit
import NicooNetwork

class HotReformer: NSObject {
    ///视频列表
    private func reformVideoListDatas(_ data: Data?) -> Any? {
        if let taskList = try? decode(response: data, of: ObjectResponse<VideoListModel>.self)?.result {
            return taskList
        }
        return nil
    }
    
    ///视频列表
    private func reformHotListDatas(_ data: Data?) -> Any? {
        if let taskList = try? decode(response: data, of: ObjectResponse<HotListModel>.self)?.result {
            return taskList
        }
        return nil
    }
    
    ///线路列表
    private func reformRouterListDatas(_ data: Data?) -> Any? {
        if let routerList = try? decode(response: data, of: ObjectResponse<[RouterModel]>.self)?.result {
            return routerList
        }
        return nil
    }
    
    ///视频广告获取
    private func reformVideoDetailAdDatas(_ data: Data?) -> Any? {
        if let adModel = try? decode(response: data, of: ObjectResponse<[VideoDetailAdModel]>.self)?.result {
            return adModel
        }
        return nil
    }
    
    ///视频详情
    private func reformVideoInfoAdDatas(_ data: Data?) -> Any? {
        if let adModel = try? decode(response: data, of: ObjectResponse<VideoModel>.self)?.result {
            return adModel
        }
        return nil
    }
    
    ///猜你喜欢
    private func reformVideoGuessLikeListDatas(_ data: Data?) -> Any? {
        if let adModel = try? decode(response: data, of: ObjectResponse<VideoListModel>.self)?.result {
            return adModel
        }
        return nil
    }
    
    /// 视频详情广告配置
    private func reformVipAdInfoDatas(_ data: Data?) -> Any? {
        if let adModel = try? decode(response: data, of: ObjectResponse<VipAdInfoModel>.self)?.result {
            return adModel
        }
        return nil
    }
    
    
}

extension HotReformer: NicooAPIManagerDataReformProtocol {
    func manager(_ manager: NicooBaseAPIManager, reformData jsonData: Data?) -> Any? {
        if manager is VideoListApi || manager is CollectedLsApi || manager is HistoryApi {
            return reformVideoListDatas(jsonData)
        }
        
        if manager is HotListApi {
            return reformHotListDatas(jsonData)
        }
        
        if manager is NetworkRouterListApi {
            return reformRouterListDatas(jsonData)
        }
        
        if manager is VideoDetailAdApi {
            return reformVideoDetailAdDatas(jsonData)
        }
        
        if manager is HotVideoDetailApi {
            return reformVideoInfoAdDatas(jsonData)
        }
        
        if manager is VideoGuessLikeApi {
            return reformVideoGuessLikeListDatas(jsonData)
        }
        
        if manager is VipAdInfoApi {
            return reformVipAdInfoDatas(jsonData)
        }
        
        
        return nil
    }
}
