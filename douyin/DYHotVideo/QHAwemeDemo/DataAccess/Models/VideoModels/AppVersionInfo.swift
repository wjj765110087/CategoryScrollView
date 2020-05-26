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
    var wallet_url: String?
    var app_rule: AppRule?
}

///用户提现的费率和最小最大体现金额
struct AppRule: Codable {
    var fee: String?
    var money: String?
    var min_coins: String?
    var max_coins: String?
}

/// App闪屏广告
struct AdSplashModel: Codable {
    var id: Int?
    var title: String?
    var ad_path: String?
    var status: Int?
    var href: String?
    var created_at: String?
}
