//
//  AppVersionInfo.swift
//  XSVideo
//
//  Created by pro5 on 2019/1/5.
//  Copyright © 2019年 pro5. All rights reserved.
//

import Foundation

/// 是否强制更新
enum ForceUpdate: Int, Codable {
    case normalUpdate = 0
    case forceUpdate = 1
    
    var isForce: Bool {
        switch self {
        case .forceUpdate:
            return true
        case .normalUpdate:
            return false
        }
    }
}

/// APP检查更新
struct AppVersionInfo: Codable {
    var id: Int?
    var title: String?
    var remark: String?
    var platform: String?
    var force: ForceUpdate?
    var version_code: String?
    var package_path: String?
    var share_url: String?
    var extend: String?
    var created_at: String?
    var updated_at: String?
    var share_text: String?
    var potato_invite_link: String?
    var official_url: String?
    var static_url: String?
    var file_upload_url: String?
    var help_url: String?
    var fiction_info_url: String?
}

struct AdSplashModel: Codable {
    var startup: AdSSModel?
    var reload: AdSSModel?
}

/// App闪屏广告
struct AdSSModel: Codable {
    var id: Int?
    var title: String?
    var ad_path: String?
    var status: Int?
    var href: String?
    var created_at: String?
}

/// 线路检测
struct ChanleTimeModel: Codable {
    var mothUrl: String?
    var time: Float64?
    var status: Int?
}

/// 线路
struct VideoChannelModel: Codable {
    var id: Int?
    var title: String?
    var key: String?
    var domain: String?
    var status: Int?
    var sort: Int?
    var remark: String?
    var created_at: String?
    var updated_at: String?
}

/// 系统公告
struct SystemMsgModel: Codable {
    var id: Int?
    var msg: String?
    var status: Int?
    var created_at: String?
    var updated_at: String?
}

/// 验证码对象
struct CodeModel: Codable {
    var verification_key: String?
    var expiredAt: String?
    var verification_code: String?
}
