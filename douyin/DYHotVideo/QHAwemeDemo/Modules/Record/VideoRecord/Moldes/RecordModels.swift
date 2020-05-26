//
//  RecordModels.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/5/2.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation

struct CateListModel: Codable {
    var current_page: Int?
    var data: [CateSectionModel]?
}

struct CateSectionModel: Codable {
    var id: Int?
    var title: String?
    var type_list: [CateTagModel]?
}

struct CateTagModel: Codable {
    var id: Int?
    var title: String?
    var isSelected: Bool? = false
}

struct PushVideoModel {
    var videoCover: UIImage?          // 视频封面图
    var videoUrl: URL?                // 视频本地路径
    var commitParams: [String: Any]?  // 提交接口所需参数
}

/// 视频上传成功回调model
struct PushVideoBackModel: Codable {
    var file_name: String?
    var file_content_type: String?
    var file_path: String?
    var file_size: String?
}
