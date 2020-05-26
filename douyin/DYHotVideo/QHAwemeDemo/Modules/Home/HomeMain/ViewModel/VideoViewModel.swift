//
//  VideoViewModel.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/5.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

/// 视频ViewModel
class VideoViewModel: NSObject {
    
    private lazy var videoApi: VideoListApi =  {
        let api = VideoListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var videoHomeApi: VideoHomeListApi =  {
        let api = VideoHomeListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var videoAttApi: VideoAttentionListApi =  {
        let api = VideoAttentionListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var videoFavorApi: UserFavorAddApi =  {
        let api = UserFavorAddApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var videoSeriesListApi: SeriesVideoListApi =  {
        let api = SeriesVideoListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    private lazy var videoAuthApi: VideoAuthApi =  {
        let api = VideoAuthApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    private lazy var activityApi: VideoActivityApi = {
       let api = VideoActivityApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    private lazy var activityVideoListApi: VideoActivityListApi = {
        let api = VideoActivityListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    private lazy var commentApi: VideoCommentApi = {
        let api = VideoCommentApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    var params: [String: Any]?
    var videoListModel: VideoListModel?
    var videoList = [VideoModel]()
    /// 首页数据源
    var homeListModel: VideoHomeListModel?
    var homeModels = [HomeVideoModel]()
    /// 用于区分是否k在播放页面拉去数据
    var sourceCount: Int = 0
    /// 是否是下拉刷新操作
    var isRefreshOperation = false
    
    var noMore = false

    var isRecomment = true
    
    var requestListSuccessHandle:(() -> Void)?
    var requestMoreListSuccessHandle:(() -> Void)?
    var requestFailedHandle:((_ msg: String) -> Void)?
    
    var showNodataCallBackHandler:(() -> Void)?
    
    var videoAuthSucceedHandler:(() -> Void)?
    var videoAuthFailedHandler:((_ errorMsg: String) -> Void)?
    
    var activitySuccessHandler:((ActivityModel) -> ())?
    var activityFailedHandler:((_ errorMsg: String)->())?
    
    var activityVideoListSuccessHandler: ((VideoListModel)->())?
    var activityVideoListFailureHandelr: (()->())?
    
    var videoCommentSuccessHandler:(() -> Void)?
    var videoCommentFailedHandler:((_ errorMsg: String) -> Void)?
    
    func loadData() {
        let _ = videoApi.loadData()
    }
    
    func loadNextPage() {
        let _ = videoApi.loadNextPage()
    }
    
    /// 获取首页数据列表
    func loadHomeData(_ recomment: Bool) {
        isRecomment = recomment
        if recomment {
            let _ = videoHomeApi.loadData()
        } else {
            let _ = videoAttApi.loadData()
        }
        
    }
    
    func loadHomeDataNextPage() {
        if isRecomment {
            let _ = videoHomeApi.loadNextPage()
        } else {
            let _ = videoAttApi.loadNextPage()
        }
        
    }
    
    //系列中视频
    func loadSeriesVideoData(_ paramsSeriesVideos: [String: Any]?) {
        params = paramsSeriesVideos
        let _ = videoSeriesListApi.loadData()
    }
    
    func loadSeriesVideoNextPage() {
        let _ = videoSeriesListApi.loadNextPage()
    }
    
    /// 视频鉴权
    func loadVideoAuthData(params: [String : Any]? ,succeedHandler: @escaping () -> (),
                           failHandler: @escaping (_ failMessage: String) -> ()) {
        self.params = params
        videoAuthFailedHandler = failHandler
        videoAuthSucceedHandler = succeedHandler
        let _ = videoAuthApi.loadData()
    }
    
    ///获取活动中的视频列表
    func loadActivityVideoListData() {
        let _ = activityVideoListApi.loadData()
    }
    
    func loadActivityVideoListNextPage() {
        let _ = activityVideoListApi.loadNextPage()
    }
    
    ///活动
    func loadActivityData() {
        let _ = activityApi.loadData()
    }
    
    /// 视频评论
    func loadVideoCommentApi(_ parmasForComment: [String: Any]?) {
        params = parmasForComment
        let _ = commentApi.loadData()
    }
}

// MARK: - 暴露给Vc的方法
extension VideoViewModel {
    
    func getVideoList() -> [VideoModel] {
        return videoList
    }
    
    func getHomeList() -> [HomeVideoModel] {
        return homeModels
    }
}

// MARK: - 私有方法
private extension VideoViewModel {
    
    func requestSuccess(_ listModel: VideoListModel) {
        videoListModel = listModel
        if let list = listModel.data, let pageNumber = listModel.current_page {
            if pageNumber == 1 {
                videoList = list
                if list.count < VideoListApi.kDefaultCount {
                    noMore = true
                } else {
                    noMore = false
                }
                isRefreshOperation = true
                sourceCount = videoList.count   //只有第一页数据才在这里赋值
                requestListSuccessHandle?()
            } else {
                //DLog("已为你提前补充数据\(list.count)条 --- \(list)")
                if list.count < VideoListApi.kDefaultCount {
                    noMore = true
                } else {
                    noMore = false
                }
                videoList.append(contentsOf: list)
                requestMoreListSuccessHandle?()
            }
            
            if videoList.count == 0 {
                // 显示无数据
                showNodataCallBackHandler?()
                noMore = true
            }
        }
        
    }
    
    func requestFail(_ msg: String) {
        requestFailedHandle?(msg)
    }
    
    func requestHomeListSuccess(_ listModel: VideoHomeListModel) {
        homeListModel = listModel
        if let list = listModel.data, let pageNumber = listModel.current_page {
            if pageNumber == 1 {
                homeModels = list
                if list.count < VideoHomeListApi.kDefaultCount {
                    noMore = true
                } else {
                    noMore = false
                }
                isRefreshOperation = true
                sourceCount = homeModels.count   //只有第一页数据才在这里赋值
                requestListSuccessHandle?()
            } else {
                //DLog("已为你提前补充数据\(list.count)条 --- \(list)")
                if list.count < VideoHomeListApi.kDefaultCount {
                    noMore = true
                } else {
                    noMore = false
                }
                homeModels.append(contentsOf: list)
                requestMoreListSuccessHandle?()
            }
            
            if homeModels.count == 0 {
                // 显示无数据
                showNodataCallBackHandler?()
                noMore = true
            }
            
        }
    }
}

// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension VideoViewModel: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        if manager is VideoListApi || manager is SeriesVideoListApi ||  manager is VideoAuthApi || manager is VideoCommentApi {
             return params
        }
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is VideoListApi || manager is SeriesVideoListApi  {
            if let videoListModel = manager.fetchJSONData(VideoReformer()) as? VideoListModel {
                requestSuccess(videoListModel)
            }
        }
        if manager is VideoHomeListApi || manager is VideoAttentionListApi  {
            if let videoHomeListModel = manager.fetchJSONData(VideoReformer()) as? VideoHomeListModel {
               requestHomeListSuccess(videoHomeListModel)
            }
        }
        
        if manager is VideoActivityListApi {
            if let activityVideoListModel = manager.fetchJSONData(VideoReformer()) as? VideoListModel {
                activityVideoListSuccessHandler?(activityVideoListModel)
            }
        }
        
        if manager is VideoAuthApi {
            videoAuthSucceedHandler?()
        }
        
        if manager is VideoActivityApi {
            if let itemyModel = manager.fetchJSONData(VideoReformer()) as? ActivityItems {
                if let activityMoel = itemyModel.item1 {
                     activitySuccessHandler?(activityMoel)
                }
            }
        }
        
        if manager is VideoCommentApi {
            videoCommentSuccessHandler?()
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
       
        if manager is VideoListApi || manager is SeriesVideoListApi || manager is VideoHomeListApi || manager is VideoAttentionListApi || manager is VideoActivityListApi {
            requestFail(manager is VideoHomeListApi ? "bushiwo" : "nisdsdsdsds")
        }
        if manager is VideoAuthApi {
            videoAuthFailedHandler?(manager.errorMessage)
        }
        if manager is VideoActivityApi {
            activityFailedHandler?(manager.errorMessage)
        }
        if manager is VideoActivityListApi {
            activityVideoListFailureHandelr?()
        }
        if manager is VideoCommentApi {
            videoCommentFailedHandler?(manager.errorMessage)
        }
    }
}

