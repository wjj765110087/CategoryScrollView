//
//  MessageModels.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/8.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import Foundation

struct MessageNumModel: Codable {
    var Notice: MessageModel?
    var Comment: MessageModel?
    var Follower: MessageModel?
    var Praise: MessageModel?
    var System: MessageModel?
}

struct MessageModel: Codable {
    var num: Int?
    var max_id: Int?
    var alias: MessageType?
}

enum MessageType: String, Codable {
    
    case notice = "NOTICE-MSG"
    case comment = "COMMENT-MSG"
    case follower = "FOLLOWER-MSG"
    case praise = "PRAISE-MSG"
    case system = "SYSTEM-MSG"
}

///通知消息列表
struct NoticeMessageListModel: Codable {
    var current_page: Int?
    var data: [NoticeMessageModel]?
    var total: Int?
}

struct NoticeMessageModel: Codable {
    var id: Int?
    var type: MessageUpdateType?
    var user_id: Int?
    var topic_id: Int?
    var dynamic_id: Int?
    var created_at: String?
    var time: String?
    var dynamic_type: DynamicType?
    var user: UserInfoModel?
    var topic: TopicMessageModel?
    var alter: AlterModel?
}

struct TopicMessageModel: Codable {
    var id: Int?
    var cover_url: String?
    var title: String?
}

struct AlterModel: Codable {
    var id: Int?
    var video_model: VideoModel?
    var title: String?
    var dy_id: Int?
    var type: String?
    var dy_cid: Int?
    var comment: String?
    var video_id: Int?
    var vc_id: Int?
    var status: CheckStatus?
    var remark: String?
}

///关注类型(关注，话题)
enum MessageUpdateType: String, Codable {
    case follow = "FELLOW-PUSH"
    case topic = "TOPIC-UPDATE"
}

///图文, 视频
enum DynamicType: String, Codable  {
    case imageText = "IMG_TEXT"
    case video = "VIDEO"
}

///点赞消息列表
struct PraiseMessageListModel: Codable {
    var current_page: Int?
    var data: [PraiseModel]?
    var alter: AlterModel?
}

struct PraiseModel: Codable {
    var id: Int?
    var type: String?
    var from_uid: Int?
    var to_uid: Int?
    var created_at: String?
    var user: UserInfoModel?
    var _fkid: Int?
    var time: String?
    var alter: AlterModel?
}

///评论消息列表
struct CommentMessageListModel: Codable {
    var current_page: Int?
    var data: [CommentMessageModel]?
    var total: Int?
}

struct CommentMessageModel: Codable  {
    var id: Int?
    var type: String?
    var from_uid: Int?
    var to_uid: Int?
    var created_at: String?
    var user: UserInfoModel?
    var alter: AlterModel?
}


///粉丝消息列表
struct FansMessageListModel: Codable {
    var current_page: Int?
    var data: [FansMessageModel]?
    var total: Int?
}

struct FansMessageModel: Codable {
    var id: Int?
    var from_uid: Int?
    var to_uid: Int?
    var created_at: String?
    var user: UserInfoModel?
    var _realation: FollowOrCancelModel?
}


///系统消息列表
struct SystemMessageListModel: Codable {
    var current_page: Int?
    var data: [SystemMessageModel]?
    var total: Int?
}

struct SystemMessageModel: Codable {
    var id: Int?
    var uid: Int?
    var type: DyDynamicType?
    var created_at: String?
    var alter: AlterModel?
}

enum DyDynamicType: String, Codable  {
    case imageText = "DY-IMG-TEXT-AUDI"
    case video = "DY-VIDEO-AUDI"
}

enum CheckStatus: Int, Codable {
    case checkSuccess = 1
    case checkFailure = 0
}

///评论
enum CommentDynamicType: String, Codable {
    case DY_COMMENT = "DY-COMMENT"
    case VIDEO = "VIDEO"
    case VIDEO_COMMENT = "VIDEO-COMMENT"
    case VIDEO_COMMENT_REPLY = "VIDEO-COMMENT-REPLY"
    case DY_COMMENT_REPLY = "DY-COMMENT-REPLY"
}


