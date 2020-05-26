//
//  AlertManagerModels.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/25.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation

struct SystemAlertModel: Codable {
    var title: String?
    var englishTitle: String?
    var msgInfo: String?
    var tipsMsg: String?
    var commitTitle: String?
    var isLinkType: Bool?  = false
}

struct ConvertCardAlertModel: Codable {
    var title: String?
    var msgInfo: String?
    var success: Bool = false
}
