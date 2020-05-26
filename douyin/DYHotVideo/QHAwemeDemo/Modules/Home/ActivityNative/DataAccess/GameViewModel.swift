//
//  GameViewModel.swift
//  QHAwemeDemo
//
//  Created by mac on 2019-12-23.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

class GameViewModel: NSObject {
    private lazy var gameMainApi: GameActivityMainApi =  {
        let api = GameActivityMainApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var gameNoticeApi: GameNoticesApi =  {
        let api = GameNoticesApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var convertListApi: GameConvertListApi =  {
        let api = GameConvertListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var playGameApi: GamePlayApi =  {
        let api = GamePlayApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var convertGiftApi: ConvertGiftApi =  {
        let api = ConvertGiftApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var giftListApi: GameGiftListApi =  {
        let api = GameGiftListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    private lazy var getTaskApi: GetTaskRewardApi = {
        let api = GetTaskRewardApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()

    var noticetTimer: Timer?
    var params: [String: Any]?
    var paramsNoticce: [String: Any]?
    
    var gameMainApiSuccessHandler:((_ model: GameMainModel) -> Void)?
    var gameMainApiFailedHandler:((_ filedMsg: String) -> Void)?
    
    var gameResultSuccessHandler:((_ model: GameResultModel) -> Void)?
    var gameResultFailHandler:((_ msg: String) -> Void)?
    
    var gameNoticeSuccessHandler:((_ notices: [String]) -> Void)?
    var gameNoticeFailHandler:((_ msg: String) -> Void)?
    
    var convertListSuccessHandler:((_ model: ConvertListModel) -> Void)?
    var convertListFailHandler:((_ msg: String) -> Void)?
    
    var convertSuccessHandler:((_ model: ConvertListModel) -> Void)?
    var convertFailHandler:((_ msg: String) -> Void)?
    

    var getTaskRewardSuccessHandler: ((_ model: GetTaskSuccessModel) -> Void)?
    var getTaskRewardFailHandler:((_ msg: String) -> Void)?

    var myGiftListSuccessHandler:((_ models: [MyGiftModle], _ pageNumber: Int) -> Void)?
    var myGiftListFailHandler:((_ msg: String, _ pageNumber: Int) -> Void)?

    /// 游戏主页UI数据
    func loadGameMainData(_ param: [String : Any],
                          succeedHandler: @escaping (_ model: GameMainModel) -> (),
                          failHandler: @escaping (_ failMessage: String) -> ())  {
        params = param
        gameMainApiSuccessHandler = succeedHandler
        gameMainApiFailedHandler = failHandler
        _ = gameMainApi.loadData()
    }
    
    /// 获取中奖结果
    func loadGameResultData(_ param: [String : Any],
                            succeedHandler: @escaping (_ model: GameResultModel) -> (),
                            failHandler: @escaping (_ failMessage: String) -> ()) {
        params = param
        gameResultSuccessHandler = succeedHandler
        gameResultFailHandler = failHandler
        _ = playGameApi.loadData()
        
    }
    
    /// 获取中奖广播
    func loadGameNoticeData(_ param: [String : Any],
                            succeedHandler: @escaping (_ notice: [String]) -> (),
                            failHandler: @escaping (_ failMessage: String) -> ()) {
        paramsNoticce = param
        gameNoticeSuccessHandler = succeedHandler
        gameNoticeFailHandler = failHandler
        _ = gameNoticeApi.loadData()
        noticetTimer = Timer.every(10.second) {
            _ = self.gameNoticeApi.loadData()
        }
    }
    
    /// 获取兑奖列表
    func loadConvertListData(_ param: [String : Any],
                            succeedHandler: @escaping (_ model: ConvertListModel) -> (),
                            failHandler: @escaping (_ failMessage: String) -> ()) {
        params = param
        convertListSuccessHandler = succeedHandler
        convertListFailHandler = failHandler
        _ = convertListApi.loadData()
    }

    /// 兑奖奖品操作
    func convertGiftData(_ param: [String : Any],
                            succeedHandler: @escaping (_ model: ConvertListModel) -> (),
                            failHandler: @escaping (_ failMessage: String) -> ()) {
        params = param
        convertSuccessHandler = succeedHandler
        convertFailHandler = failHandler
        _ = convertGiftApi.loadData()
    }
    

    //领取任务道具
    func getTaskRewardData(_ param: [String : Any], successHandler: @escaping ((_ model: GetTaskSuccessModel) -> Void), failureHandler: @escaping ((_ failMessage: String) -> ())) {
        params = param
        getTaskRewardSuccessHandler = successHandler
        getTaskRewardFailHandler = failureHandler
        _ = getTaskApi.loadData()
    }

    /// 我的礼物列表
    func loadMgGiftListData() {
        _ = giftListApi.loadData()
    }
    
    func loadMyGiftListNextPage() {
        _ = giftListApi.loadNextPage()
    }
}

// MARK: - Privite - Funcs
private extension GameViewModel {
    func loadNoticeSuccess(_ notices: [GameNoticeModel]) {
        var noticeString = [String]()
        for model in notices {
            if let str = model.remark_user, !str.isEmpty {
                noticeString.append(str)
            }
        }
        gameNoticeSuccessHandler?(noticeString)
    }
}

// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension GameViewModel: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        if manager is GameNoticesApi {
            return paramsNoticce
        }
        return params
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is GameActivityMainApi {
            if let gameModel = manager.fetchJSONData(ActivityReformer()) as? GameMainModel {
                gameMainApiSuccessHandler?(gameModel)
            }
        }
        if manager is GamePlayApi {
            if let gameResult = manager.fetchJSONData(ActivityReformer()) as? GameResultModel {
                gameResultSuccessHandler?(gameResult)
            }
        }
        if manager is GameNoticesApi {
            if let gameNotices = manager.fetchJSONData(ActivityReformer()) as? [GameNoticeModel] {
                loadNoticeSuccess(gameNotices)
            }
        }
        if manager is GameConvertListApi {
            if let convertList = manager.fetchJSONData(ActivityReformer()) as? ConvertListModel {
                convertListSuccessHandler?(convertList)
            }
        }
        if manager is ConvertGiftApi {
            if let convertList = manager.fetchJSONData(ActivityReformer()) as? ConvertListModel {
                convertSuccessHandler?(convertList)
            }
        }

        if manager is GetTaskRewardApi {
            if let model = manager.fetchJSONData(ActivityReformer()) as? GetTaskSuccessModel {
                getTaskRewardSuccessHandler?(model)
            }
        }
        if manager is GameGiftListApi {
            if let giftListModel = manager.fetchJSONData(ActivityReformer()) as? GiftListModel {
                if let lists = giftListModel.data {
                    myGiftListSuccessHandler?(lists, (manager as! GameGiftListApi).pageNumber)
                }
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        
        if manager is GameActivityMainApi {
            gameMainApiFailedHandler?(manager.errorMessage)
        }
        if manager is GamePlayApi {
            gameResultFailHandler?(manager.errorMessage)
        }
        if manager is GameNoticesApi {
            gameNoticeFailHandler?(manager.errorMessage)
        }
        if manager is GameConvertListApi {
            convertListFailHandler?(manager.errorMessage)
        }
        if manager is ConvertGiftApi {
            convertFailHandler?(manager.errorMessage)
        }

        if manager is GetTaskRewardApi {
            getTaskRewardFailHandler?(manager.errorMessage)
        }
        
        if manager is GameGiftListApi {
            myGiftListFailHandler?(manager.errorMessage, (manager as! GameGiftListApi).pageNumber)
        }
    }
}

