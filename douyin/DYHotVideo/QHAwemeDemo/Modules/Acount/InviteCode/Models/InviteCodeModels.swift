//
//  InviteCodeModels.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/18.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation


/// 邀请规则model
struct InviteRuleModel: Codable {
    var person: Int?
    var view_daily: Int?
   
    var welfare_id: Int?
    var title: String?
    var remark: String?
    var discount: String?   // 折扣
    var invite_count: String?
    
}
