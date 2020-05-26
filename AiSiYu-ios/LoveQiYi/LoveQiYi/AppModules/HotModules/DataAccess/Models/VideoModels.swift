//
//  VideoModels.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/20.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import Foundation

struct VideoListModel: Codable {
    
    ///当前页
    var current_page: Int?

    var data: [VideoModel]?
    
    ///视频个数
    var total: Int?

}

/// 视频model
struct VideoModel: Codable {
    
    var id : Int?
    
    var title: String?
    
    var cover_url: String?
    
    var play_count: Int?
    
    var duration: Int?
    
    var is_vip: VipVideo?
    ///上传时间
    var online_time: String?
    
    var deleted_at: String?
    var play_url_m3u8: String?
    
    var is_collect: IsCollected?
    
    var view_time: Int?                // 上次观看到时间
    var auth_error: Auth_error?        //
    
    var is_long: IsPortrait?           // 视频是不是竖屏
    
}

enum VipVideo:Int, Codable {
    case vip = 1
    case normal = 0
    
    var boolValue: Bool {
        switch self {
        case .vip:
            return true
        case .normal:
            return false
        }
    }
}
enum IsCollected: Int, Codable {
    case collected = 1
    case unCollected = 0
    
    var boolValue: Bool {
        switch self {
        case .collected:
            return true
        case .unCollected:
            return false
        }
    }
}

enum IsPortrait: Int, Codable {
    case landscape = 0
    case portrait = 1
    
    var boolValue: Bool {
        switch self {
        case .portrait:
            return true
        case .landscape:
            return false
        }
    }
}

struct Auth_error: Codable {
    var key: Int?           // 1 : 无权限观看。 2: 可观看10秒
    var info: String?
}

///热点首页模型
struct HotListModel: Codable {
    var current_Page: Int?
    var data: [VideoAdListModel]?
}

///视频加广告列表model
struct VideoAdListModel: Codable {
    var type: VideoAdFlagType?
    var ad: AdModel?
    var video: VideoModel?
}

///广告模型
struct AdModel: Codable {
    var id: Int?
    var key: String?
    var type: BannerType?
    var title: String?
    var remark: String?
    var cover_oss_path: String?
    var redirect_url: String?
    var sort: Int?
    var video_id: Int?
    var status: Int?
    var created_at: String?
    var updated_at: String?
    var deleted_at: String?
}


enum VideoAdFlagType: String, Codable {
    case video = "V"
    case ad = "A"

    var stringValue: String {
        switch self {
        case .video:
            return "V"
        case .ad:
            return "A"
        }
    }
}

///线路模型
struct RouterModel: Codable {
    var id: Int?
    var title: String?
    var key: String?
    var domain: String?
    var status: Int?
    var sort: Int?
    var remark: String?
    var type: Int?
    var created_at: String?
    var updated_at: String?
}

///视频详情页广告
struct VideoDetailAdModel: Codable {
    var id: Int?
    var key: String?
    var type: BannerType?
    var title: String?
    var remark: String?
    var cover_oss_path: String?
    var redirect_url: String?
    var redirect_position: RedirectURLPosition?
    var sort: Int?
    var video_id: Int?
    var status: Int?
    var created_at: String?
    var updated_at: String?
    var deleted_at: String?
}

///猜你喜欢List
struct VideoGuessLikeListModel: Codable {
    var currentPage: Int?
    var data: [VideoGuessLikeModel]?
}

///视频详情列表（猜你喜欢）
struct VideoGuessLikeModel: Codable {
   var id: Int?
   var title: String?
   var cover_url: String?
   var play_count: Int?
   var duration: Int?
   var is_vip: VipVideo?
   var online_time: String?
}

/// 视频详情页广告信息
struct VipAdInfoModel: Codable {
    var title: String?
    var url: String?
}
