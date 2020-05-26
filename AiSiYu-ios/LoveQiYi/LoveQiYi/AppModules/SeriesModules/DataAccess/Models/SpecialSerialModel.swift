//
//  SpecialSerialModel.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/22.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//  精选系列列表模型

import Foundation

struct SpecialSerialListModel: Codable {
    var current_Page: String?
    var data: [SpecialSerialModel]?
}

struct SpecialSerialModel: Codable {
    var id: Int?
    var title: String?
    var cover_oss_filename: String?
    var intro: String?
    var sort: Int?
    var status: Int?
    var created_at: String?
    var updated_at: String?
    var deleted_at: String?
}
