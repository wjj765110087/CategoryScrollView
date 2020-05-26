//
//  VideoReformer.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/12.
//  Copyright © 2018年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork

/// 数据解析器
class VideoReformer: NSObject {
    
    /// 系列分类 列表
    private func reformVideoModulesDatas(_ data: Data?) -> Any? {
        if let videoModules = try? decode(response: data, of: ObjectResponse<CateTypeListModel>.self)?.result {
            return videoModules
        }
        return nil
    }
    /// 首页带广告列表
    private func reformHomeListDatas(_ data: Data?) -> Any? {
        if let videoModules = try? decode(response: data, of: ObjectResponse<VideoHomeListModel>.self)?.result {
            return videoModules
        }
        return nil
    }
    /// 分类页面视频列表
    private func reformVideoListDatas(_ data: Data?) -> Any? {
        if let videoList = try? decode(response: data, of: ObjectResponse<VideoListModel>.self)?.result {
            return videoList
        }
        return nil
    }
    /// 视频评论列表
    private func reformVideoCommentListDatas(_ data: Data?) -> Any? {
        if let commentList = try? decode(response: data, of: ObjectResponse<VideoCommentListModel>.self)?.result {
            return commentList
        }
        return nil
    }
    
    ///视频子评论列表
    private func reformVideoCommentSonListDatas(_ data: Data?) -> Any? {
        if let commentList = try? decode(response: data, of: ObjectResponse<CommentAnswerListModel>.self)?.result {
            return commentList
        }
        return nil
    }
    
    ///视频评论点赞
    private func reformVideoCommentLikeDatas(_ data: Data?) -> Any? {
        if let commentLikeModel = try? decode(response: data, of: ObjectResponse<VideoCommentLikeModel>.self)?.result {
            return commentLikeModel
        }
        return nil
    }

    /// 搜索联想列表
    private func reformKeyMagicWordListDatas(_ data: Data?) -> Any? {
        if let magicList = try? decode(response: data, of: ObjectResponse<SearchMagicListModel>.self)?.result {
            return magicList
        }
        return nil
    }
    /// 系统公告列表
    private func reformSystemMsgListDatas(_ data: Data?) -> Any? {
        if let msgList = try? decode(response: data, of: ObjectResponse<[SystemMsgModel]>.self)?.result {
            return msgList
        }
        return nil
    }
    /// 线路列表
    private func reformChannelsListDatas(_ data: Data?) -> Any? {
        if let channelList = try? decode(response: data, of: ObjectResponse<[VideoChannelModel]>.self)?.result {
            return channelList
        }
        return nil
    }
    /// 上传选择类型
    private func reformUploadCateListDatas(_ data: Data?) -> Any? {
        if let cateList = try? decode(response: data, of: ObjectResponse<CateListModel>.self)?.result {
            return cateList
        }
        return nil
    }
    ///活动
    private func reformActivityData(_ data: Data?) -> Any? {
        if let activity = try? decode(response: data, of: ObjectResponse<ActivityItems>.self)?.result {
            return activity
        }
        return nil
    }
    ///活动视频列表
    private func reformActivityVideoListData(_ data: Data?) ->Any? {
        if let videoListModel = try? decode(response: data, of: ObjectResponse<VideoListModel>.self)?.result {
            return videoListModel
        }
        return nil
    }
}

extension VideoReformer: NicooAPIManagerDataReformProtocol {
    
    func manager(_ manager: NicooBaseAPIManager, reformData jsonData: Data?) -> Any? {
        
        if manager is VideoListApi || manager is UserFavorListApi || manager is SeriesVideoListApi || manager is UserWorkListApi || manager is DiscoverDIYApi {
            return reformVideoListDatas(jsonData)
        }
        if manager is VideoHomeListApi || manager is VideoAttentionListApi {
            return reformHomeListDatas(jsonData)
        }
        if manager is VideoSeriesListApi {
            return reformVideoModulesDatas(jsonData)
        }
        if manager is VideoCommentListApi || manager is TopicCommentListApi{
            return reformVideoCommentListDatas(jsonData)
        }
        
        if manager is VideoSonCommentListApi ||  manager is TopicSonCommentListApi {
            return reformVideoCommentSonListDatas(jsonData)
        }
        
        if manager is VideoCommentLikeApi || manager is TopicCommentLikeApi {
            return reformVideoCommentLikeDatas(jsonData)
        }
        
        if manager is SearchMagicApi {
            return reformKeyMagicWordListDatas(jsonData)
        }
        if manager is AppMessageApi {
            return reformSystemMsgListDatas(jsonData)
        }
        if manager is VideoChannelApi {
            return reformChannelsListDatas(jsonData)
        }
        if manager is VideoUploadTipsApi {
            return reformUploadCateListDatas(jsonData)
        }
        
        if manager is VideoActivityApi {
            return reformActivityData(jsonData)
        }
        
        if manager is VideoActivityListApi {
            return reformActivityVideoListData(jsonData)
        }
        
        if manager is UserBuyVideoListApi {
            return reformVideoListDatas(jsonData)
        }
        
        return nil
    }
}
