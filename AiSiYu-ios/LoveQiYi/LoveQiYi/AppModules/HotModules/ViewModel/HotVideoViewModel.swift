//
//  HotVideoViewModel.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/20.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit
import NicooNetwork

class HotVideoViewModel: NSObject {

    private lazy var hotListApi: HotListApi = {
       let api = HotListApi()
       api.paramSource = self
       api.delegate = self
       return api
    }()
    
    private lazy var routerListApi: NetworkRouterListApi = {
        let api = NetworkRouterListApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    
    private lazy var routerSaveApi: NetworkRouterSaveApi = {
        let api = NetworkRouterSaveApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    
    private lazy var videoDetailAdApi: VideoDetailAdApi = {
        let api = VideoDetailAdApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    
    private lazy var videoInfoApi: HotVideoDetailApi = {
        let api = HotVideoDetailApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    private lazy var guessLikeApi: VideoGuessLikeApi = {
        let api = VideoGuessLikeApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    private lazy var addfavorApi: UserFavorAddApi = {
        let api = UserFavorAddApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var canclefavorApi: UserFavorCancleApi = {
        let api = UserFavorCancleApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var vipAdInfoApi: VipAdInfoApi = {
        let api = VipAdInfoApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var viewTimeApi: VideoViewTimeApi = {
        let api = VideoViewTimeApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var downloadAuthApi: DownloadAuthApi = {
        let api = DownloadAuthApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    var videoListSuccessHandler: ((_ models: HotListModel, _ page: Int) -> ())?
    var videoListFailureHandler: ((String) -> ())?
    
    ///线路列表回调
    var routerListSuccessHandler: (([RouterModel]) -> ())?
    var routerListFailureHandler: ((String) -> ())?
    
    ///线路保存的回调
    var routerSaveSuccessHandler: (() -> ())?
    var routerSaveFailureHandler: ((String) -> ())?
    
    ///视频详情广告的回调
    var videoDetailAdSuccessHandler: (([VideoDetailAdModel]) -> ())?
    var videoDetailAdFailureHandler: ((String) -> ())?
    
    ///视频详情的回调
    var videoInfoSuccessHandler: ((VideoModel) -> ())?
    var videoInfoFailureHandler: ((String) -> ())?
    
    ///猜你喜欢
    var guessLikeSuccessHandler: ((VideoListModel, Int) -> ())?
    var guessLikeFailureHandler: ((String) -> ())?
    
    ///  视频收藏
    var addFavorSuccessHandler: (() -> ())?
    var addFavorFailedHandler: ((_ msg: String) -> ())?
    ///  视频取消收藏
    var cancelFavorSuccessHandler: (() -> ())?
    var cancelFavorFailedHandler: ((_ msg: String) -> ())?
    
    /// 详情广告信息配置
    var vipAdInfoSuccessHandler: (() -> ())?
    var vipAdInfoFailedHandler: ((_ msg: String) -> ())?
    /// 播放时间记录回调
    var watchTimeRecordCallBack:(() -> ())?
    /// 下载鉴权
    var downloadAuthSuccessCallBack:(()->Void)?
    var downloadAuthFailedCallBack:((_ msg: String)->Void)?
    
    var sortParams: String = HotListApi.kSort_new
    
    var watchRecordParams: [String: Any]?
    
    ///播放线路保存参数的key
    var key: String = ""
    
    ///视频播放video_id
    var video_id: Int = 0
    
    var vipAdModel: VipAdInfoModel?
    
    ///热点的列表
    func loadVideoList(_ sort: String) {
        sortParams = sort
        let _ = hotListApi.loadData()
    }
    
    func loadNextPage() {
        let _ = hotListApi.loadNextPage()
    }
    
    /// 线路列表
    func loadRouterList() {
        let _ = routerListApi.loadData()
    }
    
    /// 线路保存
    func loadRouterSave(key: String) {
        self.key = key
        let _ = routerSaveApi.loadData()
    }
    
    /// 视频详情广告的api
    func loadVideoDetailAd() {
        let _ = videoDetailAdApi.loadData()
    }
    
    /// 视频详情
    func loadVideoInfo(video_id: Int) {
        self.video_id = video_id
        let _ = videoInfoApi.loadData()
    }
    
    /// 视频收藏
    func loadVideoFavorAdd() {
        _ = addfavorApi.loadData()
    }
    /// 视频取消收藏
    func loadCancleFavor() {
        _ = canclefavorApi.loadData()
    }
    
    ///猜你喜欢
    func loadGuessList(video_id: Int) {
        self.video_id = video_id
        let _ = guessLikeApi.loadData()
    }
    
    func loadGuessNextPage() {
       let _ = guessLikeApi.loadNextPage()
    }
    
    /// 详情页广告配置
    func loadVipAdInfoData() {
        let _ = vipAdInfoApi.loadData()
    }
    /// 记录观看时间
    func loadTimeWatchedRecord(_ params: [String: Any]) {
        watchRecordParams = params
        let _ = viewTimeApi.loadData()
    }
    /// 下载鉴权
    func loadDownLoadAuth() {
        let _ = downloadAuthApi.loadData()
    }
}

extension HotVideoViewModel: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        var params = [String: Any]()
        if manager is HotListApi {
           params[HotListApi.kSort] = sortParams
            return params
        }
        if manager is NetworkRouterSaveApi {
            params [NetworkRouterSaveApi.kKey] = self.key
            return params
        }
        if manager is HotVideoDetailApi  || manager is UserFavorAddApi || manager is VideoGuessLikeApi {
            params[HotVideoDetailApi.kVideoId] = self.video_id
            return params
        }
        if  manager is UserFavorCancleApi {
            if let data = try? JSONSerialization.data(withJSONObject: [self.video_id], options: []) {
                if let json = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue) {
                    params[HotVideoDetailApi.kVideoId] = json as String
                    return params
                }
            }
        }
        if manager is DownloadAuthApi {
            params[DownloadAuthApi.kVideo_id] = self.video_id
            return params
        }
        if manager is VideoViewTimeApi {
            return watchRecordParams
        }
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is HotListApi {
            if let hotListModel = manager.fetchJSONData(HotReformer()) as? HotListModel {
                videoListSuccessHandler?(hotListModel, hotListApi.pageNumber)
            }
        }
        if manager is NetworkRouterListApi {
            if let routerList = manager.fetchJSONData(HotReformer()) as? [RouterModel] {
                routerListSuccessHandler?(routerList)
            }
        }
        if manager is NetworkRouterSaveApi {
            routerSaveSuccessHandler?()
        }
        if manager is VideoDetailAdApi {
            if let adListModel = manager.fetchJSONData(HotReformer()) as? [VideoDetailAdModel] {
                videoDetailAdSuccessHandler?(adListModel)
            }
        }
        if manager is HotVideoDetailApi {
            if let infoModel = manager.fetchJSONData(HotReformer()) as? VideoModel {
                videoInfoSuccessHandler?(infoModel)
            }
        }
        if manager is VideoGuessLikeApi {
            if let guessLikeList = manager.fetchJSONData(HotReformer()) as? VideoListModel {
                guessLikeSuccessHandler?(guessLikeList, guessLikeApi.pageNumber)
            }
        }
        if manager is UserFavorCancleApi {
            cancelFavorSuccessHandler?()
        }
        if manager is UserFavorAddApi {
            addFavorSuccessHandler?()
        }
        if manager is VipAdInfoApi {
            if let vipAdInfo = manager.fetchJSONData(HotReformer()) as? VipAdInfoModel {
                vipAdModel = vipAdInfo
                vipAdInfoSuccessHandler?()
            }
        }
        if manager is VideoViewTimeApi {
            print("时间记录成功")
            watchTimeRecordCallBack?()
        }
        
        if manager is DownloadAuthApi {
            downloadAuthSuccessCallBack?()
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        if manager is HotListApi {
            videoListFailureHandler?(manager.errorMessage)
        }
        if manager is NetworkRouterListApi {
            routerSaveFailureHandler?(manager.errorMessage)
        }
        if manager is NetworkRouterSaveApi {
            routerSaveFailureHandler?(manager.errorMessage)
        }
        if manager is VideoDetailAdApi {
            videoDetailAdFailureHandler?(manager.errorMessage)
        }
        if manager is HotVideoDetailApi {
            videoInfoFailureHandler?(manager.errorMessage)
        }
        if manager is VideoGuessLikeApi {
            guessLikeFailureHandler?(manager.errorMessage)
        }
        if manager is UserFavorCancleApi {
            cancelFavorFailedHandler?(manager.errorMessage)
        }
        if manager is UserFavorAddApi {
            addFavorFailedHandler?(manager.errorMessage)
        }
        if manager is VipAdInfoApi {
           vipAdInfoFailedHandler?(manager.errorMessage)
        }
        if manager is VideoViewTimeApi {
            watchTimeRecordCallBack?()
        }
        if manager is DownloadAuthApi {
            downloadAuthFailedCallBack?(manager.errorMessage)
        }
    }
}
