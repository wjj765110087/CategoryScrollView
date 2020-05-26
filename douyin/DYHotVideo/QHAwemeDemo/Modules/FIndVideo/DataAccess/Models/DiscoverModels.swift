//
//  DiscoverModels.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/7.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import Foundation

///发现视频列表模型
struct FindVideoListModel: Codable {
    var current_page: Int?
    var data: [FindVideoModel]?
    var total: Int?
}

struct FindVideoModel: Codable {
    var id: Int?
    var key_id: Int?
    var keys_title: String?
    var keys_cover: String?
    var updated_at: String?
}


///发现顶部分类List模型
struct FindVideoTitleListModel: Codable {
    var current_page: Int?
    var data: [FindVideoTitleModel]?
    var total: Int?
}

struct FindVideoTitleModel: Codable {
    var id: Int?
    var key_id: Int?
    var keys_title: String?
    var keys_cover: String?
    var updated_at: String?
}

///发现首页的广告banners
struct FindAdContentListModel: Codable {
    var current_page: Int?
    var data: [FindAdContentModel]?
    var total: Int?
}

///发现首页推荐的广告
struct FindAdContentModel: Codable {
    var key: String?
    var type: BannerType?
    var title: String?
    var video_id: Int?
    var cover_oss_path: String?
    var redirect_url: String?
    var redirect_position: RedirectURLPosition?
    var key_id: Int?
    var topic_detail_model: TalksModel?
}

enum BannerType: String, Codable {
    case banner_link = "LINK"
    case banner_video = "VIDEO"
    case banner_ad = "VIDEO-AD"
    case banner_internalLink = "INTERNAL-LINK"
}

///跳转到内页的枚举
enum RedirectURLPosition: String, Codable {
    case TOPIC_DETAIL = "TOPIC_DETAIL"
    case MEMBER_RECHARGE_DETAIL = "MEMBER_RECHARGE_DETAIL"
    case VIDEO_CAT_DETAIL = "VIDEO_CAT_DETAIL"
    case DY_WALLET = "DY_WALLET"
    case ACT_DETAIL = "ACT_DETAIL"
    case GAME_TIGER = "GAME_TIGER"   /// 游戏
    case DEFAULTSTRING = ""
}

///排行榜详情列表
struct FindRankDetailListModel: Codable {
    var current_page: Int?
    var data: [FindRankModel]?
    var total: Int?
    var update: String?
}

///发现首页排行榜列表
struct FindRankModel: Codable {
    var id: Int?
    var title: String?
    var title_att: String?
    var cover_path: String?
    var cover_oss_filename: String?
    var user_id: Int?
    var video_model: VideoModel?
    var top: Int?
    var play_count: Int?   ///本周/本月/上个月播放次数
    var type: RankType?
    var title_background_img: String?
    var count: Int?
}

enum RankType: String, Codable {
    case week = "week"
    case month = "month"
    case lastMonth = "last_month"
}
