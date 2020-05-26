//
//  SpecialSeriesViewModel.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/22.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit
import NicooNetwork

class SpecialSeriesViewModel: NSObject {
 
    private lazy var specialApi: SpecialSerialApi = {
       let api = SpecialSerialApi()
       api.paramSource = self
       api.delegate = self
        
       return api
    }()
    
    private lazy var videoListApi: VideoListApi = {
       let api = VideoListApi()
       api.paramSource = self
       api.delegate = self
       
       return api
    }()
    
    ///精选系列成功失败回调
    var successHandler: ((_ model: SpecialSerialListModel, _ page: Int)->())?
    var failureHandler: ((_ errorMsg: String) ->())?
    
    ///系列详情列表成功失败回调
    var seriesDetailListSuccessHandler: ((_ model: VideoListModel, _ page: Int) ->())?
    var seriesDetailListFailureHandler: ((_ errorMsg: String) ->())?
    
    var paramDic: [String: Any]?
    
    ///精选系列的列表数组
    var seriesVideoList: [SpecialSerialModel]?
}

extension SpecialSeriesViewModel {
    
    //MARK: 精选系列的列表数据
    func loadSerialVideoListData() {
        let _ = specialApi.loadData()
    }
    
    func loadNextPage() {
        let _ = specialApi.loadNextPage()
    }
    
    //MARK:系列详情列表数据
    func loadSeriesVideoListData(_ params: [String: Any]?) {
        paramDic = params
        let _ = videoListApi.loadData()
    }
    
    func loadSeriesVideoListNextPage() {
        let _ = videoListApi.loadNextPage()
    }
}

extension SpecialSeriesViewModel:  NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        if manager is VideoListApi {
            return paramDic
        }
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is SpecialSerialApi {
            if let specialSerialList = manager.fetchJSONData(SpecialSerialReformer()) as? SpecialSerialListModel {
                self.seriesVideoList = specialSerialList.data
                successHandler?(specialSerialList, specialApi.pageNumber)
            }
        }
        
        if manager is VideoListApi {
            if let seriesDetail = manager.fetchJSONData(HotReformer()) as? VideoListModel {
                seriesDetailListSuccessHandler?(seriesDetail, videoListApi.pageNumber)
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        if manager is SpecialSerialApi {
            failureHandler?(manager.errorMessage)
        }
        
        if manager is VideoListApi {
            seriesDetailListFailureHandler?(manager.errorMessage)
        }
    }
}



