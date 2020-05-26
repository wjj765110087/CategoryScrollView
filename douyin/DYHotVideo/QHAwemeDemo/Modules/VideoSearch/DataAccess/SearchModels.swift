//
//  SearchModels.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/10.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation

struct SearchLikeKey: Codable {
    var id: Int?
    var title: String?
}

///搜索用户列表
struct SearchUserListModel: Codable {
    var current_page: Int?
    var data: [FlowUsers]?
    var total: Int?
}

//struct SearchUserModel: Codable {
//    var id: Int?
//    var name: String?
//    var nikename: String?
//    var mobile: String?
//    var cover_path: String?
//    var created_at: String?
//    var _realation: FollowOrCancelModel?
//}
