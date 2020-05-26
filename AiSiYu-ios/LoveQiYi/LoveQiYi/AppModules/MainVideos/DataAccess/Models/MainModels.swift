//
//  MainModels.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/22.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import Foundation

/// 首页大分类
struct MainTypeModel: Codable {
    var id: Int?
    var title: String?
    var sort: Int?
    var created_at: String?
}


// 首页动态模块。-》〉》〉》〉》〉》〉》〉》〉》〉》〉》〉》〉》〉》〉》〉》〉》〉》〉》

enum ModuleKey: String, Codable {
    case m_video = "m_video"
    case m_banner = "m_banner"
    case m_ad = "m_ad"
}

enum ModuleType: String, Codable {
    case video_Normal = "video_1"   // 2排列
    case video_Top = "video_2"   // 1 + n 排列
    case video_Table = "video_3"  //1排列
    case other = ""
    case other1 = " "
}

struct ModuleModel: Codable {
    
    var id: Int?
    var title: String?
    var module: String?
    var options: String?
    
    var client_module: ModuleKey?  // 模块对应的 数据
    
    var client_style: ModuleType?   // 模块对应的 样式
    
    /// 限制个数（缓一缓）
    var client_limit: Int?
    
    var m_banner_data: [BannerModel]?
    var m_video_data: [VideoModel]?
    var m_ad_data: [AdModel]?
    
    /// 当前页
    var currentPage: Int? = 1
}

enum BannerType: String, Codable {
    case banner_link = "LINK"
    case banner_video = "VIDEO"
    case banner_ad = "VIDEO-AD"
    case banner_internalLink = "INTERNAL-LINK"
}

struct BannerModel: Codable {
    var id: Int?
    var video_id: Int?
    var key: String?
    var title: String?
    var type: BannerType?
    var cover_oss_path: String?
    var redirect_url: String?
    var redirect_position: RedirectURLPosition?
}

///跳转到内页的枚举
enum RedirectURLPosition: String, Codable {
    case MEMBER_CENTER = "MEMBER_CENTER"
    case TASK_INTERFACE = "TASK_INTERFACE"
    case LU_FRIENDLY = "LU_FRIENDLY"
    case DEFAULTSTRING = ""
}

