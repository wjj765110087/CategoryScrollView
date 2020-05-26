//
//  ActivityReformer.swift
//  QHAwemeDemo
//
//  Created by mac on 2019-12-21.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import Foundation
import NicooNetwork

class ActivityReformer: NSObject {
    
    ///游戏主页
    private func reformGameActivityMainDatas(_ data: Data?) -> Any? {
        if let model = try? decode(response: data, of: ObjectResponse<GameMainModel>.self)?.result {
            return model
        }
        return nil
    }
    
    /// 游戏广播
    private func reformGameNoticeListDatas(_ data: Data?) -> Any? {
        if let noticeList = try? decode(response: data, of: ObjectResponse<[GameNoticeModel]>.self)?.result {
            return noticeList
        }
        return nil
    }

    ///游戏活动兑换专区
    private func reformGameConvertListDatas(_ data: Data?) -> Any? {
        if let priseList = try? decode(response: data, of: ObjectResponse<ConvertListModel>.self)?.result {
            return priseList
        }
        return nil
    }
    
    /// 游戏任务兑换
    private func reformGameTaskListDatas(_ data: Data?) -> Any? {
        if let gameTaskList = try? decode(response: data, of: ObjectResponse<[GameTaskModel]>.self)?.result {
            return gameTaskList
        }
        return nil
    }

    ///游戏中奖结果
    private func reformGameResultDatas(_ data: Data?) -> Any? {
        if let result = try? decode(response: data, of: ObjectResponse<GameResultModel>.self)?.result {
            return result
        }
        return nil
    }
    
    /// 礼物列表
    private func reformMyGiftListDatas(_ data: Data?) -> Any? {
        if let result = try? decode(response: data, of: ObjectResponse<GiftListModel>.self)?.result {
            return result
        }
        return nil
    }
    
    /// 领取任务道具
    private func reformGetTaskDatas(_ data: Data?) -> Any? {
        if let model = try? decode(response: data, of: ObjectResponse<GetTaskSuccessModel>.self)?.result {
            return model
        }
        return nil
    }
}

// MARK: - NicooAPIManagerDataReformProtocol
extension ActivityReformer: NicooAPIManagerDataReformProtocol {
    
    func manager(_ manager: NicooBaseAPIManager, reformData jsonData: Data?) -> Any? {
        if manager is GameActivityMainApi {
            return reformGameActivityMainDatas(jsonData)
        }
        
        if manager is GameNoticesApi {
            return reformGameNoticeListDatas(jsonData)
        }
        
        if manager is GameConvertListApi || manager is ConvertGiftApi {
            return reformGameConvertListDatas(jsonData)
        }
        
        if manager is GameTaskListApi {
            return reformGameTaskListDatas(jsonData)
        }
        
        if manager is GamePlayApi {
            return reformGameResultDatas(jsonData)
        }
        
        if manager is GameGiftListApi {
            return reformMyGiftListDatas(jsonData)
        }
        
        if manager is GetTaskRewardApi {
            return reformGetTaskDatas(jsonData)
        }
        return nil
    }
}
