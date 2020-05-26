//
//  CommentViewModel.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/4.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

class CommentViewModel: NSObject {
    
    ///视频评论列表
    private lazy var videoCommentListApi: VideoCommentListApi = {
        let api = VideoCommentListApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    ///用户评论
    private lazy var commentApi: VideoCommentApi = {
        let api = VideoCommentApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    ///视频子评论列表
    private lazy var videoCommentSonListApi: VideoSonCommentListApi = {
        let api = VideoSonCommentListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    /// 视频评论点赞
    private lazy var videoCommentLikeApi: VideoCommentLikeApi = {
        let api = VideoCommentLikeApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    ///动态评论列表
    private lazy var topicCommentListApi: TopicCommentListApi = {
        let api = TopicCommentListApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    ///动态 - 用户评论
    private lazy var topicCommentApi: TopicCommentApi = {
        let api = TopicCommentApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    ///视频子评论列表
    private lazy var topicCommentSonListApi: TopicSonCommentListApi = {
        let api = TopicSonCommentListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    /// 视频评论点赞
    private lazy var topicCommentLikeApi: TopicCommentLikeApi = {
        let api = TopicCommentLikeApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    var params: [String : Any] = [String : Any]()
    
    ///评论列表成功回调
    var videoCommentListSuccessHandler: ((VideoCommentListModel)->())?
    var videoCommentListFailureHandelr: ((String)->())?
    
    ///用户评论
    var videoCommentSuccessHandler: (() ->())?
    var videoCommentFailureHandelr: ((String)->())?
    
    ///用户子评论列表成功回调
    var videoCommentSonListSuccessHandler: ((CommentAnswerListModel)->())?
    var videoCommentSonListFailureHandelr: ((String)->())?
    
    /// 视频评论点赞
    var videoCommentLikeSuccessHandler: (()->())?
    var videoCommentLikeFailureHandelr: ((String)->())?
}

// MARK: - 视频评论Api
extension CommentViewModel {
    /// 视频评论列表
    func loadVideoCommentListApi(params: [String : Any]) {
        self.params = params
        let _ = videoCommentListApi.loadData()
    }
    func loadVideoCommentListNextPage(params: [String : Any]) {
        self.params = params
        let _ = videoCommentListApi.loadNextPage()
    }
    ///用户评论
    func loadVideoCommentApi(params: [String : Any]) {
        self.params = params
        let _ = commentApi.loadData()
    }
    ///视频子评论列表
    func loadVideoSonCommentListApi(params: [String : Any]) {
        self.params = params
        let _ = videoCommentSonListApi.loadData()
    }
    func loadVideoSonCommentListNextPage(params: [String : Any]) {
        self.params = params
        let _ = videoCommentSonListApi.loadNextPage()
    }
    
    /// 视频评论点赞
    func loadVideoCommentLikeData(params: [String : Any]) {
        self.params = params
        let _ = videoCommentLikeApi.loadData()
    }
}

// MARK: - 动态评论Api
extension CommentViewModel {
    /// 动态评论列表
    func loadTopicCommentListApi(params: [String : Any]) {
        self.params = params
        let _ = topicCommentListApi.loadData()
    }
    func loadTopicCommentListNextPage(params: [String : Any]) {
        self.params = params
        let _ = topicCommentListApi.loadNextPage()
    }
    ///用户动态评论
    func loadTopicCommentApi(params: [String : Any]) {
        self.params = params
        let _ = topicCommentApi.loadData()
    }
    ///动态评论 子评论列表
    func loadTopicSonCommentListApi(params: [String : Any]) {
        self.params = params
        let _ = topicCommentSonListApi.loadData()
    }
    func loadTopicSonCommentListNextPage(params: [String : Any]) {
        self.params = params
        let _ = topicCommentSonListApi.loadNextPage()
    }
    /// 动态评论点赞
    func loadTopicCommentLikeData(params: [String : Any]) {
        self.params = params
        let _ = topicCommentLikeApi.loadData()
    }
}


// MARK: -NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension CommentViewModel: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        return params
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is VideoCommentListApi || manager is TopicCommentListApi {
            if let videoCommentList = manager.fetchJSONData(VideoReformer()) as? VideoCommentListModel {
                videoCommentListSuccessHandler?(videoCommentList)
            }
        }
        if  manager is VideoCommentApi || manager is TopicCommentApi {
            videoCommentSuccessHandler?()
        }
        
        if manager is VideoSonCommentListApi || manager is TopicSonCommentListApi {
            if let answerList = manager.fetchJSONData(VideoReformer()) as? CommentAnswerListModel {
                videoCommentSonListSuccessHandler?(answerList)
            }
        }
        
        if  manager is VideoCommentLikeApi || manager is TopicCommentLikeApi {
            videoCommentLikeSuccessHandler?()
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        if manager is VideoCommentListApi || manager is TopicCommentListApi {
            videoCommentListFailureHandelr?(manager.errorMessage)
        }
        
        if manager is VideoCommentApi || manager is TopicCommentApi {
            videoCommentFailureHandelr?(manager.errorMessage)
        }
        
        if manager is VideoSonCommentListApi || manager is TopicSonCommentListApi {
            videoCommentSonListFailureHandelr?(manager.errorMessage)
        }
        
        if manager is VideoCommentLikeApi || manager is TopicCommentLikeApi {
            videoCommentLikeFailureHandelr?(manager.errorMessage)
        }
    }
}

