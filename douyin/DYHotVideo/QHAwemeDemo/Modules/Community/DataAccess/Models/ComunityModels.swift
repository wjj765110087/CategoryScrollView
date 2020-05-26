//
//  File.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation

// MARK: - 话题列表
class TalksListModel: NSObject, Codable {
    var current_page: Int?
    var data: [TalksModel]?
    var total: Int?
}
class TalksModel: NSObject, Codable {
    var id: Int?
    var title: String?
    var cover_url: String?
    var intro: String?
    var view_count: Int?  //访问次数
    var created_at: String?
    var has_count: TalksFollow?
    var is_choice: Int?
    var total_count: Int?
}

enum TalksFollow: Int, Codable {
    case noFollow = 0
    case follow = 1
}

// MARK: - 动态列表


/// 用于区分动态列表类型
///
/// - acountCnter: 自己的动态
/// - userCenter: 用户中心的动态
/// - attention: 关注的动态
/// - recomment: 精选推荐动态
/// - topicCenter: 话题中心的动态
enum TopicListPart {
    case acountCnter
    case userCenter
    case attention
    case recomment
    case topicCenter
}

class TopicListModel: NSObject, Codable {
    var current_page: Int?
    var data: [TopicModel]?
    var total: Int?
}

class TopicModel: NSObject, Codable {
    var id: Int?
    var topic_id: Int?                  // 话题Id
    var user_id: Int?                   // UserId
    var resource: [String]?             // 图片内容
    var video_id: Int?
    
    var comment_count: Int?
    var like: Int?
    
    var is_like: TopicIsLike?            // 是否👍
    
    var type: TopicType?                 // 分类 - 0 图文 ； 1 视频
    var time: String?                    // 发布时间
    var is_attention: TopicRecommend?    // 是否关注
    var topic: TalksModel?               // 话题
    var comments: [VideoCommentModel]?    // 评论列表
    var user: UserInfoModel?
    var video:[VideoModel]?
    
    var content: String?      // 动态文字内容
    var is_top: Int?
    var is_recommend: Int?    // 是否精选
    var check: Int?          // 用户动态审核状态 ： 1: 已审核通过  -1: 审核不通过  0: 等待审核中
    
    var created_at: String?
    
    var cover_path: String?  //
    var top: Int?            // 排行
    var count: Int?
}

class VideoTopicModel: NSObject, Codable {
    var id: Int?
    var topic_id: Int?                  // 话题Id
    var user_id: Int?                   // UserId
    var video_id: Int?
    var comment_count: Int?
    var like: Int?
    var type: TopicType?                 // 分类 - 0 图文 ； 1 视频
    var time: String?                    // 发布时间
    var is_attention: TopicRecommend?    // 是否关注
    var topic: TalksModel?               // 话题
    var comments: [VideoCommentModel]?    // 评论列表
 
    var content: String?      // 动态文字内容
    var is_top: Int?
    var check: Int?          // 用户动态审核状态 ： 1: 已审核通过  -1: 审核不通过  0: 等待审核中
    
    var created_at: String?
}


enum TopicType: Int, Codable {
    case imgText = 0   // 图文
    case video = 1     // 视屏
}

enum TopicIsLike: Int, Codable {
    case unlike = 0   // 不喜欢
    case like = 1     // 喜欢
}

enum TopicRecommend: Int, Codable {
    case noRecommend = 0
    case recommend = 1
}




class TopicRankLsModel: NSObject, Codable {
    var current_page: Int?
    var data: [TopicRankModel]?
    var total: Int?
}

class TopicRankModel: NSObject, Codable {
    var id: Int?
    var user_id: Int?                   // UserId
    var video_id: Int?
    
    var type: DynamicType?                 // 分类 - 0 图文 ； 1 视频
    var time: String?                    // 发布时间
    var is_attention: TopicRecommend?    // 是否关注
    var topic: TalksModel?               // 话题
    var comments: [VideoCommentModel]?    // 评论列表
    var user: UserInfoModel?
    var video_model: VideoModel?

    var coins: Int?
    var gain_conis_count: StrInt?
    
    var content: String?      // 动态文字内容
    var is_top: Int?
    var check: Int?          // 用户动态审核状态 ： 1: 已审核通过  -1: 审核不通过  0: 等待审核中
    
    var created_at: String?
    
    var cover_path: String?  //
    var top: Int?            // 排行
    var count: Int?
}
